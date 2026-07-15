<template>
  <div class="forum-topic">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <div class="left">
            <el-button @click="goBack">返回</el-button>
            <span class="forum-name">{{ forumName }}</span>
          </div>
          <el-button type="primary" @click="handleAdd">发布主题</el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="标题">
          <el-input v-model="searchForm.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="发布日期">
          <el-date-picker
            v-model="searchForm.createdDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择">
            <el-option label="正常" value="normal" />
            <el-option label="置顶" value="pinned" />
            <el-option label="已关闭" value="closed" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 主题列表 -->
      <el-table :data="tableData" style="width: 100%" border>
        <el-table-column prop="title" label="标题" show-overflow-tooltip />
        <el-table-column prop="createdByName" label="发布者" width="120" />
        <el-table-column prop="createdDate" label="发布日期" width="120" />
        <el-table-column prop="replyCount" label="回复数" width="100" />
        <el-table-column prop="viewCount" label="浏览数" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="300">
          <template #default="scope">
            <el-button size="small" @click="handleView(scope.row)"
              >查看</el-button
            >
            <el-button size="small" @click="handleEdit(scope.row)"
              >编辑</el-button
            >
            <el-button
              size="small"
              type="success"
              @click="handleReplies(scope.row)"
              >回复列表</el-button
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

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '发布主题' : '编辑主题'"
      width="800px"
    >
      <el-form
        ref="topicForm"
        :model="topicForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="标题" prop="title">
          <el-input v-model="topicForm.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input
            v-model="topicForm.content"
            type="textarea"
            :rows="10"
            placeholder="请输入主题内容（支持Markdown格式）"
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="topicForm.status" placeholder="请选择">
            <el-option label="正常" value="normal" />
            <el-option label="置顶" value="pinned" />
            <el-option label="已关闭" value="closed" />
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

    <!-- 查看对话框 -->
    <el-dialog v-model="viewDialogVisible" title="主题详情" width="800px">
      <div class="topic-content">
        <h2>{{ selectedTopic?.title }}</h2>
        <div class="metadata">
          <p>
            <span>发布者：{{ selectedTopic?.createdByName }}</span>
            <span class="separator">|</span>
            <span>发布日期：{{ selectedTopic?.createdDate }}</span>
          </p>
          <p>
            <span
              >状态：
              <el-tag :type="getStatusType(selectedTopic?.status)">
                {{ getStatusText(selectedTopic?.status) }}
              </el-tag>
            </span>
            <span class="separator">|</span>
            <span>回复数：{{ selectedTopic?.replyCount }}</span>
            <span class="separator">|</span>
            <span>浏览数：{{ selectedTopic?.viewCount }}</span>
          </p>
        </div>
        <div class="content">
          {{ selectedTopic?.content }}
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { useRouter, useRoute } from "vue-router";

const router = useRouter();
const route = useRoute();

// 讨论区信息
const forumName = ref("技术交流");
const forumId = ref(route.params.forumId);

// 搜索表单
const searchForm = reactive({
  title: "",
  createdDate: [],
  status: "",
});

// 表格数据
const tableData = ref([
  {
    topicId: 1,
    title: "Vue 3 组合式 API 最佳实践",
    content: "# Vue 3 组合式 API 最佳实践\n\n在本文中，我们将探讨...",
    createdByName: "张三",
    createdDate: "2024-03-01",
    replyCount: 5,
    viewCount: 100,
    status: "normal",
    createTime: "2024-03-01 10:00:00",
    updateTime: "2024-03-01 10:00:00",
  },
]);

// 分页
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(100);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const viewDialogVisible = ref(false);
const selectedTopic = ref(null);

// 表单数据
const topicForm = reactive({
  title: "",
  content: "",
  status: "normal",
});

// 表单规则
const rules = {
  title: [{ required: true, message: "请输入标题", trigger: "blur" }],
  content: [{ required: true, message: "请输入内容", trigger: "blur" }],
  status: [{ required: true, message: "请选择状态", trigger: "change" }],
};

// 状态样式
const getStatusType = (status) => {
  const statusMap = {
    normal: "",
    pinned: "success",
    closed: "info",
  };
  return statusMap[status] || "";
};

// 状态文本
const getStatusText = (status) => {
  const statusMap = {
    normal: "正常",
    pinned: "置顶",
    closed: "已关闭",
  };
  return statusMap[status] || status;
};

// 返回上一页
const goBack = () => {
  router.push("/dashboard/communication/forum");
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
  Object.keys(topicForm).forEach((key) => {
    topicForm[key] = key === "status" ? "normal" : "";
  });
};

const handleView = (row) => {
  selectedTopic.value = row;
  viewDialogVisible.value = true;
};

const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  Object.assign(topicForm, row);
};

const handleReplies = (row) => {
  router.push(`/dashboard/communication/forum/topic/${row.topicId}/replies`);
};

const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该主题吗？", "提示", {
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

// 加载讨论区信息
onMounted(() => {
  // TODO: 加载讨论区信息
  console.log("加载讨论区信息：", forumId.value);
});
</script>

<style scoped>
.forum-topic {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header .left {
  display: flex;
  align-items: center;
}

.forum-name {
  margin-left: 20px;
  font-size: 16px;
  font-weight: bold;
}

.search-form {
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.topic-content {
  padding: 20px;
}

.topic-content h2 {
  margin-top: 0;
  color: #303133;
  margin-bottom: 20px;
}

.metadata {
  margin-bottom: 30px;
  color: #606266;
}

.metadata p {
  margin: 10px 0;
}

.separator {
  margin: 0 10px;
  color: #dcdfe6;
}

.content {
  color: #303133;
  line-height: 1.8;
  white-space: pre-wrap;
}
</style>
