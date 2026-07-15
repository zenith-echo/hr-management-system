<template>
  <page-container title="考勤记录">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>添加记录
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
            @change="handleSearchEmployeeChange"
          >
            <template #default>
              <el-option
                v-for="item in employeeOptions"
                :key="item.value"
                :label="searchEmployeeText || item.label"
                :value="item.value"
              />
            </template>
          </el-select>
        </el-form-item>
        <el-form-item label="日期">
          <el-date-picker
            v-model="searchForm.date"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            clearable
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="searchForm.status"
            placeholder="请选择状态"
            clearable
            @change="handleSearchStatusChange"
          >
            <template #default>
              <el-option
                v-for="(option, index) in statusOptions"
                :key="index"
                :label="
                  searchForm.status === option.value
                    ? searchStatusText
                    : option.label
                "
                :value="option.value"
              />
            </template>
          </el-select>
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
      <el-table-column prop="date" label="日期" width="120" />
      <el-table-column prop="checkInTime" label="签到时间" width="180" />
      <el-table-column prop="checkOutTime" label="签退时间" width="180" />
      <el-table-column prop="status" label="状态" width="100">
        <template #default="scope">
          <el-tag :type="getStatusType(scope.row.status)">
            {{ scope.row.status }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="remark"
        label="备注"
        min-width="200"
        show-overflow-tooltip
      />
      <el-table-column label="操作" width="120" fixed="right" align="center">
        <template #default="scope">
          <el-button-group>
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

    <!-- 考勤记录表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="attendanceFormRef"
        :model="attendanceForm"
        :rules="attendanceRules"
        label-width="100px"
        :disabled="dialogType === 'view'"
      >
        <el-form-item label="员工" prop="employeeId">
          <el-select
            v-model="attendanceForm.employeeId"
            placeholder="请选择员工"
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
        <el-form-item label="日期" prop="date">
          <el-date-picker
            v-model="attendanceForm.date"
            type="date"
            placeholder="选择日期"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="签到时间" prop="checkInTime">
          <el-time-picker
            v-model="attendanceForm.checkInTime"
            placeholder="选择时间"
            style="width: 100%"
            :disabled="attendanceForm.status === '缺勤'"
          />
        </el-form-item>
        <el-form-item label="签退时间" prop="checkOutTime">
          <el-time-picker
            v-model="attendanceForm.checkOutTime"
            placeholder="选择时间"
            style="width: 100%"
            :disabled="attendanceForm.status === '缺勤'"
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select
            v-model="attendanceForm.status"
            placeholder="请选择状态"
            style="width: 100%"
            @change="handleStatusChange"
          >
            <el-option label="正常" value="正常" />
            <el-option label="迟到" value="迟到" />
            <el-option label="早退" value="早退" />
            <el-option label="缺勤" value="缺勤" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input
            v-model="attendanceForm.remark"
            type="textarea"
            :rows="3"
            placeholder="请输入备注"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button
            type="primary"
            @click="submitForm"
            :loading="submitting"
            v-if="dialogType !== 'view'"
          >
            确定
          </el-button>
        </span>
      </template>
    </el-dialog>
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from "vue";
import { Plus, Delete, Search, Refresh } from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";
import attendanceApi from "@/api/attendance";
import employeeApi from "@/api/employee";
import PageContainer from "@/components/PageContainer.vue";

// 格式化日期
const formatDate = (date) => {
  if (!date) return "";
  if (typeof date === "string") {
    return date.split("T")[0];
  }
  if (date instanceof Date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  }
  return "";
};

// 格式化时间
const formatTime = (time) => {
  if (!time) return "";
  if (typeof time === "string") {
    if (time.includes("T")) {
      return time.split("T")[1].split(".")[0];
    }
    return time;
  }
  if (time instanceof Date) {
    const hours = String(time.getHours()).padStart(2, "0");
    const minutes = String(time.getMinutes()).padStart(2, "0");
    const seconds = String(time.getSeconds()).padStart(2, "0");
    return `${hours}:${minutes}:${seconds}`;
  }
  return "";
};

// 格式化显示用的日期
const formatDisplayDate = (dateStr) => {
  if (!dateStr) return "";
  const date = new Date(dateStr);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

// 格式化显示用的时间
const formatDisplayTime = (dateStr) => {
  if (!dateStr) return "";
  const date = new Date(dateStr);
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  const seconds = String(date.getSeconds()).padStart(2, "0");
  return `${hours}:${minutes}:${seconds}`;
};

// 表格数据
const loading = ref(false);
const submitting = ref(false);
const tableData = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 搜索表单
const searchForm = reactive({
  employeeId: "",
  date: "",
  status: "",
});

// 考勤表单
const dialogVisible = ref(false);
const dialogType = ref("add"); // add
const attendanceFormRef = ref(null);
const attendanceForm = reactive({
  recordId: "",
  employeeId: "",
  date: "",
  checkInTime: "",
  checkOutTime: "",
  status: "正常",
  remark: "",
});

// 对话框标题
const dialogTitle = computed(() => {
  const titles = {
    add: "添加记录",
  };
  return titles[dialogType.value];
});

// 表单验证规则
const attendanceRules = {
  employeeId: [{ required: true, message: "请选择员工", trigger: "change" }],
  date: [{ required: true, message: "请选择日期", trigger: "change" }],
  checkInTime: [
    {
      required: true,
      message: "请选择签到时间",
      trigger: "change",
      validator: (rule, value, callback) => {
        if (attendanceForm.status === "缺勤") {
          callback();
        } else if (!value) {
          callback(new Error("请选择签到时间"));
        } else {
          callback();
        }
      },
    },
  ],
  checkOutTime: [
    {
      required: true,
      message: "请选择签退时间",
      trigger: "change",
      validator: (rule, value, callback) => {
        if (attendanceForm.status === "缺勤") {
          callback();
        } else if (!value) {
          callback(new Error("请选择签退时间"));
        } else {
          callback();
        }
      },
    },
  ],
  status: [{ required: true, message: "请选择状态", trigger: "change" }],
};

// 员工选项
const employeeOptions = ref([]);

// 选择的文本
const selectedEmployeeText = ref("");
const selectedStatusText = ref("");
const searchEmployeeText = ref("");
const searchStatusText = ref("");

// 状态选项
const statusOptions = [
  { label: "正常", value: "正常" },
  { label: "迟到", value: "迟到" },
  { label: "早退", value: "早退" },
  { label: "缺勤", value: "缺勤" },
];

// 获取状态对应的标签类型
const getStatusType = (status) => {
  const statusMap = {
    正常: "success",
    迟到: "warning",
    早退: "warning",
    缺勤: "danger",
  };
  return statusMap[status] || "";
};

// 获取员工列表
const getEmployeeList = async () => {
  try {
    const response = await employeeApi.getEmployeesPage({
      pageSize: 1000, // 获取足够多的员工数据用于下拉选择
      select: "employeeId,name,status", // 只获取需要的字段
    });

    console.log("获取员工列表响应：", response);

    if (
      response.data &&
      response.data.data &&
      Array.isArray(response.data.data.list)
    ) {
      employeeOptions.value = response.data.data.list
        .filter((item) => item.status === "在职") // 只显示在职员工
        .map((item) => ({
          value: item.employeeId,
          label: `${item.name}(${item.employeeId})`,
        }));
    } else {
      console.error("员工数据格式不正确：", response);
      ElMessage.error("获取员工列表失败");
    }
  } catch (error) {
    console.error("获取员工列表失败", error);
    ElMessage.error(error.message || "获取员工列表失败");
  }
};

// 获取考勤记录列表
const getAttendanceList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      employeeId: searchForm.employeeId || undefined,
      dateStart: searchForm.date ? formatDate(searchForm.date[0]) : undefined,
      dateEnd: searchForm.date ? formatDate(searchForm.date[1]) : undefined,
      status: searchForm.status || undefined,
    };

    const response = await attendanceApi.getAttendancePage(params);
    console.log("获取考勤记录响应：", response);

    if (response.data && response.data.data) {
      const { list, total: totalCount } = response.data.data;

      // 获取所有涉及的员工ID
      const employeeIds = new Set(list.map((item) => item.employeeId));

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
        date: formatDisplayDate(item.date),
        checkInTime: formatDisplayTime(item.checkInTime),
        checkOutTime: formatDisplayTime(item.checkOutTime),
      }));

      total.value = totalCount;
    } else {
      ElMessage.error("获取考勤记录失败");
    }
  } catch (error) {
    console.error("获取考勤记录失败", error);
    ElMessage.error(error.message || "获取考勤记录失败");
  } finally {
    loading.value = false;
  }
};

