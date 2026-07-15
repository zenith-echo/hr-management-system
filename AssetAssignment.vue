<template>
  <page-container title="资产分配管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>新增分配
      </el-button>
    </template>

    <!-- 搜索栏 -->
    <template #search>
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="资产">
          <el-select
            v-model="searchForm.assetId"
            placeholder="请选择资产"
            clearable
            filterable
            :filter-method="filterAssets"
            style="width: 220px"
          >
            <el-option
              v-for="item in filteredAssetOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <span style="float: left">{{ item.label }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">
                ID: {{ item.value }}
              </span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="使用人">
          <el-select
            v-model="searchForm.employeeId"
            placeholder="请选择使用人"
            clearable
            filterable
            :filter-method="filterEmployees"
            style="width: 220px"
          >
            <el-option
              v-for="item in filteredEmployeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <span style="float: left">{{ item.label }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">
                ID: {{ item.value }}
              </span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="searchForm.status"
            placeholder="请选择状态"
            clearable
            style="width: 150px"
          >
            <el-option
              v-for="item in statusOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="关键字">
          <el-input
            v-model="searchForm.keyword"
            placeholder="请输入备注关键字"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>搜索
          </el-button>
          <el-button @click="resetSearch">
            <el-icon><Refresh /></el-icon>重置
          </el-button>
        </el-form-item>
      </el-form>
    </template>

    <!-- 表格内容 -->
    <el-table
      :data="tableData"
      style="width: 100%"
      border
      stripe
      v-loading="loading"
    >
      <el-table-column
        prop="assetId"
        label="资产编号"
        width="100"
        align="center"
      />
      <el-table-column
        prop="assetName"
        label="资产名称"
        min-width="120"
        show-overflow-tooltip
      />
      <el-table-column
        prop="employeeId"
        label="员工ID"
        width="100"
        align="center"
      />
      <el-table-column
        prop="employeeName"
        label="使用人"
        width="120"
        align="center"
      />
      <el-table-column
        prop="assignDate"
        label="分配日期"
        width="120"
        align="center"
      />
      <el-table-column
        prop="returnDate"
        label="归还日期"
        width="120"
        align="center"
      >
        <template #default="scope">
          {{ scope.row.returnDate || "未归还" }}
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="100" align="center">
        <template #default="scope">
          <el-tag
            :type="scope.row.returnDate ? 'success' : 'warning'"
            effect="light"
          >
            {{ scope.row.returnDate ? "已归还" : "未归还" }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="notes"
        label="备注"
        min-width="120"
        show-overflow-tooltip
      />
      <el-table-column label="操作" width="120" fixed="right" align="center">
        <template #default="scope">
          <el-button-group>
            <el-tooltip
              :content="scope.row.returnDate ? '编辑' : '归还'"
              placement="top"
            >
              <el-button
                type="primary"
                link
                @click="
                  scope.row.returnDate
                    ? handleEdit(scope.row)
                    : handleReturn(scope.row)
                "
              >
                <el-icon>
                  <component :is="scope.row.returnDate ? Edit : Check" />
                </el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="删除" placement="top">
              <div>
                <el-popconfirm
                  title="确认删除该分配记录吗？"
                  confirm-button-text="确定"
                  cancel-button-text="取消"
                  @confirm="handleDelete(scope.row)"
                >
                  <template #reference>
                    <el-button type="danger" link>
                      <el-icon><Delete /></el-icon>
                    </el-button>
                  </template>
                </el-popconfirm>
              </div>
            </el-tooltip>
          </el-button-group>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <template #pagination>
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </template>

    <!-- 新增/编辑分配对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增分配' : '编辑分配'"
      width="500px"
      :close-on-click-modal="false"
      @closed="resetForm"
    >
      <el-form
        ref="assignmentFormRef"
        :model="assignmentForm"
        :rules="rules"
        label-width="100px"
        :validate-on-rule-change="false"
      >
        <el-form-item label="资产" prop="assetId">
          <el-select
            v-model="assignmentForm.assetId"
            placeholder="请选择资产"
            :disabled="dialogType === 'edit'"
            filterable
            :filter-method="filterAssets"
            style="width: 100%"
          >
            <el-option
              v-for="item in dialogType === 'edit'
                ? assetOptions.value
                : availableAssets"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <span style="float: left">{{ item.label }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">
                ID: {{ item.value }}
              </span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="使用人" prop="employeeId">
          <el-select
            v-model="assignmentForm.employeeId"
            placeholder="请选择使用人"
            :disabled="dialogType === 'edit'"
            filterable
            :filter-method="filterEmployees"
            style="width: 100%"
          >
            <el-option
              v-for="item in filteredEmployeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <span style="float: left">{{ item.label }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">
                ID: {{ item.value }}
              </span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="分配日期" prop="assignDate">
          <el-date-picker
            v-model="assignmentForm.assignDate"
            type="date"
            placeholder="选择日期"
            :disabled="dialogType === 'edit'"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item
          label="归还日期"
          prop="returnDate"
          v-if="dialogType === 'edit'"
        >
          <el-date-picker
            v-model="assignmentForm.returnDate"
            type="date"
            placeholder="选择日期"
            value-format="YYYY-MM-DD"
            :disabled="!!assignmentForm.returnDate"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="备注" prop="notes">
          <el-input
            v-model="assignmentForm.notes"
            type="textarea"
            :rows="3"
            placeholder="请输入备注信息"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm" :loading="submitting">
            确定
          </el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 资产归还对话框 -->
    <el-dialog
      v-model="returnDialogVisible"
      title="资产归还"
      width="500px"
      :close-on-click-modal="false"
      @closed="resetReturnForm"
    >
      <el-form
        ref="returnFormRef"
        :model="returnForm"
        :rules="returnRules"
        label-width="100px"
        :validate-on-rule-change="false"
      >
        <el-form-item label="归还日期" prop="returnDate">
          <el-date-picker
            v-model="returnForm.returnDate"
            type="date"
            placeholder="选择日期"
            value-format="YYYY-MM-DD"
            :disabled-date="(time) => time > new Date()"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="备注" prop="notes">
          <el-input
            v-model="returnForm.notes"
            type="textarea"
            :rows="3"
            placeholder="请输入备注信息"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="returnDialogVisible = false">取消</el-button>
          <el-button
            type="primary"
            @click="submitReturnForm"
            :loading="submitting"
          >
            确定
          </el-button>
        </span>
      </template>
    </el-dialog>
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch, computed } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { useRoute } from "vue-router";
import api from "../../api/assetAssignment";
import assetApi from "../../api/asset";
import employeeApi from "../../api/employee";
import {
  Plus,
  Edit,
  Delete,
  Check,
  Search,
  Refresh,
} from "@element-plus/icons-vue";
import PageContainer from "../../components/PageContainer.vue";

