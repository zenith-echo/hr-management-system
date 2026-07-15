<template>
  <div class="knowledge-feedback">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>知识库反馈管理</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>新增反馈
          </el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="知识库条目">
          <el-select
            v-model="searchForm.kbId"
            placeholder="请选择知识库条目"
            clearable
            filterable
          >
            <el-option
              v-for="item in kbOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="反馈员工">
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
        <el-form-item label="评分">
          <el-select
            v-model="searchForm.rating"
            placeholder="请选择评分"
            clearable
          >
            <el-option label="1星" :value="1" />
            <el-option label="2星" :value="2" />
            <el-option label="3星" :value="3" />
            <el-option label="4星" :value="4" />
            <el-option label="5星" :value="5" />
          </el-select>
        </el-form-item>
        <el-form-item label="反馈日期">
          <el-date-picker
            v-model="searchForm.feedbackDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item label="评论内容">
          <el-input
            v-model="searchForm.keyword"
            placeholder="请输入评论内容关键字"
            clearable
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>搜索
          </el-button>
          <el-button @click="resetSearch">
            <el-icon><Refresh /></el-icon>重置
          </el-button>
        </el-form-item>
      </el-form>

      <!-- 反馈列表 -->
      <el-table
        :data="tableData"
        style="width: 100%"
        border
        v-loading="loading"
      >
        <el-table-column
          prop="kbTitle"
          label="知识库条目"
          show-overflow-tooltip
        >
          <template #default="scope">
            {{ getKbTitle(scope.row.kbId) }}
          </template>
        </el-table-column>
        <el-table-column prop="employeeName" label="反馈员工" width="120">
          <template #default="scope">
            {{ getEmployeeName(scope.row.employeeId) }}
          </template>
        </el-table-column>
        <el-table-column prop="rating" label="评分" width="150">
          <template #default="scope">
            <el-rate
              v-model="scope.row.rating"
              disabled
              show-score
              text-color="#ff9900"
            />
          </template>
        </el-table-column>
        <el-table-column prop="comment" label="评论" show-overflow-tooltip />
        <el-table-column prop="feedbackDate" label="反馈日期" width="120">
          <template #default="scope">
            {{ formatDate(scope.row.feedbackDate) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="scope">
            <el-button type="primary" link @click="handleView(scope.row)">
              <el-icon><View /></el-icon>查看
            </el-button>
            <el-button type="danger" link @click="handleDelete(scope.row)">
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
        />
      </div>
    </el-card>

    <!-- 新增/查看反馈对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增反馈' : '查看反馈'"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="feedbackFormRef"
        :model="feedbackForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="知识库条目" prop="kbId">
          <el-select
            v-model="feedbackForm.kbId"
            placeholder="请选择知识库条目"
            :disabled="dialogType === 'view'"
            style="width: 100%"
            filterable
          >
            <el-option
              v-for="item in kbOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="反馈员工" prop="employeeId">
          <el-select
            v-model="feedbackForm.employeeId"
            placeholder="请选择员工"
            :disabled="dialogType === 'view'"
            filterable
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
        <el-form-item label="反馈日期" prop="feedbackDate">
          <el-date-picker
            v-model="feedbackForm.feedbackDate"
            type="datetime"
            placeholder="请选择反馈日期"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
            :disabled="dialogType === 'view'"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="评分" prop="rating">
          <el-rate
            v-model="feedbackForm.rating"
            :disabled="dialogType === 'view'"
            show-score
            text-color="#ff9900"
          />
        </el-form-item>
        <el-form-item label="评论" prop="comment">
          <el-input
            v-model="feedbackForm.comment"
            type="textarea"
            :rows="3"
            placeholder="请输入评论"
            :disabled="dialogType === 'view'"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">关闭</el-button>
          <el-button
            v-if="dialogType === 'add'"
            type="primary"
            @click="submitForm"
            :loading="submitting"
          >
            提交
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { useRoute } from "vue-router";
import { Plus, Search, Refresh, View, Delete } from "@element-plus/icons-vue";
import feedbackApi from "../../api/feedback";
import employeeApi from "../../api/employee";
import knowledgeListApi from "../../api/KnowledgeList";

const route = useRoute();

// 搜索表单
const searchForm = reactive({
  kbId: "",
  employeeId: "",
  rating: "",
  feedbackDate: [],
  keyword: "",
});

// 加载状态
const loading = ref(false);
const submitting = ref(false);

// 表格数据
const tableData = ref([]);

// 分页
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const feedbackFormRef = ref();
const feedbackForm = reactive({
  kbId: "",
  employeeId: "",
  rating: 0,
  comment: "",
  feedbackDate: "",
});

// 表单规则
const rules = {
  kbId: [{ required: true, message: "请选择知识库条目", trigger: "change" }],
  employeeId: [
    { required: true, message: "请选择反馈员工", trigger: "change" },
  ],
  rating: [{ required: true, message: "请选择评分", trigger: "change" }],
  comment: [
    { required: true, message: "请输入评论", trigger: "blur" },
    { max: 500, message: "评论不能超过500个字符", trigger: "blur" },
  ],
  feedbackDate: [
    { required: true, message: "请选择反馈日期", trigger: "change" },
  ],
};

// 知识库条目选项
const kbOptions = ref([]);

// 员工选项
const employeeOptions = ref([]);

// 获取知识库列表
const fetchKnowledgeList = async () => {
  try {
    const res = await knowledgeListApi.getKnowledgeListPage({ pageSize: 1000 });
    if (res.data.code === 0) {
      const list = res.data.data.list || [];
      kbOptions.value = list.map((item) => ({
        value: item.kbId.toString(),
        label: item.title,
      }));
    } else {
      throw new Error(res.data.msg || "获取知识库列表失败");
    }
  } catch (error) {
    console.error("获取知识库列表错误:", error);
    ElMessage.error(error.message || "获取知识库列表失败");
  }
};

// 获取员工列表
const fetchEmployees = async () => {
  try {
    const res = await employeeApi.getEmployeesPage({ pageSize: 1000 });
    if (res.data.code === 0) {
      const list = res.data.data.list || [];
      employeeOptions.value = list.map((item) => ({
        value: item.employeeId,
        label: item.name,
      }));
    }
  } catch (error) {
    console.error("获取员工列表错误:", error);
  }
};

// 获取知识库条目标题
const getKbTitle = (kbId) => {
  const kb = kbOptions.value.find((item) => item.value === kbId?.toString());
  return kb ? kb.label : "未知条目";
};

// 获取员工姓名
const getEmployeeName = (employeeId) => {
  const employee = employeeOptions.value.find(
    (item) => item.value === employeeId
  );
  return employee ? employee.label : "未知员工";
};

// 日期格式化
const formatDate = (date) => {
  if (!date) return "";
  const d = new Date(date);
  if (isNaN(d.getTime())) return "";

  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

// 获取反馈列表
const fetchFeedbacks = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      kbId: searchForm.kbId || undefined,
      employeeId: searchForm.employeeId || undefined,
      rating: searchForm.rating || undefined,
      feedbackDateStart: searchForm.feedbackDate?.[0],
      feedbackDateEnd: searchForm.feedbackDate?.[1],
      keyword: searchForm.keyword || undefined,
    };

    const res = await feedbackApi.getFeedbacksPage(params);
    if (res.data.code === 0) {
      // 格式化日期
      tableData.value = (res.data.data.list || []).map((item) => ({
        ...item,
        feedbackDate: formatDate(item.feedbackDate),
      }));
      total.value = res.data.data.total || 0;
    } else {
      throw new Error(res.data.msg || "获取反馈列表失败");
    }
  } catch (error) {
    console.error("获取反馈列表错误:", error);
    ElMessage.error(error.message || "获取反馈列表失败");
  } finally {
    loading.value = false;
  }
};

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1;
  fetchFeedbacks();
};

