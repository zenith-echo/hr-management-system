<template>
  <page-container title="请假管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>申请请假
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="员工">
          <el-select
            v-model="searchForm.employeeId"
            placeholder="请选择员工"
            clearable
            filterable
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="请假类型">
          <el-select
            v-model="searchForm.leaveType"
            placeholder="请选择类型"
            clearable
          >
            <el-option
              v-for="(type, index) in leaveTypes"
              :key="index"
              :label="type"
              :value="type"
            >
              <el-tag size="small" :type="getLeaveTypeTagType(type)">
                {{ type }}
              </el-tag>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="日期">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            clearable
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>查询
          </el-button>
          <el-button @click="resetSearch">
            <el-icon><Refresh /></el-icon>重置
          </el-button>
        </el-form-item>
      </el-form>
    </template>

    <!-- 表格内容 -->
    <el-table
      v-loading="loading"
      :data="tableData"
      style="width: 100%"
      border
      stripe
    >
      <el-table-column type="index" label="序号" width="60" align="center" />
      <el-table-column prop="employeeName" label="员工姓名" width="120" />
      <el-table-column prop="leaveType" label="请假类型" width="100">
        <template #default="scope">
          <el-tag size="small" :type="getLeaveTypeTagType(scope.row.leaveType)">
            {{ scope.row.leaveType }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="startDate" label="开始日期" width="120" />
      <el-table-column prop="endDate" label="结束日期" width="120" />
      <el-table-column
        prop="duration"
        label="时长(天)"
        width="100"
        align="center"
      />
      <el-table-column prop="approverName" label="审批人" width="120" />
      <el-table-column
        prop="reason"
        label="请假原因"
        min-width="200"
        show-overflow-tooltip
      />
      <el-table-column label="操作" width="120" fixed="right" align="center">
        <template #default="scope">
          <el-button-group>
            <el-tooltip content="编辑" placement="top">
              <el-button type="primary" link @click="handleEdit(scope.row)">
                <el-icon><Edit /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="删除" placement="top">
              <el-button type="danger" link @click="handleDelete(scope.row)">
                <el-icon><Delete /></el-icon>
              </el-button>
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

    <!-- 请假表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '申请请假' : '编辑请假'"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="leaveFormRef"
        :model="leaveForm"
        :rules="leaveRules"
        label-width="100px"
      >
        <el-form-item label="员工" prop="employeeId">
          <el-select
            v-model="leaveForm.employeeId"
            placeholder="请选择员工"
            style="width: 100%"
            filterable
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="请假类型" prop="leaveType">
          <el-select
            v-model="leaveForm.leaveType"
            placeholder="请选择类型"
            style="width: 100%"
          >
            <el-option
              v-for="(type, index) in leaveTypes"
              :key="index"
              :label="type"
              :value="type"
            >
              <el-tag size="small" :type="getLeaveTypeTagType(type)">
                {{ type }}
              </el-tag>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="开始日期" prop="startDate">
          <el-date-picker
            v-model="leaveForm.startDate"
            type="date"
            placeholder="选择开始日期"
            style="width: 100%"
            @change="calculateDuration"
          />
        </el-form-item>
        <el-form-item label="结束日期" prop="endDate">
          <el-date-picker
            v-model="leaveForm.endDate"
            type="date"
            placeholder="选择结束日期"
            style="width: 100%"
            @change="calculateDuration"
          />
        </el-form-item>
        <el-form-item label="时长(天)" prop="duration">
          <el-input-number
            v-model="leaveForm.duration"
            :min="0.5"
            :step="0.5"
            style="width: 100%"
            disabled
          />
        </el-form-item>
        <el-form-item label="审批人" prop="approverId">
          <el-select
            v-model="leaveForm.approverId"
            placeholder="请选择审批人"
            style="width: 100%"
            filterable
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="请假原因" prop="reason">
          <el-input
            v-model="leaveForm.reason"
            type="textarea"
            :rows="3"
            placeholder="请输入请假原因"
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
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from "vue";
import { Plus, Edit, Delete, Search, Refresh } from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";
import leaveApi from "@/api/leave";
import employeeApi from "@/api/employee";
import PageContainer from "@/components/PageContainer.vue";

// 请假类型
const leaveTypes = ["事假", "病假", "年假", "调休", "婚假", "产假", "丧假"];

// 获取请假类型对应的标签类型
const getLeaveTypeTagType = (type) => {
  const typeMap = {
    事假: "info",
    病假: "danger",
    年假: "success",
    调休: "warning",
    婚假: "success",
    产假: "success",
    丧假: "info",
  };
  return typeMap[type] || "info";
};

// 日期格式化函数
const formatDate = (date) => {
  if (!date) return "";
  if (typeof date === "string") {
    date = new Date(date);
  }
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

const formatDisplayDate = (dateStr) => {
  if (!dateStr) return "";
  const date = new Date(dateStr);
  if (isNaN(date.getTime())) return dateStr;
  return formatDate(date);
};

// 表格数据
const loading = ref(false);
const tableData = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 搜索表单
const searchForm = reactive({
  employeeId: "",
  leaveType: "",
  dateRange: null,
});

// 请假表单
const dialogVisible = ref(false);
const dialogType = ref("add"); // add, edit
const leaveFormRef = ref(null);
const leaveForm = reactive({
  recordId: "",
  employeeId: "",
  leaveType: "",
  startDate: "",
  endDate: "",
  duration: 0,
  reason: "",
  approverId: "",
});

// 审批表单
const approveDialogVisible = ref(false);
const approveFormRef = ref(null);
const approveForm = reactive({
  recordId: "",
  status: "已通过",
  comment: "",
  approverId: "",
});

// 表单验证规则
const leaveRules = {
  employeeId: [
    { required: true, message: "请选择员工", trigger: "change" },
    { type: "number", transform: (value) => Number(value) },
  ],
  leaveType: [{ required: true, message: "请选择请假类型", trigger: "change" }],
  startDate: [{ required: true, message: "请选择开始日期", trigger: "change" }],
  endDate: [{ required: true, message: "请选择结束日期", trigger: "change" }],
  reason: [{ required: true, message: "请输入请假原因", trigger: "blur" }],
  approverId: [
    { required: true, message: "请选择审批人", trigger: "change" },
    { type: "number", transform: (value) => Number(value) },
  ],
};

const approveRules = {
  status: [{ required: true, message: "请选择审批结果", trigger: "change" }],
  comment: [{ required: true, message: "请输入审批意见", trigger: "blur" }],
};

// 员工选项
const employeeOptions = ref([]);

// 获取状态对应的标签类型
const getStatusType = (status) => {
  const statusMap = {
    待审批: "warning",
    已通过: "success",
    已驳回: "danger",
  };
  return statusMap[status] || "";
};

// 计算请假时长
const calculateDuration = () => {
  if (leaveForm.startDate && leaveForm.endDate) {
    const start = new Date(leaveForm.startDate);
    const end = new Date(leaveForm.endDate);
    const days = (end - start) / (1000 * 60 * 60 * 24) + 1;
    leaveForm.duration = days;
  }
};

// 获取请假记录列表
const getLeaveList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
    };

    // 只有当有值时才添加到查询参数中
    if (searchForm.employeeId) {
      params.employeeId = parseInt(searchForm.employeeId);
    }
    if (searchForm.leaveType) {
      params.leaveType = searchForm.leaveType;
    }
    if (
      searchForm.dateRange &&
      searchForm.dateRange[0] &&
      searchForm.dateRange[1]
    ) {
      params.startDate = formatDate(searchForm.dateRange[0]);
      params.endDate = formatDate(searchForm.dateRange[1]);
    }

    const response = await leaveApi.getLeavePage(params);
    console.log("查询参数：", params);
    console.log("获取请假记录响应：", response);

    if (response.data && response.data.data) {
      const { list, total: totalCount } = response.data.data;

      // 获取所有涉及的员工ID（包括申请人和审批人）
      const employeeIds = new Set();
      list.forEach((item) => {
        employeeIds.add(item.employeeId);
        if (item.approverId) {
          employeeIds.add(item.approverId);
        }
      });

      // 获取员工信息
      const employeeMap = new Map();
      if (employeeIds.size > 0) {
        try {
          await Promise.all(
            Array.from(employeeIds).map(async (id) => {
              const empResponse = await employeeApi.getEmployeeById(id);
              if (empResponse.data && empResponse.data.data) {
                const emp = empResponse.data.data;
                employeeMap.set(emp.employeeId, {
                  name: emp.name,
                });
              }
            })
          );
        } catch (error) {
          console.warn("获取部分员工信息失败", error);
        }
      }

      // 处理数据
      tableData.value = list.map((item) => ({
        ...item,
        employeeName: employeeMap.get(item.employeeId)?.name || "未知",
        approverName: item.approverId
          ? employeeMap.get(item.approverId)?.name || "未知"
          : "-",
        startDate: formatDisplayDate(item.startDate),
        endDate: formatDisplayDate(item.endDate),
      }));

      total.value = totalCount;
    } else {
      ElMessage.error("获取请假记录失败");
    }
  } catch (error) {
    console.error("获取请假记录失败", error);
    ElMessage.error(error.message || "获取请假记录失败");
  } finally {
    loading.value = false;
  }
};