const route = useRoute();

// 表单引用
const assignmentFormRef = ref(null);
const returnFormRef = ref(null);

// 搜索表单
const searchForm = reactive({
  keyword: "",
  assetId: null,
  employeeId: null,
  status: "",
});

// 表格数据
const tableData = ref([]);
const loading = ref(false);
const submitting = ref(false);

// 分页
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const assignmentForm = reactive({
  assetId: "",
  employeeId: "",
  assignDate: "",
  returnDate: "",
  notes: "",
});

// 归还对话框
const returnDialogVisible = ref(false);
const returnForm = reactive({
  assignmentId: null,
  returnDate: "",
  notes: "",
});

// 表单规则
const rules = {
  assetId: [
    { required: true, message: "请选择资产", trigger: "change" },
    { type: "number", message: "资产ID必须为数字", trigger: "change" },
  ],
  employeeId: [
    { required: true, message: "请选择使用人", trigger: "change" },
    { type: "number", message: "员工ID必须为数字", trigger: "change" },
  ],
  assignDate: [
    { required: true, message: "请选择分配日期", trigger: "change" },
  ],
  returnDate: [
    { required: false, message: "请选择归还日期", trigger: "change" },
  ],
  notes: [{ max: 500, message: "备注不能超过500个字符", trigger: "blur" }],
};

// 归还表单规则
const returnRules = {
  returnDate: [
    { required: true, message: "请选择归还日期", trigger: "change" },
    {
      validator: (rule, value, callback) => {
        if (!value) {
          callback(new Error("请选择归还日期"));
          return;
        }
        const returnDate = new Date(value);
        const today = new Date();
        if (returnDate > today) {
          callback(new Error("归还日期不能晚于今天"));
          return;
        }
        callback();
      },
      trigger: "change",
    },
  ],
  notes: [{ max: 500, message: "备注不能超过500个字符", trigger: "blur" }],
};

