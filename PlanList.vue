<template>
  <div class="plan-list">
    <div class="page-header">
      <h2>培训计划管理</h2>
      <div class="actions">
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>添加计划
        </el-button>
      </div>
    </div>

    <!-- 搜索区域 -->
    <el-card class="search-card">
      <el-form :model="searchForm" inline>
        <el-form-item label="课程">
          <el-select
            v-model="searchForm.courseId"
            placeholder="请选择课程"
            clearable
          >
            <el-option
              v-for="item in courseOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="培训日期">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            clearable
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="searchForm.status"
            placeholder="请选择状态"
            clearable
          >
            <el-option label="未开始" value="未开始"></el-option>
            <el-option label="进行中" value="进行中"></el-option>
            <el-option label="已结束" value="已结束"></el-option>
            <el-option label="已取消" value="已取消"></el-option>
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
          prop="courseName"
          label="课程名称"
          min-width="150"
        ></el-table-column>
        <el-table-column
          prop="startDate"
          label="开始日期"
          width="120"
        ></el-table-column>
        <el-table-column
          prop="endDate"
          label="结束日期"
          width="120"
        ></el-table-column>
        <el-table-column
          prop="location"
          label="地点"
          width="150"
        ></el-table-column>
        <el-table-column
          prop="maxParticipants"
          label="最大人数"
          width="100"
          align="center"
        ></el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column
          prop="createTime"
          label="创建时间"
          width="180"
        ></el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              link
              @click="handleEdit(scope.row)"
              v-if="scope.row.status === '未开始'"
            >
              <el-icon><Edit /></el-icon>编辑
            </el-button>
            <el-button type="info" link @click="handleView(scope.row)">
              <el-icon><View /></el-icon>查看
            </el-button>
            <el-button
              type="success"
              link
              @click="handleEnrollment(scope.row)"
              v-if="scope.row.status !== '已取消'"
            >
              <el-icon><User /></el-icon>报名管理
            </el-button>
            <el-button
              type="danger"
              link
              @click="handleCancel(scope.row)"
              v-if="scope.row.status === '未开始'"
            >
              <el-icon><Close /></el-icon>取消
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

    <!-- 培训计划表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="
        dialogType === 'add'
          ? '添加计划'
          : dialogType === 'edit'
          ? '编辑计划'
          : '查看计划'
      "
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="planFormRef"
        :model="planForm"
        :rules="planRules"
        label-width="100px"
      >
        <el-form-item label="课程" prop="courseId">
          <el-select
            v-model="planForm.courseId"
            placeholder="请选择课程"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          >
            <el-option
              v-for="item in courseOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="开始日期" prop="startDate">
          <el-date-picker
            v-model="planForm.startDate"
            type="date"
            placeholder="请选择开始日期"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="结束日期" prop="endDate">
          <el-date-picker
            v-model="planForm.endDate"
            type="date"
            placeholder="请选择结束日期"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="地点" prop="location">
          <el-input
            v-model="planForm.location"
            placeholder="请输入培训地点"
            :disabled="dialogType === 'view'"
          ></el-input>
        </el-form-item>
        <el-form-item label="最大人数" prop="maxParticipants">
          <el-input-number
            v-model="planForm.maxParticipants"
            :min="1"
            :max="100"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          ></el-input-number>
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
import { ref, reactive, onMounted } from "vue";
import { useRouter } from "vue-router";
import {
  Plus,
  Edit,
  Search,
  Refresh,
  View,
  Close,
  User,
} from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";

const router = useRouter();

// 表格数据
const loading = ref(false);
const tableData = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 搜索表单
const searchForm = reactive({
  courseId: "",
  dateRange: "",
  status: "",
});

// 培训计划表单
const dialogVisible = ref(false);
const dialogType = ref("add");
const planFormRef = ref(null);
const planForm = reactive({
  planId: "",
  courseId: "",
  startDate: "",
  endDate: "",
  location: "",
  maxParticipants: 1,
  status: "未开始",
});

// 课程选项
const courseOptions = ref([]);

// 表单验证规则
const planRules = {
  courseId: [{ required: true, message: "请选择课程", trigger: "change" }],
  startDate: [{ required: true, message: "请选择开始日期", trigger: "change" }],
  endDate: [{ required: true, message: "请选择结束日期", trigger: "change" }],
  location: [{ required: true, message: "请输入培训地点", trigger: "blur" }],
  maxParticipants: [
    { required: true, message: "请输入最大人数", trigger: "blur" },
  ],
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

// 获取培训计划列表
const getPlanList = async () => {
  loading.value = true;
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      const mockData = Array.from({ length: 10 }, (_, index) => ({
        planId: `${index + 1}`,
        courseId: `${index + 1}`,
        courseName: `课程${index + 1}`,
        startDate: "2024-04-01",
        endDate: "2024-04-05",
        location: `培训室${index + 1}`,
        maxParticipants: 20 + index,
        status: ["未开始", "进行中", "已结束", "已取消"][index % 4],
        createTime: "2024-03-15 10:00:00",
      }));

      tableData.value = mockData;
      total.value = 100;
      loading.value = false;
    }, 500);
  } catch (error) {
    console.error("获取培训计划列表失败", error);
    loading.value = false;
  }
};

// 获取课程列表
const getCourseList = async () => {
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      courseOptions.value = Array.from({ length: 10 }, (_, index) => ({
        value: `${index + 1}`,
        label: `课程${index + 1}`,
      }));
    }, 300);
  } catch (error) {
    console.error("获取课程列表失败", error);
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getPlanList();
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
  getPlanList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getPlanList();
};

// 处理添加计划
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(planForm).forEach((key) => {
    if (key === "maxParticipants") {
      planForm[key] = 1;
    } else if (key === "status") {
      planForm[key] = "未开始";
    } else {
      planForm[key] = "";
    }
  });

  // 下一个事件循环重置表单验证
  setTimeout(() => {
    planFormRef.value?.resetFields();
  });
};

// 处理编辑计划
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(planForm).forEach((key) => {
    planForm[key] = row[key];
  });
};

// 处理查看计划
const handleView = (row) => {
  dialogType.value = "view";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(planForm).forEach((key) => {
    planForm[key] = row[key];
  });
};

// 处理报名管理
const handleEnrollment = (row) => {
  router.push({
    name: "training-enrollment",
    query: { planId: row.planId },
  });
};

// 处理取消计划
const handleCancel = (row) => {
  ElMessageBox.confirm("确定要取消此培训计划吗？", "警告", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(() => {
      // 这里应该调用API取消计划
      ElMessage.success("取消成功");
      getPlanList();
    })
    .catch(() => {});
};

// 提交表单
const submitForm = () => {
  planFormRef.value.validate((valid) => {
    if (valid) {
      if (dialogType.value === "add") {
        // 这里应该调用API添加数据
        ElMessage.success("添加成功");
      } else if (dialogType.value === "edit") {
        // 这里应该调用API更新数据
        ElMessage.success("更新成功");
      }
      dialogVisible.value = false;
      getPlanList();
    }
  });
};

// 页面加载时获取数据
onMounted(() => {
  getPlanList();
  getCourseList();
});
</script>

<style scoped>
.plan-list {
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