// 获取员工列表
const getEmployeeList = async () => {
  try {
    const response = await employeeApi.getEmployeesPage({
      pageSize: 1000, // 获取足够多的员工数据用于下拉选择
      select: "employeeId,name", // 只获取需要的字段
    });

    if (
      response.data &&
      response.data.data &&
      Array.isArray(response.data.data.list)
    ) {
      employeeOptions.value = response.data.data.list.map((emp) => ({
        value: emp.employeeId,
        label: emp.name,
      }));
    } else {
      console.error("获取员工列表失败：", response);
      ElMessage.error("获取员工列表失败");
    }
  } catch (error) {
    console.error("获取员工列表失败", error);
    ElMessage.error(error.message || "获取员工列表失败");
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getLeaveList();
};

// 重置查询条件
const resetSearch = () => {
  searchForm.employeeId = "";
  searchForm.leaveType = "";
  searchForm.dateRange = null;
  handleSearch();
};

// 处理分页大小变化
const handleSizeChange = (val) => {
  pageSize.value = val;
  getLeaveList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getLeaveList();
};

// 处理添加请假
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(leaveForm).forEach((key) => {
    if (key === "duration") {
      leaveForm[key] = 0;
    } else {
      leaveForm[key] = "";
    }
  });
  leaveForm.status = "待审批";

  // 下一个事件循环重置表单验证
  setTimeout(() => {
    leaveFormRef.value?.resetFields();
  });
};

