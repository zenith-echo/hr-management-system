<template>
  <div class="project-list">
    <div class="page-header">
      <h2>项目列表</h2>
      <el-button type="primary" @click="handleAdd">新建项目</el-button>
    </div>

    <!-- 搜索表单 -->
    <el-form :inline="true" :model="searchForm" class="search-form">
      <el-form-item label="项目名称">
        <el-input
          v-model="searchForm.projectName"
          placeholder="请输入项目名称"
          clearable
        />
      </el-form-item>
      <el-form-item label="项目状态">
        <el-select
          v-model="searchForm.status"
          placeholder="请选择状态"
          clearable
        >
          <el-option label="未开始" value="NOT_STARTED" />
          <el-option label="进行中" value="IN_PROGRESS" />
          <el-option label="已完成" value="COMPLETED" />
          <el-option label="已暂停" value="PAUSED" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="resetSearch">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 项目列表 -->
    <el-table :data="projectList" border style="width: 100%">
      <el-table-column prop="projectName" label="项目名称" />
      <el-table-column prop="managerName" label="项目经理" />
      <el-table-column prop="startDate" label="开始日期" />
      <el-table-column prop="endDate" label="结束日期" />
      <el-table-column prop="budget" label="预算" />
      <el-table-column prop="status" label="状态">
        <template #default="{ row }">
          <el-tag :type="getStatusType(row.status)">{{
            getStatusText(row.status)
          }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="280">
        <template #default="{ row }">
          <el-button type="primary" link @click="handleMembers(row)"
            >成员管理</el-button
          >
          <el-button type="primary" link @click="handleTasks(row)"
            >任务管理</el-button
          >
          <el-button type="primary" link @click="handleEdit(row)"
            >编辑</el-button
          >
          <el-button type="danger" link @click="handleDelete(row)"
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
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 项目表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新建项目' : '编辑项目'"
      width="500px"
    >
      <el-form
        ref="projectFormRef"
        :model="projectForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="项目名称" prop="projectName">
          <el-input v-model="projectForm.projectName" />
        </el-form-item>
        <el-form-item label="项目描述" prop="description">
          <el-input
            v-model="projectForm.description"
            type="textarea"
            :rows="3"
          />
        </el-form-item>
        <el-form-item label="项目经理" prop="managerId">
          <el-select
            v-model="projectForm.managerId"
            placeholder="请选择项目经理"
          >
            <el-option
              v-for="manager in managerList"
              :key="manager.id"
              :label="manager.name"
              :value="manager.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="起止日期" prop="dateRange">
          <el-date-picker
            v-model="projectForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>
        <el-form-item label="预算" prop="budget">
          <el-input-number v-model="projectForm.budget" :min="0" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="projectForm.status">
            <el-option label="未开始" value="NOT_STARTED" />
            <el-option label="进行中" value="IN_PROGRESS" />
            <el-option label="已完成" value="COMPLETED" />
            <el-option label="已暂停" value="PAUSED" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmit">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import { useRouter } from "vue-router";
import { ElMessage, ElMessageBox } from "element-plus";

const router = useRouter();

// 搜索表单
const searchForm = reactive({
  projectName: "",
  status: "",
});

// 项目列表数据
const projectList = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 对话框控制
const dialogVisible = ref(false);
const dialogType = ref("add");
const projectFormRef = ref(null);
const projectForm = reactive({
  projectName: "",
  description: "",
  managerId: "",
  dateRange: [],
  budget: 0,
  status: "NOT_STARTED",
});

// 表单验证规则
const rules = {
  projectName: [{ required: true, message: "请输入项目名称", trigger: "blur" }],
  managerId: [{ required: true, message: "请选择项目经理", trigger: "change" }],
  dateRange: [
    { required: true, message: "请选择项目起止日期", trigger: "change" },
  ],
  status: [{ required: true, message: "请选择项目状态", trigger: "change" }],
};

// 项目经理列表
const managerList = ref([]);

// 获取项目列表
const getProjectList = async () => {
  try {
    // 模拟数据
    const mockProjects = [
      {
        id: 1,
        projectName: "人事管理系统开发",
        managerName: "张三",
        startDate: "2024-01-01",
        endDate: "2024-06-30",
        budget: 500000,
        status: "IN_PROGRESS",
        description: "开发一套完整的人事管理系统",
      },
      {
        id: 2,
        projectName: "移动端APP开发",
        managerName: "李四",
        startDate: "2024-03-01",
        endDate: "2024-08-31",
        budget: 300000,
        status: "NOT_STARTED",
        description: "开发配套的移动端应用",
      },
      {
        id: 3,
        projectName: "系统升级优化",
        managerName: "王五",
        startDate: "2024-02-01",
        endDate: "2024-04-30",
        budget: 200000,
        status: "COMPLETED",
        description: "对现有系统进行升级优化",
      },
    ];

    projectList.value = mockProjects;
    total.value = mockProjects.length;
  } catch (error) {
    ElMessage.error("获取项目列表失败");
  }
};

// 获取项目经理列表
const getManagerList = async () => {
  try {
    // 模拟数据
    managerList.value = [
      { id: 1, name: "张三" },
      { id: 2, name: "李四" },
      { id: 3, name: "王五" },
      { id: 4, name: "赵六" },
    ];
  } catch (error) {
    ElMessage.error("获取项目经理列表失败");
  }
};

// 状态处理
const getStatusType = (status) => {
  const statusMap = {
    NOT_STARTED: "info",
    IN_PROGRESS: "primary",
    COMPLETED: "success",
    PAUSED: "warning",
  };
  return statusMap[status];
};

const getStatusText = (status) => {
  const statusMap = {
    NOT_STARTED: "未开始",
    IN_PROGRESS: "进行中",
    COMPLETED: "已完成",
    PAUSED: "已暂停",
  };
  return statusMap[status];
};

// 搜索和重置
const handleSearch = () => {
  currentPage.value = 1;
  getProjectList();
};

const resetSearch = () => {
  searchForm.projectName = "";
  searchForm.status = "";
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  getProjectList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  getProjectList();
};

// 新增项目
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  Object.assign(projectForm, {
    projectName: "",
    description: "",
    managerId: "",
    dateRange: [],
    budget: 0,
    status: "NOT_STARTED",
  });
};

