<template>
  <page-container title="加班管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>申请加班
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
      <el-table-column prop="date" label="加班日期" width="120" />
      <el-table-column prop="startTime" label="开始时间" width="180" />
      <el-table-column prop="endTime" label="结束时间" width="180" />
      <el-table-column
        prop="duration"
        label="时长(小时)"
        width="100"
        align="center"
      />
      <el-table-column prop="approverName" label="审批人" width="120" />
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

    <!-- 加班表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '申请加班' : '编辑加班'"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="overtimeFormRef"
        :model="overtimeForm"
        :rules="overtimeRules"
        label-width="100px"
      >
        <el-form-item label="员工" prop="employeeId">
          <el-select
            v-model="overtimeForm.employeeId"
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
        <el-form-item label="加班日期" prop="date">
          <el-date-picker
            v-model="overtimeForm.date"
            type="date"
            placeholder="选择日期"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-time-picker
            v-model="overtimeForm.startTime"
            placeholder="选择时间"
            style="width: 100%"
            @change="calculateDuration"
          />
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
          <el-time-picker
            v-model="overtimeForm.endTime"
            placeholder="选择时间"
            style="width: 100%"
            @change="calculateDuration"
          />
        </el-form-item>
        <el-form-item label="时长(小时)" prop="duration">
          <el-input-number
            v-model="overtimeForm.duration"
            :min="0.5"
            :step="0.5"
            style="width: 100%"
            disabled
          />
        </el-form-item>
        <el-form-item label="审批人" prop="approverId">
          <el-select
            v-model="overtimeForm.approverId"
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
        <el-form-item label="备注" prop="remark">
          <el-input
            v-model="overtimeForm.remark"
            type="textarea"
            :rows="3"
            placeholder="请输入加班原因"
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
import { ref, reactive, computed, onMounted, nextTick } from "vue";
import {
  Plus,
  Edit,
  Delete,
  Search,
  Refresh,
  Check,
} from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";
import overtimeApi from "@/api/overtime";
import employeeApi from "@/api/employee";
import PageContainer from "@/components/PageContainer.vue";

// 格式化日期
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

// 格式化时间
const formatTime = (timeStr) => {
  if (!timeStr) return "";

  let hours, minutes, seconds;

  if (typeof timeStr === "string" && timeStr.includes(":")) {
    // 如果是 HH:mm:ss 格式
    [hours, minutes, seconds = "00"] = timeStr.split(":");
  } else {
    // 如果是 Date 对象
    const date = new Date(timeStr);
    if (isNaN(date.getTime())) return "";

    hours = date.getHours();
    minutes = date.getMinutes();
    seconds = date.getSeconds();
  }

  return `${String(hours).padStart(2, "0")}:${String(minutes).padStart(
    2,
    "0"
  )}:${String(seconds).padStart(2, "0")}`;
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
  date: null,
});

// 加班表单
const dialogVisible = ref(false);
const dialogType = ref("add"); // add, edit
const overtimeFormRef = ref(null);
const overtimeForm = reactive({
  recordId: "",
  employeeId: "",
  date: "",
  startTime: "",
  endTime: "",
  duration: 0,
  approverId: "",
  remark: "",
});

// 表单验证规则
const overtimeRules = {
  employeeId: [
    { required: true, message: "请选择员工", trigger: "change" },
    { type: "number", transform: (value) => Number(value) },
  ],
  date: [{ required: true, message: "请选择加班日期", trigger: "change" }],
  startTime: [{ required: true, message: "请选择开始时间", trigger: "change" }],
  endTime: [{ required: true, message: "请选择结束时间", trigger: "change" }],
  approverId: [
    { required: true, message: "请选择审批人", trigger: "change" },
    { type: "number", transform: (value) => Number(value) },
  ],
};

// 员工选项
const employeeOptions = ref([]);

// 格式化日期为ISO格式
const formatISODate = (date) => {
  if (!date) return null;
  if (typeof date === "string") {
    date = new Date(date);
  }
  if (isNaN(date.getTime())) return null;
  return date.toISOString();
};

// 合并日期和时间
const mergeDateAndTime = (date, time) => {
  if (!date || !time) return null;
  const mergedDate = new Date(date);
  const timeDate = new Date(time);

  mergedDate.setHours(timeDate.getHours());
  mergedDate.setMinutes(timeDate.getMinutes());
  mergedDate.setSeconds(timeDate.getSeconds());

  return mergedDate;
};