// 资产和员工选项
const assetOptions = ref([]);
const employeeOptions = ref([]);

// 添加资产和员工的映射表
const assetMap = ref({});
const employeeMap = ref({});

// 添加过滤选项的计算属性和方法
const assetSearchKeyword = ref("");
const employeeSearchKeyword = ref("");

const filteredAssetOptions = ref([]);
const filteredEmployeeOptions = ref([]);

// 状态选项
const statusOptions = [
  {
    value: "assigned",
    label: "未归还",
    description: "资产正在使用中",
  },
  {
    value: "returned",
    label: "已归还",
    description: "资产已归还",
  },
];

// 计算可用的资产选项（已归还的资产）
const availableAssets = computed(() => {
  // 获取所有已分配且未归还的资产ID
  const assignedAssetIds = new Set(
    tableData.value
      .filter((item) => !item.returnDate)
      .map((item) => item.assetId)
  );

  // 过滤出未分配或已归还的资产
  return assetOptions.value.filter(
    (asset) => !assignedAssetIds.has(asset.value)
  );
});

// 初始化过滤选项
const initFilteredOptions = () => {
  filteredAssetOptions.value = assetOptions.value;
  filteredEmployeeOptions.value = employeeOptions.value;
};

// 过滤资产选项
const filterAssets = (query) => {
  if (query !== "") {
    filteredAssetOptions.value = assetOptions.value.filter((item) => {
      return (
        item.label.toLowerCase().includes(query.toLowerCase()) ||
        item.value.toString().includes(query)
      );
    });
  } else {
    filteredAssetOptions.value = assetOptions.value;
  }
};

// 过滤员工选项
const filterEmployees = (query) => {
  if (query !== "") {
    filteredEmployeeOptions.value = employeeOptions.value.filter((item) => {
      return (
        item.label.toLowerCase().includes(query.toLowerCase()) ||
        item.value.toString().includes(query)
      );
    });
  } else {
    filteredEmployeeOptions.value = employeeOptions.value;
  }
};

// 监听选项变化
watch(assetOptions, () => {
  initFilteredOptions();
});

watch(employeeOptions, () => {
  initFilteredOptions();
});

// 获取资产列表
const fetchAssets = async () => {
  try {
    const res = await assetApi.getAssetsPage({
      pageNum: 1,
      pageSize: 1000, // 增加页面大小以获取更多数据
    });
    console.log("获取资产列表结果:", res);
    if (res.data.code === 0) {
      const assetList = res.data.data.list;
      // 更新选项列表
      assetOptions.value = assetList.map((item) => ({
        value: item.assetId,
        label: `${item.assetName} (${item.assetId})`,
      }));
      // 更新映射表
      assetMap.value = Object.fromEntries(
        assetList.map((item) => [item.assetId, item.assetName])
      );
      console.log("资产映射表:", assetMap.value);
    } else {
      throw new Error(res.data.msg || "获取资产列表失败");
    }
  } catch (error) {
    console.error("获取资产列表失败:", error);
    ElMessage.error("获取资产列表失败");
  }
};

// 获取员工列表
const fetchEmployees = async () => {
  try {
    const res = await employeeApi.getEmployeesPage({
      pageNum: 1,
      pageSize: 1000, // 增加页面大小以获取更多数据
    });
    console.log("获取员工列表结果:", res);
    if (res.data.code === 0) {
      const employeeList = res.data.data.list;
      // 更新选项列表
      employeeOptions.value = employeeList.map((item) => ({
        value: item.employeeId,
        label: `${item.name} (${item.employeeId})`,
      }));
      // 更新映射表
      employeeMap.value = Object.fromEntries(
        employeeList.map((item) => [item.employeeId, item.name])
      );
      console.log("员工映射表:", employeeMap.value);
    } else {
      throw new Error(res.data.msg || "获取员工列表失败");
    }
  } catch (error) {
    console.error("获取员工列表失败:", error);
    ElMessage.error("获取员工列表失败，请稍后重试");
  }
};

