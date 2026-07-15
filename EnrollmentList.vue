<template>
  <div class="enrollment-list">
    <div class="page-header">
      <h2>培训参与管理</h2>
      <div class="actions">
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>添加参与者
        </el-button>
      </div>
    </div>

    <!-- 培训计划信息卡片 -->
    <el-card class="info-card">
      <template #header>
        <div class="card-header">
          <span>培训计划信息</span>
        </div>
      </template>
      <el-descriptions :column="3" border>
        <el-descriptions-item label="课程名称">
          {{ planInfo.courseName }}
        </el-descriptions-item>
        <el-descriptions-item label="培训时间">
          {{ planInfo.startDate }} 至 {{ planInfo.endDate }}
        </el-descriptions-item>
        <el-descriptions-item label="培训地点">
          {{ planInfo.location }}
        </el-descriptions-item>
        <el-descriptions-item label="最大人数">
          {{ planInfo.maxParticipants }}
        </el-descriptions-item>
        <el-descriptions-item label="当前人数">
          {{ planInfo.currentParticipants }}
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="getStatusType(planInfo.status)">
            {{ planInfo.status }}
          </el-tag>
        </el-descriptions-item>
      </el-descriptions>
    </el-card>

    <!-- 搜索区域 -->
    <el-card class="search-card">
      <el-form :model="searchForm" inline>
        <el-form-item label="员工">
          <el-select
            v-model="searchForm.employeeId"
            placeholder="请选择员工"
            clearable
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="出勤状态">
          <el-select
            v-model="searchForm.attendanceStatus"
            placeholder="请选择状态"
            clearable
          >
            <el-option label="未开始" value="未开始"></el-option>
            <el-option label="已签到" value="已签到"></el-option>
            <el-option label="已签退" value="已签退"></el-option>
            <el-option label="缺勤" value="缺勤"></el-option>
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
    </el-card>

    <!-- 表格区域 -->
    <el-card class="table-card">
      <el-table
        v-loading="loading"
        :data="tableData"
        style="width: 100%"
        border
        stripe
      >
        <el-table-column
          type="index"
          label="序号"
          width="60"
          align="center"
        ></el-table-column>
        <el-table-column
          prop="employeeName"
          label="员工姓名"
          width="120"
        ></el-table-column>
        <el-table-column
          prop="departmentName"
          label="所属部门"
          width="120"
        ></el-table-column>
        <el-table-column
          prop="positionName"
          label="职位"
          width="120"
        ></el-table-column>
        <el-table-column prop="attendanceStatus" label="出勤状态" width="100">
          <template #default="scope">
            <el-tag :type="getAttendanceStatusType(scope.row.attendanceStatus)">
              {{ scope.row.attendanceStatus }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="score" label="考核分数" width="100">
          <template #default="scope">
            <span v-if="scope.row.score">{{ scope.row.score }}分</span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column
          prop="feedback"
          label="反馈"
          min-width="200"
        ></el-table-column>
        <el-table-column
          prop="createTime"
          label="报名时间"
          width="180"
        ></el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              link
              @click="handleAttendance(scope.row)"
              v-if="planInfo.status === '进行中'"
            >
              <el-icon><Timer /></el-icon>考勤
            </el-button>
            <el-button
              type="success"
              link
              @click="handleScore(scope.row)"
              v-if="planInfo.status === '已结束'"
            >
              <el-icon><Edit /></el-icon>评分
            </el-button>
            <el-button type="info" link @click="handleView(scope.row)">
              <el-icon><View /></el-icon>查看
            </el-button>
            <el-button
              type="danger"
              link
              @click="handleDelete(scope.row)"
              v-if="planInfo.status === '未开始'"
            >
              <el-icon><Delete /></el-icon>删除
            </el-button>
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
        ></el-pagination>
      </div>
    </el-card>

    <!-- 参与者表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="getDialogTitle"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="enrollmentFormRef"
        :model="enrollmentForm"
        :rules="enrollmentRules"
        label-width="100px"
      >
        <el-form-item
          label="员工"
          prop="employeeId"
          v-if="dialogType === 'add'"
        >
          <el-select
            v-model="enrollmentForm.employeeId"
            placeholder="请选择员工"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item
          label="出勤状态"
          prop="attendanceStatus"
          v-if="dialogType === 'attendance'"
        >
          <el-select
            v-model="enrollmentForm.attendanceStatus"
            placeholder="请选择出勤状态"
            style="width: 100%"
          >
            <el-option label="已签到" value="已签到"></el-option>
            <el-option label="已签退" value="已签退"></el-option>
            <el-option label="缺勤" value="缺勤"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item
          label="考核分数"
          prop="score"
          v-if="dialogType === 'score'"
        >
          <el-input-number
            v-model="enrollmentForm.score"
            :min="0"
            :max="100"
            style="width: 100%"
          ></el-input-number>
        </el-form-item>
        <el-form-item
          label="反馈"
          prop="feedback"
          v-if="['score', 'view'].includes(dialogType)"
        >
          <el-input
            v-model="enrollmentForm.feedback"
            type="textarea"
            rows="3"
            placeholder="请输入反馈"
            :disabled="dialogType === 'view'"
          ></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button
            type="primary"
            @click="submitForm"
            v-if="dialogType !== 'view'"
          >
            确定
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from "vue";
import { useRoute } from "vue-router";
import {
  Plus,
  Edit,
  Delete,
  Search,
  Refresh,
  View,
  Timer,
} from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";

const route = useRoute();

// 表格数据
const loading = ref(false);
const tableData = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 培训计划信息
const planInfo = ref({
  courseName: "示例课程",
  startDate: "2024-04-01",
  endDate: "2024-04-05",
  location: "培训室1",
  maxParticipants: 30,
  currentParticipants: 15,
  status: "未开始",
});

// 搜索表单
const searchForm = reactive({
  employeeId: "",
  attendanceStatus: "",
});

// 员工选项
const employeeOptions = ref([]);

// 对话框相关
const dialogVisible = ref(false);
const dialogType = ref("add");
const enrollmentFormRef = ref(null);
const enrollmentForm = reactive({
  enrollmentId: "",
  employeeId: "",
  attendanceStatus: "未开始",
  score: 0,
  feedback: "",
});

// 对话框标题
const getDialogTitle = computed(() => {
  const titleMap = {
    add: "添加参与者",
    attendance: "考勤管理",
    score: "考核评分",
    view: "查看详情",
  };
  return titleMap[dialogType.value];
});

// 表单验证规则
const enrollmentRules = {
  employeeId: [{ required: true, message: "请选择员工", trigger: "change" }],
  attendanceStatus: [
    { required: true, message: "请选择出勤状态", trigger: "change" },
  ],
  score: [{ required: true, message: "请输入考核分数", trigger: "blur" }],
};

// 获取状态对应的标签类型
const getStatusType = (status) => {
  const statusMap = {
    未开始: "info",
    进行中: "warning",
    已结束: "success",
    已取消: "danger",
  };
  return statusMap[status] || "";
};

// 获取出勤状态对应的标签类型
const getAttendanceStatusType = (status) => {
  const statusMap = {
    未开始: "info",
    已签到: "warning",
    已签退: "success",
    缺勤: "danger",
  };
  return statusMap[status] || "";
};

// 获取培训计划信息
const getPlanInfo = async () => {
  try {
    const planId = route.query.planId;
    // 这里应该调用API获取数据
    console.log("获取培训计划信息:", planId);
  } catch (error) {
    console.error("获取培训计划信息失败", error);
  }
};

// 获取参与者列表
const getEnrollmentList = async () => {
  loading.value = true;
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      const mockData = Array.from({ length: 10 }, (_, index) => ({
        enrollmentId: `${index + 1}`,
        employeeId: `${index + 1}`,
        employeeName: `员工${index + 1}`,
        departmentName: `部门${index + 1}`,
        positionName: `职位${index + 1}`,
        attendanceStatus: ["未开始", "已签到", "已签退", "缺勤"][index % 4],
        score: index % 2 === 0 ? 85 + index : null,
        feedback: index % 2 === 0 ? "表现良好，积极参与" : "",
        createTime: "2024-03-15 10:00:00",
      }));

      tableData.value = mockData;
      total.value = 100;
      loading.value = false;
    }, 500);
  } catch (error) {
    console.error("获取参与者列表失败", error);
    loading.value = false;
  }
};

