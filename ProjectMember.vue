<template>
  <div class="project-member">
    <div class="page-header">
      <h2>项目成员管理</h2>
      <el-button type="primary" @click="handleAdd">添加成员</el-button>
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

    <!-- 成员列表 -->
    <el-table :data="memberList" border style="width: 100%; margin-top: 20px">
      <el-table-column prop="employeeName" label="成员姓名" />
      <el-table-column prop="role" label="角色" />
      <el-table-column prop="joinDate" label="加入日期" />
      <el-table-column prop="leaveDate" label="离开日期" />
      <el-table-column prop="workload" label="工作量">
        <template #default="{ row }"> {{ row.workload }}% </template>
      </el-table-column>
      <el-table-column label="操作" width="150">
        <template #default="{ row }">
          <el-button type="primary" link @click="handleEdit(row)"
            >编辑</el-button
          >
          <el-button type="danger" link @click="handleDelete(row)"
            >移除</el-button
          >
        </template>
      </el-table-column>
    </el-table>

    <!-- 成员表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '添加成员' : '编辑成员'"
      width="500px"
    >
      <el-form
        ref="memberFormRef"
        :model="memberForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="选择成员" prop="employeeId">
          <el-select v-model="memberForm.employeeId" placeholder="请选择成员">
            <el-option
              v-for="employee in employeeList"
              :key="employee.id"
              :label="employee.name"
              :value="employee.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="角色" prop="role">
          <el-select v-model="memberForm.role" placeholder="请选择角色">
            <el-option label="开发人员" value="DEVELOPER" />
            <el-option label="测试人员" value="TESTER" />
            <el-option label="产品经理" value="PRODUCT_MANAGER" />
            <el-option label="设计师" value="DESIGNER" />
          </el-select>
        </el-form-item>
        <el-form-item label="起止日期" prop="dateRange">
          <el-date-picker
            v-model="memberForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="加入日期"
            end-placeholder="离开日期"
          />
        </el-form-item>
        <el-form-item label="工作量" prop="workload">
          <el-slider v-model="memberForm.workload" :max="100" :min="0" />
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

// 成员列表
const memberList = ref([]);

// 员工列表
const employeeList = ref([]);

// 对话框控制
const dialogVisible = ref(false);
const dialogType = ref("add");
const memberFormRef = ref(null);
const memberForm = reactive({
  employeeId: "",
  role: "",
  dateRange: [],
  workload: 100,
});

// 表单验证规则
const rules = {
  employeeId: [{ required: true, message: "请选择成员", trigger: "change" }],
  role: [{ required: true, message: "请选择角色", trigger: "change" }],
  dateRange: [{ required: true, message: "请选择起止日期", trigger: "change" }],
  workload: [{ required: true, message: "请设置工作量", trigger: "change" }],
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

// 获取成员列表
const getMemberList = async () => {
  try {
    // TODO: 调用后端API获取成员列表
    // const res = await fetchProjectMembers(projectId)
    // memberList.value = res.data
  } catch (error) {
    ElMessage.error("获取成员列表失败");
  }
};

// 获取员工列表
const getEmployeeList = async () => {
  try {
    // TODO: 调用后端API获取员工列表
    // const res = await fetchEmployeeList()
    // employeeList.value = res.data
  } catch (error) {
    ElMessage.error("获取员工列表失败");
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

// 添加成员
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  Object.assign(memberForm, {
    employeeId: "",
    role: "",
    dateRange: [],
    workload: 100,
  });
};

// 编辑成员
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  Object.assign(memberForm, {
    ...row,
    dateRange: [row.joinDate, row.leaveDate],
  });
};

// 移除成员
const handleDelete = (row) => {
  ElMessageBox.confirm("确认移除该成员吗？", "提示", {
    type: "warning",
  })
    .then(async () => {
      try {
        // TODO: 调用后端API移除成员
        // await removeProjectMember(row.id)
        ElMessage.success("移除成功");
        getMemberList();
      } catch (error) {
        ElMessage.error("移除失败");
      }
    })
    .catch(() => {});
};

// 提交表单
const handleSubmit = async () => {
  if (!memberFormRef.value) return;
  await memberFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const data = {
          ...memberForm,
          projectId,
          joinDate: memberForm.dateRange[0],
          leaveDate: memberForm.dateRange[1],
        };
        // TODO: 调用后端API保存成员
        // if (dialogType.value === 'add') {
        //   await addProjectMember(data)
        // } else {
        //   await updateProjectMember(data)
        // }
        ElMessage.success(dialogType.value === "add" ? "添加成功" : "更新成功");
        dialogVisible.value = false;
        getMemberList();
      } catch (error) {
        ElMessage.error(dialogType.value === "add" ? "添加失败" : "更新失败");
      }
    }
  });
};

onMounted(() => {
  getProjectInfo();
  getMemberList();
  getEmployeeList();
});
</script>

<style scoped>
.project-member {
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
