<template>
  <div class="policy-acknowledgement">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>政策确认管理</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>新增确认
          </el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="政策">
          <el-select
            v-model="searchForm.policyId"
            placeholder="请选择政策"
            clearable
            style="width: 220px"
          >
            <el-option
              v-for="item in policyOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="员工">
          <el-select
            v-model="searchForm.employeeId"
            placeholder="请选择员工"
            clearable
            style="width: 220px"
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="确认日期">
          <el-date-picker
            v-model="searchForm.acknowledgementDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
            style="width: 240px"
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

      <!-- 确认记录列表 -->
      <el-table
        v-loading="loading"
        :data="tableData"
        style="width: 100%"
        border
        stripe
      >
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column label="政策名称" min-width="200" show-overflow-tooltip>
          <template #default="scope">
            {{ getPolicyName(scope.row.policyId) }}
          </template>
        </el-table-column>
        <el-table-column label="员工姓名" width="120">
          <template #default="scope">
            {{ getEmployeeName(scope.row.employeeId) }}
          </template>
        </el-table-column>
        <el-table-column
          prop="acknowledgementDate"
          label="确认日期"
          width="120"
        >
          <template #default="scope">
            {{ formatDate(scope.row.acknowledgementDate) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="scope">
            <el-button type="primary" link @click="handleView(scope.row)">
              <el-icon><View /></el-icon>查看
            </el-button>
            <el-popconfirm
              title="确定要删除此确认记录吗？"
              @confirm="handleDelete(scope.row)"
            >
              <template #reference>
                <el-button type="danger" link>
                  <el-icon><Delete /></el-icon>删除
                </el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 新增/查看确认对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增确认' : '查看确认'"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="ackFormRef"
        :model="ackForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="政策" prop="policyId">
          <el-select
            v-model="ackForm.policyId"
            placeholder="请选择政策"
            :disabled="dialogType === 'view'"
            style="width: 100%"
          >
            <el-option
              v-for="item in policyOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="员工" prop="employeeId">
          <el-select
            v-model="ackForm.employeeId"
            placeholder="请选择员工"
            :disabled="dialogType === 'view'"
            style="width: 100%"
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="确认日期" prop="acknowledgementDate">
          <el-date-picker
            v-model="ackForm.acknowledgementDate"
            type="date"
            placeholder="选择日期"
            :disabled="dialogType === 'view'"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">关闭</el-button>
          <el-button
            v-if="dialogType === 'add'"
            type="primary"
            @click="submitForm"
            >提交</el-button
          >
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from "vue";
import {
  Plus,
  Edit,
  Delete,
  Search,
  Refresh,
  View,
} from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";
import policyApi from "../../api/compliancePolicy";
import employeeApi from "../../api/employee";
import acknowledgementApi from "../../api/policyAcknowledgement";

// 加载状态
const loading = ref(false);

// 搜索表单
const searchForm = reactive({
  policyId: "",
  employeeId: "",
  acknowledgementDate: [],
});

// 原始表格数据
const rawTableData = ref([]);

// 计算属性：处理后的表格数据
const tableData = computed(() => {
  return rawTableData.value.map((item) => ({
    ...item,
    policyName: getPolicyName(item.policyId),
    employeeName: getEmployeeName(item.employeeId),
  }));
});

const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const ackFormRef = ref(null);
const ackForm = reactive({
  ackId: null,
  policyId: "",
  employeeId: "",
  acknowledgementDate: "",
});

// 表单规则
const rules = {
  policyId: [{ required: true, message: "请选择政策", trigger: "change" }],
  employeeId: [{ required: true, message: "请选择员工", trigger: "change" }],
  acknowledgementDate: [
    { required: true, message: "请选择确认日期", trigger: "change" },
  ],
};

// 政策选项
const policyOptions = ref([]);
// 员工选项
const employeeOptions = ref([]);

// 获取员工姓名
const getEmployeeName = (employeeId) => {
  const employee = employeeOptions.value.find((e) => e.value === employeeId);
  return employee ? employee.label : "未知员工";
};

// 获取政策名称
const getPolicyName = (policyId) => {
  const policy = policyOptions.value.find((p) => p.value === policyId);
  return policy ? policy.label : "未知政策";
};

// 格式化日期
const formatDate = (date) => {
  if (!date) return "";
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

// 获取政策列表
const getPolicyList = async () => {
  try {
    const res = await policyApi.getPolicyPage({
      pageNum: 1,
      pageSize: 1000,
    });
    if (res.data.code === 0) {
      policyOptions.value = (res.data.data.list || []).map((item) => ({
        value: item.policyId,
        label: item.policyName,
      }));
    }
  } catch (error) {
    console.error("获取政策列表失败:", error);
    ElMessage.error("获取政策列表失败");
  }
};

// 获取员工列表
const getEmployeeList = async () => {
  try {
    const res = await employeeApi.getEmployeesPage({
      pageNum: 1,
      pageSize: 1000,
      select: "employeeId,name",
    });
    if (res.data.code === 0) {
      const employees = res.data.data.list || [];
      employeeOptions.value = employees.map((item) => ({
        value: item.employeeId,
        label: item.name,
      }));
    }
  } catch (error) {
    console.error("获取员工列表失败:", error);
    ElMessage.error("获取员工列表失败");
  }
};

// 获取确认记录列表
const getAcknowledgementList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      policyId: searchForm.policyId || null,
      employeeId: searchForm.employeeId || null,
      ackDateStart: searchForm.acknowledgementDate?.[0],
      ackDateEnd: searchForm.acknowledgementDate?.[1],
    };

    const res = await acknowledgementApi.getAcknowledgementPage(params);
    if (res.data.code === 0) {
      rawTableData.value = res.data.data.list || [];
      total.value = res.data.data.total || 0;
    } else {
      throw new Error(res.data.msg || "获取确认记录列表失败");
    }
  } catch (error) {
    console.error("获取确认记录列表失败:", error);
    ElMessage.error(error.message || "获取确认记录列表失败");
  } finally {
    loading.value = false;
  }
};

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1;
  getAcknowledgementList();
};

