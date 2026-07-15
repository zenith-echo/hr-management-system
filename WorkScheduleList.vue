<template>
  <div class="work-schedule">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>工作排班管理</span>
          <el-button type="primary" @click="handleAdd">新增排班</el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="员工">
          <el-input
            v-model="searchForm.employeeName"
            placeholder="请输入员工姓名"
          />
        </el-form-item>
        <el-form-item label="排班类型">
          <el-select v-model="searchForm.scheduleType" placeholder="请选择">
            <el-option label="早班" value="morning" />
            <el-option label="中班" value="middle" />
            <el-option label="晚班" value="night" />
          </el-select>
        </el-form-item>
        <el-form-item label="日期范围">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 排班表格 -->
      <el-table :data="tableData" style="width: 100%" border>
        <el-table-column prop="employeeName" label="员工姓名" />
        <el-table-column prop="scheduleType" label="排班类型" />
        <el-table-column prop="startTime" label="开始时间" />
        <el-table-column prop="endTime" label="结束时间" />
        <el-table-column prop="status" label="状态">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template #default="scope">
            <el-button size="small" @click="handleEdit(scope.row)"
              >编辑</el-button
            >
            <el-button
              size="small"
              type="danger"
              @click="handleDelete(scope.row)"
              >删除</el-button
            >
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

    <!-- 新增/编辑排班对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增排班' : '编辑排班'"
      width="500px"
    >
      <el-form
        ref="scheduleForm"
        :model="scheduleForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="员工" prop="employeeId">
          <el-select v-model="scheduleForm.employeeId" placeholder="请选择员工">
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="排班类型" prop="scheduleType">
          <el-select v-model="scheduleForm.scheduleType" placeholder="请选择">
            <el-option label="早班" value="morning" />
            <el-option label="中班" value="middle" />
            <el-option label="晚班" value="night" />
          </el-select>
        </el-form-item>
        <el-form-item label="时间范围" prop="timeRange">
          <el-date-picker
            v-model="scheduleForm.timeRange"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";

// 搜索表单
const searchForm = reactive({
  employeeName: "",
  scheduleType: "",
  dateRange: [],
});

// 表格数据
const tableData = ref([
  {
    id: 1,
    employeeName: "张三",
    scheduleType: "morning",
    startTime: "2024-03-20 08:00:00",
    endTime: "2024-03-20 16:00:00",
    status: "normal",
  },
]);

// 分页
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(100);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const scheduleForm = reactive({
  employeeId: "",
  scheduleType: "",
  timeRange: [],
});

// 表单规则
const rules = {
  employeeId: [{ required: true, message: "请选择员工", trigger: "change" }],
  scheduleType: [
    { required: true, message: "请选择排班类型", trigger: "change" },
  ],
  timeRange: [{ required: true, message: "请选择时间范围", trigger: "change" }],
};

// 员工选项（模拟数据）
const employeeOptions = [
  { value: "1", label: "张三" },
  { value: "2", label: "李四" },
];

// 状态处理
const getStatusType = (status) => {
  const statusMap = {
    normal: "success",
    pending: "warning",
    cancelled: "danger",
  };
  return statusMap[status] || "info";
};

const getStatusText = (status) => {
  const statusMap = {
    normal: "正常",
    pending: "待审核",
    cancelled: "已取消",
  };
  return statusMap[status] || status;
};

// 搜索处理
const handleSearch = () => {
  // TODO: 实现搜索逻辑
  console.log("搜索条件：", searchForm);
};

const resetSearch = () => {
  Object.keys(searchForm).forEach((key) => {
    searchForm[key] = "";
  });
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  // TODO: 重新加载数据
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  // TODO: 重新加载数据
};

// 表单处理
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  Object.keys(scheduleForm).forEach((key) => {
    scheduleForm[key] = "";
  });
};

const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  // TODO: 填充表单数据
};

const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该排班记录吗？", "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  }).then(() => {
    // TODO: 实现删除逻辑
    ElMessage.success("删除成功");
  });
};

const submitForm = () => {
  // TODO: 实现表单提交逻辑
  dialogVisible.value = false;
  ElMessage.success("保存成功");
};
</script>

<style scoped>
.work-schedule {
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
</style>