// 重置搜索
const resetSearch = () => {
  searchForm.kbId = "";
  searchForm.employeeId = "";
  searchForm.rating = "";
  searchForm.feedbackDate = [];
  searchForm.keyword = "";
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  fetchFeedbacks();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  fetchFeedbacks();
};

// 表单处理
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  resetForm();
  // 如果从知识库列表页面跳转过来，自动填充知识库条目ID
  const kbId = route.query.kbId;
  if (kbId) {
    feedbackForm.kbId = kbId;
  }
};

const handleView = async (row) => {
  try {
    const res = await feedbackApi.getFeedbackById(row.feedbackId);
    if (res.data.code === 0) {
      const feedback = res.data.data;
      dialogType.value = "view";
      dialogVisible.value = true;
      Object.assign(feedbackForm, {
        kbId: feedback.kbId,
        employeeId: feedback.employeeId,
        rating: feedback.rating,
        comment: feedback.comment,
        feedbackDate: feedback.feedbackDate,
      });
    }
  } catch (error) {
    console.error("获取反馈详情错误:", error);
    ElMessage.error(error.message || "获取反馈详情失败");
  }
};

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm("确认删除该反馈记录吗？", "提示", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    const res = await feedbackApi.deleteFeedback(row.feedbackId);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      fetchFeedbacks();
    } else {
      throw new Error(res.data.msg || "删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除反馈错误:", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

// 重置表单
const resetForm = () => {
  if (feedbackFormRef.value) {
    feedbackFormRef.value.resetFields();
  }
  Object.assign(feedbackForm, {
    kbId: "",
    employeeId: "",
    rating: 0,
    comment: "",
    feedbackDate: "",
  });
};

const submitForm = async () => {
  if (!feedbackFormRef.value) return;

  try {
    await feedbackFormRef.value.validate();
    submitting.value = true;

    const res = await feedbackApi.addFeedback(feedbackForm);
    if (res.data.code === 0) {
      ElMessage.success("提交成功");
      dialogVisible.value = false;
      fetchFeedbacks();
    } else {
      throw new Error(res.data.msg || "提交失败");
    }
  } catch (error) {
    console.error("提交表单错误:", error);
    ElMessage.error(error.message || "提交失败");
  } finally {
    submitting.value = false;
  }
};

// 初始加载
onMounted(() => {
  fetchKnowledgeList();
  fetchEmployees();
  fetchFeedbacks();
});
</script>

<style scoped>
.knowledge-feedback {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.search-form :deep(.el-select),
.search-form :deep(.el-date-editor) {
  width: 220px;
}

.search-form :deep(.el-input) {
  width: 220px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

:deep(.el-form--inline .el-form-item) {
  margin-right: 0;
}

:deep(.el-button) {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

:deep(.el-rate) {
  margin-top: 4px;
}
</style>
