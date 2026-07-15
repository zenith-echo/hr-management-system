<template>
  <div class="shift-pattern">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>班次模板管理</span>
          <el-button type="primary" @click="handleAdd">新增模板</el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="模板名称">
          <el-input
            v-model="searchForm.patternName"
            placeholder="请输入模板名称"
          />
        </el-form-item>
        <el-form-item label="部门">
          <el-select v-model="searchForm.departmentId" placeholder="请选择">
            <el-option
              v-for="item in departmentOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 模板表格 -->
      <el-table :data="tableData" style="width: 100%" border>
        <el-table-column prop="patternName" label="模板名称" />
        <el-table-column prop="startTime" label="开始时间" />
        <el-table-column prop="endTime" label="结束时间" />
        <el-table-column prop="breakDuration" label="休息时长">
          <template #default="scope">
            {{ scope.row.breakDuration }} 分钟
          </template>
        </el-table-column>
        <el-table-column prop="departmentName" label="所属部门" />
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

    <!-- 新增/编辑模板对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增模板' : '编辑模板'"
      width="500px"
    >
      <el-form
        ref="patternForm"
        :model="patternForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="模板名称" prop="patternName">
          <el-input
            v-model="patternForm.patternName"
            placeholder="请输入模板名称"
          />
        </el-form-item>
        <el-form-item label="时间范围" prop="timeRange">
          <el-time-picker
            v-model="patternForm.startTime"
            placeholder="开始时间"
            format="HH:mm"
          />
          <span class="separator">至</span>
          <el-time-picker
            v-model="patternForm.endTime"
            placeholder="结束时间"
            format="HH:mm"
          />
        </el-form-item>
        <el-form-item label="休息时长" prop="breakDuration">
          <el-input-number
            v-model="patternForm.breakDuration"
            :min="0"
            :max="120"
            :step="15"
          />
          <span class="unit">分钟</span>
        </el-form-item>
        <el-form-item label="所属部门" prop="departmentId">
          <el-select v-model="patternForm.departmentId" placeholder="请选择">
            <el-option
              v-for="item in departmentOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
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
  patternName: "",
  departmentId: "",
});

// 表格数据
const tableData = ref([
  {
    id: 1,
    patternName: "标准早班",
    startTime: "08:00",
    endTime: "16:00",
    breakDuration: 60,
    departmentName: "技术部",
  },
]);

// 分页
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(100);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const patternForm = reactive({
  patternName: "",
  startTime: "",
  endTime: "",
  breakDuration: 60,
  departmentId: "",
});

// 表单规则
const rules = {
  patternName: [{ required: true, message: "请输入模板名称", trigger: "blur" }],
  startTime: [{ required: true, message: "请选择开始时间", trigger: "change" }],
  endTime: [{ required: true, message: "请选择结束时间", trigger: "change" }],
  departmentId: [
    { required: true, message: "请选择所属部门", trigger: "change" },
  ],
};

// 部门选项（模拟数据）
const departmentOptions = [
  { value: "1", label: "技术部" },
  { value: "2", label: "人事部" },
  { value: "3", label: "市场部" },
];

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
  Object.keys(patternForm).forEach((key) => {
    patternForm[key] = key === "breakDuration" ? 60 : "";
  });
};

const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  // TODO: 填充表单数据
};

const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该班次模板吗？", "提示", {
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
.shift-pattern {
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

.separator {
  margin: 0 10px;
}

.unit {
  margin-left: 10px;
}
</style>