const resetSearch = () => {
  searchForm.policyId = "";
  searchForm.employeeId = "";
  searchForm.acknowledgementDate = [];
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  getAcknowledgementList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  getAcknowledgementList();
};

// 表单处理
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  Object.keys(ackForm).forEach((key) => {
    ackForm[key] = null;
  });
  if (ackFormRef.value) {
    ackFormRef.value.resetFields();
  }
};

const handleView = async (row) => {
  try {
    const res = await acknowledgementApi.getAcknowledgementById(row.ackId);
    if (res.data.code === 0) {
      dialogType.value = "view";
      dialogVisible.value = true;
      Object.assign(ackForm, res.data.data);
    } else {
      throw new Error(res.data.msg || "获取确认记录详情失败");
    }
  } catch (error) {
    console.error("获取确认记录详情失败:", error);
    ElMessage.error(error.message || "获取确认记录详情失败");
  }
};

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm("确定要删除此确认记录吗？", "警告", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    const res = await acknowledgementApi.deleteAcknowledgement(row.ackId);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      getAcknowledgementList();
    } else {
      throw new Error(res.data.msg || "删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除确认记录失败:", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

const submitForm = async () => {
  if (!ackFormRef.value) return;

  try {
    await ackFormRef.value.validate();

    const res = await acknowledgementApi.addAcknowledgement(ackForm);
    if (res.data.code === 0) {
      ElMessage.success("添加成功");
      dialogVisible.value = false;
      getAcknowledgementList();
    } else {
      throw new Error(res.data.msg || "添加失败");
    }
  } catch (error) {
    console.error("提交表单失败:", error);
    ElMessage.error(error.message || "操作失败");
  }
};

// 页面加载时获取数据
onMounted(() => {
  getPolicyList();
  getEmployeeList();
  getAcknowledgementList();
});
</script>

<style scoped>
.policy-acknowledgement {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.search-form :deep(.el-form-item) {
  margin-right: 0;
  margin-bottom: 10px;
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
</style>