// 编辑项目
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  Object.assign(projectForm, {
    ...row,
    dateRange: [row.startDate, row.endDate],
  });
};

// 删除项目
const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该项目吗？", "提示", {
    type: "warning",
  })
    .then(async () => {
      try {
        // 模拟删除项目
        const index = projectList.value.findIndex((item) => item.id === row.id);
        if (index !== -1) {
          projectList.value.splice(index, 1);
          ElMessage.success("删除成功");
        } else {
          ElMessage.error("未找到要删除的项目");
        }
      } catch (error) {
        ElMessage.error("删除失败");
      }
    })
    .catch(() => {});
};

// 提交表单
const handleSubmit = async () => {
  if (!projectFormRef.value) return;
  await projectFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const data = {
          ...projectForm,
          startDate: projectForm.dateRange[0],
          endDate: projectForm.dateRange[1],
        };
        // TODO: 调用后端API保存项目
        // if (dialogType.value === 'add') {
        //   await createProject(data)
        // } else {
        //   await updateProject(data)
        // }
        ElMessage.success(dialogType.value === "add" ? "创建成功" : "更新成功");
        dialogVisible.value = false;
        getProjectList();
      } catch (error) {
        ElMessage.error(dialogType.value === "add" ? "创建失败" : "更新失败");
      }
    }
  });
};

// 处理成员管理
const handleMembers = (row) => {
  router.push(`/dashboard/project/${row.id}/members`);
};

// 处理任务管理
const handleTasks = (row) => {
  router.push(`/dashboard/project/${row.id}/tasks`);
};

onMounted(() => {
  getProjectList();
  getManagerList();
});
</script>

<style scoped>
.project-list {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
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
`