// 处理查询
const handleSearch = async () => {
  currentPage.value = 1;
  await getAttendanceList();
};

// 重置查询条件
const resetSearch = async () => {
  Object.keys(searchForm).forEach((key) => {
    searchForm[key] = "";
  });
  searchEmployeeText.value = "";
  searchStatusText.value = "";
  currentPage.value = 1;
  await getAttendanceList();
};

// 处理分页大小变化
const handleSizeChange = async (val) => {
  pageSize.value = val;
  await getAttendanceList();
};

// 处理页码变化
const handleCurrentChange = async (val) => {
  currentPage.value = val;
  await getAttendanceList();
};

// 处理添加记录
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(attendanceForm).forEach((key) => {
    attendanceForm[key] = "";
  });
  attendanceForm.status = "正常";

  // 下一个事件循环重置表单验证
  setTimeout(() => {
    attendanceFormRef.value?.resetFields();
  });
};

// 处理删除记录
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(`确定要删除此考勤记录吗？`, "警告", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    const response = await attendanceApi.deleteAttendance(row.recordId);
    if (
      response.data &&
      (response.data.code === 0 || response.data.code === 200)
    ) {
      ElMessage.success("删除成功");
      // 如果当前页只有一条数据，且不是第一页，则跳转到上一页
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      getAttendanceList();
    } else {
      ElMessage.error(response.data.msg || "删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除失败", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

// 提交表单
const submitForm = () => {
  attendanceFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        submitting.value = true;
        // 确保所有必要字段存在
        if (!attendanceForm.employeeId || !attendanceForm.date) {
          ElMessage.error("请填写完整的考勤信息");
          return;
        }

        // 获取日期字符串
        const dateStr = formatDate(attendanceForm.date);

        // 准备提交数据
        const data = {
          recordId: 0,
          employeeId: parseInt(attendanceForm.employeeId),
          date: dateStr,
          status: attendanceForm.status || "正常",
          remark: attendanceForm.remark?.trim() || "",
        };

        // 如果不是缺勤状态，添加时间信息
        if (attendanceForm.status !== "缺勤") {
          const checkInTimeStr = formatTime(attendanceForm.checkInTime);
          const checkOutTimeStr = formatTime(attendanceForm.checkOutTime);

          // 检查时间格式
          if (!checkInTimeStr || !checkOutTimeStr) {
            ElMessage.error("时间格式不正确");
            return;
          }

          data.checkInTime = checkInTimeStr;
          data.checkOutTime = checkOutTimeStr;
        } else {
          data.checkInTime = null;
          data.checkOutTime = null;
        }

        console.log("提交的考勤数据:", data);

        const response = await attendanceApi.addAttendance(data);
        console.log("添加考勤响应:", response);

        // 检查响应状态
        if (
          response.data === "success" ||
          (response.data && response.data.code === 200) ||
          response.status === 200
        ) {
          ElMessage.success("添加成功");
          dialogVisible.value = false;
          getAttendanceList();
        } else {
          console.warn("未知的响应格式:", response);
          throw new Error(response.data?.msg || response.data || "添加失败");
        }
      } catch (error) {
        console.error("添加失败", error);
        if (error.response?.data?.message) {
          ElMessage.error(error.response.data.message);
        } else {
          ElMessage.error(
            error.message === "success"
              ? "添加成功"
              : error.message || "添加失败，请检查数据格式是否正确"
          );
        }
      } finally {
        submitting.value = false;
      }
    }
  });
};

// 处理查询区域员工选择变化
const handleSearchEmployeeChange = (value) => {
  const selectedEmployee = employeeOptions.value.find(
    (emp) => emp.value === value
  );
  searchEmployeeText.value = selectedEmployee
    ? `选择的员工是${selectedEmployee.label}`
    : "";
};

// 处理查询区域状态选择变化
const handleSearchStatusChange = (value) => {
  searchStatusText.value = value ? `选择的状态是${value}` : "";
};

// 处理状态变化
const handleStatusChange = (value) => {
  if (value === "缺勤") {
    attendanceForm.checkInTime = null;
    attendanceForm.checkOutTime = null;
  }
};

// 页面加载时获取数据
onMounted(() => {
  getEmployeeList();
  getAttendanceList();
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
