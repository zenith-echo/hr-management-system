<template>
  <div class="schedule-request">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>排班申请管理</span>
          <el-button type="primary" @click="handleAdd">新增申请</el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="申请人">
          <el-input
            v-model="searchForm.employeeName"
            placeholder="请输入申请人姓名"
          />
        </el-form-item>
        <el-form-item label="申请类型">
          <el-select v-model="searchForm.requestType" placeholder="请选择">
            <el-option label="调班申请" value="change" />
            <el-option label="换班申请" value="swap" />
            <el-option label="加班申请" value="overtime" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择">
            <el-option label="待审核" value="pending" />
            <el-option label="已通过" value="approved" />
            <el-option label="已拒绝" value="rejected" />
          </el-select>
        </el-form-item>
        <el-form-item label="申请日期">
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

      <!-- 申请表格 -->
      <el-table :data="tableData" style="width: 100%" border>
        <el-table-column prop="employeeName" label="申请人" />
        <el-table-column prop="requestType" label="申请类型">
          <template #default="scope">
            {{ getRequestTypeText(scope.row.requestType) }}
          </template>
        </el-table-column>
        <el-table-column prop="requestDate" label="申请日期" />
        <el-table-column prop="reason" label="申请原因" show-overflow-tooltip />
        <el-table-column prop="status" label="状态">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="approverName" label="审批人" />
        <el-table-column label="操作" width="250">
          <template #default="scope">
            <el-button
              v-if="scope.row.status === 'pending'"
              size="small"
              type="success"
              @click="handleApprove(scope.row)"
              >通过</el-button
            >
            <el-button
              v-if="scope.row.status === 'pending'"
              size="small"
              type="danger"
              @click="handleReject(scope.row)"
              >拒绝</el-button
            >
            <el-button
              v-if="scope.row.status === 'pending'"
              size="small"
              @click="handleEdit(scope.row)"
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

    <!-- 新增/编辑申请对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增申请' : '编辑申请'"
      width="500px"
    >
      <el-form
        ref="requestForm"
        :model="requestForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="申请人" prop="employeeId">
          <el-select v-model="requestForm.employeeId" placeholder="请选择">
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="申请类型" prop="requestType">
          <el-select v-model="requestForm.requestType" placeholder="请选择">
            <el-option label="调班申请" value="change" />
            <el-option label="换班申请" value="swap" />
            <el-option label="加班申请" value="overtime" />
          </el-select>
        </el-form-item>
        <el-form-item label="申请日期" prop="requestDate">
          <el-date-picker
            v-model="requestForm.requestDate"
            type="date"
            placeholder="选择日期"
          />
        </el-form-item>
        <el-form-item label="申请原因" prop="reason">
          <el-input
            v-model="requestForm.reason"
            type="textarea"
            :rows="3"
            placeholder="请输入申请原因"
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
  requestType: "",
  status: "",
  dateRange: [],
});

// 表格数据
const tableData = ref([
  {
    id: 1,
    employeeName: "张三",
    requestType: "change",
    requestDate: "2024-03-20",
    reason: "个人事务需要调整班次",
    status: "pending",
    approverName: "李主管",
  },
]);

// 分页
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(100);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const requestForm = reactive({
  employeeId: "",
  requestType: "",
  requestDate: "",
  reason: "",
});

// 表单规则
const rules = {
  employeeId: [{ required: true, message: "请选择申请人", trigger: "change" }],
  requestType: [
    { required: true, message: "请选择申请类型", trigger: "change" },
  ],
  requestDate: [
    { required: true, message: "请选择申请日期", trigger: "change" },
  ],
  reason: [{ required: true, message: "请输入申请原因", trigger: "blur" }],
};

// 员工选项（模拟数据）
const employeeOptions = [
  { value: "1", label: "张三" },
  { value: "2", label: "李四" },
];

// 申请类型文本
const getRequestTypeText = (type) => {
  const typeMap = {
    change: "调班申请",
    swap: "换班申请",
    overtime: "加班申请",
  };
  return typeMap[type] || type;
};

// 状态样式
const getStatusType = (status) => {
  const statusMap = {
    pending: "warning",
    approved: "success",
    rejected: "danger",
  };
  return statusMap[status] || "info";
};

// 状态文本
const getStatusText = (status) => {
  const statusMap = {
    pending: "待审核",
    approved: "已通过",
    rejected: "已拒绝",
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
  Object.keys(requestForm).forEach((key) => {
    requestForm[key] = "";
  });
};

const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  // TODO: 填充表单数据
};

const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该申请记录吗？", "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  }).then(() => {
    // TODO: 实现删除逻辑
    ElMessage.success("删除成功");
  });
};

const handleApprove = (row) => {
  ElMessageBox.confirm("确认通过该申请吗？", "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  }).then(() => {
    // TODO: 实现审批通过逻辑
    ElMessage.success("已通过申请");
  });
};

const handleReject = (row) => {
  ElMessageBox.prompt("请输入拒绝原因", "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    inputPattern: /.+/,
    inputErrorMessage: "拒绝原因不能为空",
  }).then(({ value }) => {
    // TODO: 实现拒绝逻辑
    ElMessage.success("已拒绝申请");
  });
};

const submitForm = () => {
  // TODO: 实现表单提交逻辑
  dialogVisible.value = false;
  ElMessage.success("保存成功");
};
</script>

<style scoped>
.schedule-request {
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