// 获取分配记录列表
const fetchAssignmentList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      keyword: searchForm.keyword,
      assetId: searchForm.assetId,
      employeeId: searchForm.employeeId,
      status: searchForm.status,
    };

    console.log("查询参数:", params);
    const res = await api.getAssignmentPage(params);
    console.log("查询结果:", res);

    if (res.data.code === 0) {
      // 确保资产和员工映射表已更新
      await Promise.all([fetchAssets(), fetchEmployees()]);

      tableData.value = res.data.data.list.map((item) => {
        // 获取资产和员工信息
        const asset = assetMap.value[item.assetId];
        const employee = employeeMap.value[item.employeeId];

        return {
          ...item,
          assetId: item.assetId,
          assetName: item.assetName || (asset ? asset : "未知资产"),
          employeeId: item.employeeId,
          employeeName: item.employeeName || (employee ? employee : "未知员工"),
          assignDate: formatDate(item.assignDate),
          returnDate: item.returnDate ? formatDate(item.returnDate) : null,
          notes: item.notes || "-",
        };
      });

      console.log("处理后的表格数据:", tableData.value);
      total.value = res.data.data.total;
    } else {
      throw new Error(res.data.msg || "获取分配记录失败");
    }
  } catch (error) {
    console.error("获取分配记录失败:", error);
    ElMessage.error(error.message || "获取分配记录失败");
  } finally {
    loading.value = false;
  }
};

// 添加日期格式化函数
const formatDate = (date) => {
  if (!date) return "";
  return new Date(date).toLocaleDateString();
};

// 添加日期格式化函数
const formatDateForSubmit = (date) => {
  if (!date) return null;
  // 确保日期格式为 YYYY-MM-DD
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1;
  fetchAssignmentList();
};

const resetSearch = () => {
  Object.keys(searchForm).forEach((key) => {
    searchForm[key] = Array.isArray(searchForm[key]) ? [] : "";
  });
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  fetchAssignmentList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  fetchAssignmentList();
};

// 重置表单
const resetForm = () => {
  if (assignmentFormRef.value) {
    assignmentFormRef.value.resetFields();
  }
  Object.assign(assignmentForm, {
    assetId: "",
    employeeId: "",
    assignDate: "",
    returnDate: "",
    notes: "",
  });
};

// 重置归还表单
const resetReturnForm = () => {
  if (returnFormRef.value) {
    returnFormRef.value.resetFields();
  }
  Object.assign(returnForm, {
    assignmentId: null,
    returnDate: "",
    notes: "",
  });
};

// 表单处理
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  resetForm();
};

const handleEdit = async (row) => {
  try {
    console.log("开始编辑的行数据:", row);
    dialogType.value = "edit";
    dialogVisible.value = true;

    // 直接使用表格中的数据进行回显，确保日期格式正确
    Object.assign(assignmentForm, {
      assignmentId: row.assignmentId,
      assetId: row.assetId,
      employeeId: row.employeeId,
      assignDate: formatDateForEdit(row.assignDate),
      returnDate: formatDateForEdit(row.returnDate),
      notes: row.notes === "-" ? "" : row.notes,
    });

    console.log("编辑表单数据:", assignmentForm);
  } catch (error) {
    console.error("编辑操作失败:", error);
    ElMessage.error(error.message || "编辑操作失败");
  }
};

// 添加日期格式化函数，专门用于编辑表单
const formatDateForEdit = (date) => {
  if (!date) return "";
  // 处理可能的日期格式，确保返回 YYYY-MM-DD 格式
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该分配记录吗？", "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  }).then(async () => {
    try {
      const res = await api.deleteAssignment(row.assignmentId);
      if (res.data.code === 0) {
        ElMessage.success("删除成功");
        fetchAssignmentList();
      } else {
        throw new Error(res.data.msg || "删除失败");
      }
    } catch (error) {
      console.error("删除分配记录失败:", error);
      ElMessage.error(error.message || "删除失败");
    }
  });
};

const handleReturn = (row) => {
  console.log("开始归还的行数据:", row);
  returnDialogVisible.value = true;
  // 重置归还表单数据
  Object.assign(returnForm, {
    assignmentId: row.assignmentId,
    returnDate: "",
    notes: "",
  });
  console.log("初始化归还表单数据:", returnForm);
};