// 获取员工列表
const getEmployeeList = async () => {
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      employeeOptions.value = Array.from({ length: 10 }, (_, index) => ({
        value: `${index + 1}`,
        label: `员工${index + 1}`,
      }));
    }, 300);
  } catch (error) {
    console.error("获取员工列表失败", error);
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getEnrollmentList();
};

// 重置查询条件
const resetSearch = () => {
  Object.keys(searchForm).forEach((key) => {
    searchForm[key] = "";
  });
  handleSearch();
};

// 处理分页大小变化
const handleSizeChange = (val) => {
  pageSize.value = val;
  getEnrollmentList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getEnrollmentList();
};

// 处理添加参与者
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(enrollmentForm).forEach((key) => {
    if (key === "attendanceStatus") {
      enrollmentForm[key] = "未开始";
    } else if (key === "score") {
      enrollmentForm[key] = 0;
    } else {
      enrollmentForm[key] = "";
    }
  });

  // 下一个事件循环重置表单验证
  setTimeout(() => {
    enrollmentFormRef.value?.resetFields();
  });
};

// 处理考勤
const handleAttendance = (row) => {
  dialogType.value = "attendance";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(enrollmentForm).forEach((key) => {
    enrollmentForm[key] = row[key];
  });
};

// 处理评分
const handleScore = (row) => {
  dialogType.value = "score";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(enrollmentForm).forEach((key) => {
    enrollmentForm[key] = row[key];
  });
};

// 处理查看
const handleView = (row) => {
  dialogType.value = "view";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(enrollmentForm).forEach((key) => {
    enrollmentForm[key] = row[key];
  });
};

// 处理删除
const handleDelete = (row) => {
  ElMessageBox.confirm("确定要删除此参与者吗？", "警告", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(() => {
      // 这里应该调用API删除数据
      ElMessage.success("删除成功");
      getEnrollmentList();
    })
    .catch(() => {});
};

// 提交表单
const submitForm = () => {
  enrollmentFormRef.value.validate((valid) => {
    if (valid) {
      if (dialogType.value === "add") {
        // 这里应该调用API添加数据
        ElMessage.success("添加成功");
      } else if (dialogType.value === "attendance") {
        // 这里应该调用API更新考勤状态
        ElMessage.success("考勤记录成功");
      } else if (dialogType.value === "score") {
        // 这里应该调用API更新评分
        ElMessage.success("评分成功");
      }
      dialogVisible.value = false;
      getEnrollmentList();
    }
  });
};

// 页面加载时获取数据
onMounted(() => {
  getPlanInfo();
  getEnrollmentList();
  getEmployeeList();
});
</script>

<style scoped>
.enrollment-list {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h2 {
  margin: 0;
  font-size: 20px;
}

.info-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-card {
  margin-bottom: 20px;
}

.table-card {
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
