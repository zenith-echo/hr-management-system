<template>
  <div class="project-task">
    <div class="page-header">
      <h2>项目任务管理</h2>
      <el-button type="primary" @click="handleAdd">新建任务</el-button>
    </div>

    <!-- 项目信息 -->
    <el-descriptions title="项目信息" :column="3" border>
      <el-descriptions-item label="项目名称">{{
        projectInfo.projectName
      }}</el-descriptions-item>
      <el-descriptions-item label="项目经理">{{
        projectInfo.managerName
      }}</el-descriptions-item>
      <el-descriptions-item label="项目状态">
        <el-tag :type="getStatusType(projectInfo.status)">{{
          getStatusText(projectInfo.status)
        }}</el-tag>
      </el-descriptions-item>
      <el-descriptions-item label="开始日期">{{
        projectInfo.startDate
      }}</el-descriptions-item>
      <el-descriptions-item label="结束日期">{{
        projectInfo.endDate
      }}</el-descriptions-item>
      <el-descriptions-item label="预算">{{
        projectInfo.budget
      }}</el-descriptions-item>
    </el-descriptions>

    <!-- 任务列表 -->
    <el-table :data="taskList" border style="width: 100%; margin-top: 20px">
      <el-table-column prop="taskName" label="任务名称" />
      <el-table-column prop="assigneeName" label="负责人" />
      <el-table-column prop="startDate" label="开始日期" />
      <el-table-column prop="endDate" label="结束日期" />
      <el-table-column prop="priority" label="优先级">
        <template #default="{ row }">
          <el-tag :type="getPriorityType(row.priority)">{{
            getPriorityText(row.priority)
          }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态">
        <template #default="{ row }">
          <el-tag :type="getTaskStatusType(row.status)">{{
            getTaskStatusText(row.status)
          }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150">
        <template #default="{ row }">
          <el-button type="primary" link @click="handleEdit(row)"
            >编辑</el-button
          >
          <el-button type="danger" link @click="handleDelete(row)"
            >删除</el-button
          >
        </template>
      </el-table-column>
    </el-table>

    <!-- 任务表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新建任务' : '编辑任务'"
      width="500px"
    >
      <el-form
        ref="taskFormRef"
        :model="taskForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="任务名称" prop="taskName">
          <el-input v-model="taskForm.taskName" />
        </el-form-item>
        <el-form-item label="任务描述" prop="description">
          <el-input v-model="taskForm.description" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="负责人" prop="assigneeId">
          <el-select v-model="taskForm.assigneeId" placeholder="请选择负责人">
            <el-option
              v-for="member in projectMembers"
              :key="member.id"
              :label="member.name"
              :value="member.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="起止日期" prop="dateRange">
          <el-date-picker
            v-model="taskForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>
        <el-form-item label="优先级" prop="priority">
          <el-select v-model="taskForm.priority" placeholder="请选择优先级">
            <el-option label="低" value="LOW" />
            <el-option label="中" value="MEDIUM" />
            <el-option label="高" value="HIGH" />
            <el-option label="紧急" value="URGENT" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="taskForm.status" placeholder="请选择状态">
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
import { useRoute } from "vue-router";
import { ElMessage, ElMessageBox } from "element-plus";

const route = useRoute();
const projectId = route.params.id;

// 项目信息
const projectInfo = ref({});

// 任务列表
const taskList = ref([]);

// 项目成员列表
const projectMembers = ref([]);

// 对话框控制
const dialogVisible = ref(false);
const dialogType = ref("add");
const taskFormRef = ref(null);
const taskForm = reactive({
  taskName: "",
  description: "",
  assigneeId: "",
  dateRange: [],
  priority: "MEDIUM",
  status: "NOT_STARTED",
});

// 表单验证规则
const rules = {
  taskName: [{ required: true, message: "请输入任务名称", trigger: "blur" }],
  assigneeId: [{ required: true, message: "请选择负责人", trigger: "change" }],
  dateRange: [{ required: true, message: "请选择起止日期", trigger: "change" }],
  priority: [{ required: true, message: "请选择优先级", trigger: "change" }],
  status: [{ required: true, message: "请选择状态", trigger: "change" }],
};

// 获取项目信息
const getProjectInfo = async () => {
  try {
    // TODO: 调用后端API获取项目信息
    // const res = await fetchProjectInfo(projectId)
    // projectInfo.value = res.data
  } catch (error) {
    ElMessage.error("获取项目信息失败");
  }
};

// 获取任务列表
const getTaskList = async () => {
  try {
    // TODO: 调用后端API获取任务列表
    // const res = await fetchProjectTasks(projectId)
    // taskList.value = res.data
  } catch (error) {
    ElMessage.error("获取任务列表失败");
  }
};

// 获取项目成员列表
const getProjectMembers = async () => {
  try {
    // TODO: 调用后端API获取项目成员列表
    // const res = await fetchProjectMembers(projectId)
    // projectMembers.value = res.data
  } catch (error) {
    ElMessage.error("获取项目成员列表失败");
  }
};

// 项目状态处理
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

// 任务状态处理
const getTaskStatusType = (status) => {
  return getStatusType(status);
};

const getTaskStatusText = (status) => {
  return getStatusText(status);
};

// 优先级处理
const getPriorityType = (priority) => {
  const priorityMap = {
    LOW: "info",
    MEDIUM: "",
    HIGH: "warning",
    URGENT: "danger",
  };
  return priorityMap[priority];
};

const getPriorityText = (priority) => {
  const priorityMap = {
    LOW: "低",
    MEDIUM: "中",
    HIGH: "高",
    URGENT: "紧急",
  };
  return priorityMap[priority];
};

// 新建任务
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  Object.assign(taskForm, {
    taskName: "",
    description: "",
    assigneeId: "",
    dateRange: [],
    priority: "MEDIUM",
    status: "NOT_STARTED",
  });
};

// 编辑任务
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  Object.assign(taskForm, {
    ...row,
    dateRange: [row.startDate, row.endDate],
  });
};

// 删除任务
const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该任务吗？", "提示", {
    type: "warning",
  })
    .then(async () => {
      try {
        // TODO: 调用后端API删除任务
        // await deleteProjectTask(row.id)
        ElMessage.success("删除成功");
        getTaskList();
      } catch (error) {
        ElMessage.error("删除失败");
      }
    })
    .catch(() => {});
};

// 提交表单
const handleSubmit = async () => {
  if (!taskFormRef.value) return;
  await taskFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const data = {
          ...taskForm,
          projectId,
          startDate: taskForm.dateRange[0],
          endDate: taskForm.dateRange[1],
        };
        // TODO: 调用后端API保存任务
        // if (dialogType.value === 'add') {
        //   await createProjectTask(data)
        // } else {
        //   await updateProjectTask(data)
        // }
        ElMessage.success(dialogType.value === "add" ? "创建成功" : "更新成功");
        dialogVisible.value = false;
        getTaskList();
      } catch (error) {
        ElMessage.error(dialogType.value === "add" ? "创建失败" : "更新失败");
      }
    }
  });
};

onMounted(() => {
  getProjectInfo();
  getTaskList();
  getProjectMembers();
});
</script>

<style scoped>
.project-task {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

:deep(.el-descriptions) {
  margin-bottom: 20px;
}
</style>