// 格式化显示用的日期
const formatDisplayDate = (date) => {
  if (!date) return "";
  if (typeof date === "string") {
    date = new Date(date);
  }
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

// 格式化显示用的时间
const formatDisplayTime = (date) => {
  if (!date) return "";
  if (typeof date === "string") {
    date = new Date(date);
  }
  if (isNaN(date.getTime())) return "";

  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  const seconds = String(date.getSeconds()).padStart(2, "0");
  return `${hours}:${minutes}:${seconds}`;
};

// 计算加班时长
const calculateDuration = () => {
  if (overtimeForm.startTime && overtimeForm.endTime) {
    const start = new Date(overtimeForm.startTime);
    const end = new Date(overtimeForm.endTime);

    // 只考虑时和分的差异
    const startMinutes = start.getHours() * 60 + start.getMinutes();
    const endMinutes = end.getHours() * 60 + end.getMinutes();
    const diffMinutes = endMinutes - startMinutes;

    overtimeForm.duration = Math.max(
      0,
      parseFloat((diffMinutes / 60).toFixed(1))
    );
  }
};

// 获取加班记录列表
const getOvertimeList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      employeeId: searchForm.employeeId || undefined,
    };

    // 处理日期范围
    if (searchForm.date && searchForm.date[0] && searchForm.date[1]) {
      params.dateStart = formatDisplayDate(searchForm.date[0]);
      params.dateEnd = formatDisplayDate(searchForm.date[1]);
    }

    const response = await overtimeApi.getOvertimePage(params);
    console.log("获取加班记录响应：", response);

    if (response.data && response.data.code === 0) {
      const { list, total: totalCount } = response.data.data;

      // 获取所有涉及的员工ID（包括申请人和审批人）
      const employeeIds = new Set();
      list.forEach((item) => {
        if (item.employeeId) employeeIds.add(item.employeeId);
        if (item.approverId) employeeIds.add(item.approverId);
      });

      // 获取员工信息
      const employeeMap = new Map();
      if (employeeIds.size > 0) {
        try {
          await Promise.all(
            Array.from(employeeIds).map(async (id) => {
              const empResponse = await employeeApi.getEmployeeById(id);
              if (empResponse.data && empResponse.data.code === 0) {
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
        date: formatDisplayDate(item.date),
        startTime: formatDisplayTime(item.startTime),
        endTime: formatDisplayTime(item.endTime),
      }));

      total.value = totalCount;
    } else {
      throw new Error(response.data?.msg || "获取加班记录失败");
    }
  } catch (error) {
    console.error("获取加班记录失败", error);
    ElMessage.error(error.message || "获取加班记录失败");
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
      response.data.code === 0 &&
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
  getOvertimeList();
};

// 重置查询条件
const resetSearch = () => {
  searchForm.employeeId = "";
  searchForm.date = null;
  handleSearch();
};

// 处理分页大小变化
const handleSizeChange = (val) => {
  pageSize.value = val;
  getOvertimeList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getOvertimeList();
};

// 处理添加加班
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  overtimeForm.recordId = "";
  overtimeForm.employeeId = "";
  overtimeForm.date = null;
  // 设置默认时间
  const defaultTime = new Date();
  defaultTime.setHours(9, 0, 0);
  overtimeForm.startTime = defaultTime;

  const defaultEndTime = new Date();
  defaultEndTime.setHours(18, 0, 0);
  overtimeForm.endTime = defaultEndTime;

  overtimeForm.duration = 0;
  overtimeForm.approverId = "";
  overtimeForm.remark = "";

  // 下一个事件循环重置表单验证
  nextTick(() => {
    if (overtimeFormRef.value) {
      overtimeFormRef.value.clearValidate();
    }
  });
};

// 处理编辑加班
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;

  // 填充表单
  overtimeForm.recordId = row.recordId;
  overtimeForm.employeeId = row.employeeId;
  overtimeForm.date = new Date(row.date);

  // 处理开始时间
  const [startHours, startMinutes] = row.startTime.split(":");
  const startTime = new Date();
  startTime.setHours(parseInt(startHours), parseInt(startMinutes), 0);
  overtimeForm.startTime = startTime;

  // 处理结束时间
  const [endHours, endMinutes] = row.endTime.split(":");
  const endTime = new Date();
  endTime.setHours(parseInt(endHours), parseInt(endMinutes), 0);
  overtimeForm.endTime = endTime;

  overtimeForm.duration = parseFloat(row.duration);
  overtimeForm.approverId = row.approverId;
  overtimeForm.remark = row.remark || "";

  // 计算时长
  calculateDuration();

  // 下一个事件循环重置表单验证
  nextTick(() => {
    if (overtimeFormRef.value) {
      overtimeFormRef.value.clearValidate();
    }
  });
};

// 处理删除加班
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(`确定要删除此加班记录吗？`, "警告", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    const response = await overtimeApi.deleteOvertime(row.recordId);
    if (response.data && response.data.code === 0) {
      ElMessage.success("删除成功");
      // 如果当前页只有一条数据，且不是第一页，则跳转到上一页
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      getOvertimeList();
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
  overtimeFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        submitting.value = true;

        // 验证日期和时间
        if (
          !overtimeForm.date ||
          !overtimeForm.startTime ||
          !overtimeForm.endTime
        ) {
          throw new Error("请选择完整的日期和时间");
        }

        // 验证时长
        if (!overtimeForm.duration || overtimeForm.duration <= 0) {
          throw new Error("加班时长必须大于0");
        }

        // 准备提交数据
        const data = {
          recordId: dialogType.value === "edit" ? overtimeForm.recordId : 0,
          employeeId: parseInt(overtimeForm.employeeId),
          date: formatISODate(overtimeForm.date),
          startTime: formatISODate(
            mergeDateAndTime(overtimeForm.date, overtimeForm.startTime)
          ),
          endTime: formatISODate(
            mergeDateAndTime(overtimeForm.date, overtimeForm.endTime)
          ),
          duration: parseFloat(overtimeForm.duration.toFixed(1)),
          approverId: parseInt(overtimeForm.approverId),
          remark: overtimeForm.remark?.trim() || "",
        };

        // 验证数据转换结果
        if (isNaN(data.employeeId)) {
          throw new Error("员工ID格式不正确");
        }
        if (isNaN(data.approverId)) {
          throw new Error("审批人ID格式不正确");
        }
        if (isNaN(data.duration)) {
          throw new Error("加班时长格式不正确");
        }
        if (!data.date || !data.startTime || !data.endTime) {
          throw new Error("日期或时间格式不正确");
        }

        console.log("提交的加班数据:", data);

        let response;
        if (dialogType.value === "add") {
          response = await overtimeApi.addOvertime(data);
        } else {
          response = await overtimeApi.updateOvertime(data);
        }

        console.log("提交加班响应:", response);

        if (response.data && response.data.code === 0) {
          ElMessage.success(
            dialogType.value === "add" ? "添加成功" : "修改成功"
          );
          dialogVisible.value = false;
          getOvertimeList();
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
  getOvertimeList();
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