// 处理编辑请假
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(leaveForm).forEach((key) => {
    leaveForm[key] = row[key];
  });
};

// 处理删除请假
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(`确定要删除此请假记录吗？`, "警告", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    const response = await leaveApi.deleteLeave(row.recordId);
    if (response.data && response.data.code === 0) {
      ElMessage.success("删除成功");
      // 如果当前页只有一条数据，且不是第一页，则跳转到上一页
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      getLeaveList();
    } else {
      throw new Error(response.data?.msg || "删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除失败", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

// 添加submitting状态
const submitting = ref(false);

// 修改提交表单函数
const submitForm = () => {
  leaveFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        submitting.value = true;
        // 准备提交数据
        const data = {
          recordId: dialogType.value === "edit" ? leaveForm.recordId : 0,
          employeeId: parseInt(leaveForm.employeeId),
          leaveType: leaveForm.leaveType,
          startDate: formatDate(leaveForm.startDate),
          endDate: formatDate(leaveForm.endDate),
          duration: leaveForm.duration,
          reason: leaveForm.reason?.trim(),
          approverId: parseInt(leaveForm.approverId),
        };

        console.log("提交的请假数据:", data);

        let response;
        if (dialogType.value === "add") {
          response = await leaveApi.addLeave(data);
        } else {
          response = await leaveApi.updateLeave(data);
        }

        console.log("提交请假响应:", response);

        if (response.data && response.data.code === 0) {
          ElMessage.success(
            dialogType.value === "add" ? "添加成功" : "修改成功"
          );
          dialogVisible.value = false;
          getLeaveList();
        } else {
          throw new Error(response.data?.msg || "操作失败");
        }
      } catch (error) {
        console.error("提交失败", error);
        ElMessage.error(error.message || "提交失败");
      } finally {
        submitting.value = false;
      }
    }
  });
};

// 页面加载时获取数据
onMounted(() => {
  getLeaveList();
  getEmployeeList();
});
</script>

<style scoped>
:deep(.el-table) {
  --el-table-header-bg-color: #f5f7fa;
  --el-table-border-color: #ebeef5;
  --el-table-header-text-color: #606266;
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
  color: #606266;
}

:deep(.el-input),
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

:deep(.el-button) {
  font-weight: normal;
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
</style>