const submitForm = async () => {
  if (!assignmentFormRef.value) {
    console.error("表单引用不存在");
    return;
  }

  try {
    await assignmentFormRef.value.validate();
    submitting.value = true;
    const submitData = {
      ...assignmentForm,
      assetId: Number(assignmentForm.assetId),
      employeeId: Number(assignmentForm.employeeId),
      assignDate: assignmentForm.assignDate,
      returnDate: assignmentForm.returnDate || null,
    };

    // 如果是编辑模式，只允许修改归还日期和备注
    if (dialogType.value === "edit") {
      submitData.assignmentId = Number(assignmentForm.assignmentId);
    }

    console.log("提交数据:", submitData);
    const res = await (dialogType.value === "add"
      ? api.addAssignment(submitData)
      : api.updateAssignment(submitData));

    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "add" ? "新增成功" : "修改成功");
      dialogVisible.value = false;
      fetchAssignmentList();
    } else {
      throw new Error(
        res.data.msg || (dialogType.value === "add" ? "新增失败" : "修改失败")
      );
    }
  } catch (error) {
    console.error("提交表单失败:", error);
    ElMessage.error(
      error.message || (dialogType.value === "add" ? "新增失败" : "修改失败")
    );
  } finally {
    submitting.value = false;
  }
};

const submitReturnForm = async () => {
  if (!returnFormRef.value) return;

  try {
    await returnFormRef.value.validate();
    submitting.value = true;

    // 获取当前分配记录的完整信息
    const currentAssignment = tableData.value.find(
      (item) => item.assignmentId === returnForm.assignmentId
    );

    if (!currentAssignment) {
      throw new Error("未找到当前分配记录");
    }

    // 确保所有必要字段都存在且类型正确
    const submitData = {
      assignmentId: Number(returnForm.assignmentId),
      assetId: Number(currentAssignment.assetId),
      employeeId: Number(currentAssignment.employeeId),
      assignDate: formatDateForSubmit(currentAssignment.assignDate),
      returnDate: formatDateForSubmit(returnForm.returnDate),
      notes: returnForm.notes?.trim() || currentAssignment.notes || "",
    };

    // 打印完整的提交数据用于调试
    console.log("归还提交数据:", {
      原始数据: returnForm,
      当前记录: currentAssignment,
      提交数据: submitData,
    });

    const res = await api.updateAssignment(submitData);

    if (res.data.code === 0) {
      ElMessage.success("归还成功");
      returnDialogVisible.value = false;
      fetchAssignmentList();
    } else {
      throw new Error(res.data.msg || "归还失败");
    }
  } catch (error) {
    console.error("提交归还表单失败:", error);
    if (error.response) {
      console.error("错误响应数据:", error.response.data);
    }
    ElMessage.error(error.message || "归还失败");
  } finally {
    submitting.value = false;
  }
};

// 初始化
onMounted(() => {
  Promise.all([fetchAssets(), fetchEmployees()]).then(() => {
    initFilteredOptions();
    const assetId = route.query.assetId;
    if (assetId) {
      searchForm.assetId = assetId;
    }
    fetchAssignmentList();
  });
});
</script>

<style scoped>
.asset-assignment {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

:deep(.el-button) {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

:deep(.el-button .el-icon) {
  margin-right: 2px;
}

:deep(.el-input-number .el-input__inner) {
  text-align: left;
}

:deep(.el-table) {
  --el-table-header-bg-color: var(--el-color-primary-light-9);
  --el-table-border-color: var(--el-border-color-lighter);
  --el-table-header-text-color: var(--el-text-color-primary);
}

:deep(.el-table th) {
  font-weight: 600;
  color: var(--el-table-header-text-color);
  background: var(--el-table-header-bg-color);
}

:deep(.el-table td) {
  padding: 8px 0;
}

:deep(.el-form-item__label) {
  font-weight: 500;
}

:deep(.el-button.is-link) {
  padding: 4px 8px;
}

:deep(.el-dialog__header) {
  margin-right: 0;
  border-bottom: 1px solid var(--el-border-color-lighter);
  padding: 20px;
}

:deep(.el-dialog__footer) {
  border-top: 1px solid var(--el-border-color-lighter);
  padding: 20px;
}

:deep(.el-button-group) {
  display: inline-flex;
  gap: 4px;
}

:deep(.el-select),
:deep(.el-date-picker) {
  width: 220px;
}

:deep(.el-dialog__body) {
  padding: 20px 30px;
}

:deep(.el-form--inline .el-form-item) {
  margin-right: 20px;
}
</style>
