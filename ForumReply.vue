<template>
  <div class="forum-reply">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <div class="left">
            <el-button @click="goBack">返回</el-button>
            <span class="topic-title">{{ topicTitle }}</span>
          </div>
          <el-button type="primary" @click="handleAdd">发表回复</el-button>
        </div>
      </template>

      <!-- 主题内容 -->
      <div class="topic-content" v-if="topicData">
        <div class="author-info">
          <el-avatar :size="40" :src="topicData.authorAvatar">
            {{ topicData.createdByName?.charAt(0) }}
          </el-avatar>
          <div class="info">
            <div class="name">{{ topicData.createdByName }}</div>
            <div class="time">{{ topicData.createdDate }}</div>
          </div>
        </div>
        <div class="content">{{ topicData.content }}</div>
      </div>

      <!-- 回复列表 -->
      <div class="reply-list">
        <div class="reply-item" v-for="item in tableData" :key="item.replyId">
          <div class="author-info">
            <el-avatar :size="40" :src="item.replierAvatar">
              {{ item.repliedByName?.charAt(0) }}
            </el-avatar>
            <div class="info">
              <div class="name">{{ item.repliedByName }}</div>
              <div class="time">{{ item.replyDate }}</div>
            </div>
          </div>
          <div class="content">{{ item.content }}</div>
          <div class="actions">
            <el-button
              type="text"
              size="small"
              @click="handleEdit(item)"
              v-if="canEdit(item)"
              >编辑</el-button
            >
            <el-button
              type="text"
              size="small"
              @click="handleDelete(item)"
              v-if="canEdit(item)"
              >删除</el-button
            >
          </div>
        </div>
      </div>

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
      :title="dialogType === 'add' ? '发表回复' : '编辑回复'"
      width="600px"
    >
      <el-form
        ref="replyForm"
        :model="replyForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="回复内容" prop="content">
          <el-input
            v-model="replyForm.content"
            type="textarea"
            :rows="6"
            placeholder="请输入回复内容"
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
import { ref, reactive, onMounted } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { useRouter, useRoute } from "vue-router";

const router = useRouter();
const route = useRoute();

// 主题信息
const topicTitle = ref("Vue 3 组合式 API 最佳实践");
const topicId = ref(route.params.topicId);
const topicData = ref({
  topicId: 1,
  title: "Vue 3 组合式 API 最佳实践",
  content: "# Vue 3 组合式 API 最佳实践\n\n在本文中，我们将探讨...",
  createdByName: "张三",
  createdDate: "2024-03-01 10:00:00",
  authorAvatar: "",
});

// 当前用户ID（模拟）
const currentUserId = "1";

// 表格数据
const tableData = ref([
  {
    replyId: 1,
    content: "非常好的分享，学到了很多！",
    repliedByName: "李四",
    repliedBy: "2",
    replyDate: "2024-03-01 10:30:00",
    replierAvatar: "",
    createTime: "2024-03-01 10:30:00",
    updateTime: "2024-03-01 10:30:00",
  },
]);

// 分页
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(100);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const selectedReply = ref(null);

// 表单数据
const replyForm = reactive({
  content: "",
});

// 表单规则
const rules = {
  content: [{ required: true, message: "请输入回复内容", trigger: "blur" }],
};

// 返回上一页
const goBack = () => {
  router.push(`/dashboard/communication/forum/${route.params.forumId}/topics`);
};

// 检查是否可以编辑
const canEdit = (reply) => {
  return reply.repliedBy === currentUserId;
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
  replyForm.content = "";
};

const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  selectedReply.value = row;
  replyForm.content = row.content;
};

const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该回复吗？", "提示", {
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

// 加载主题和回复信息
onMounted(() => {
  // TODO: 加载主题和回复信息
  console.log("加载主题和回复信息：", topicId.value);
});
</script>

<style scoped>
.forum-reply {
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

.topic-title {
  margin-left: 20px;
  font-size: 16px;
  font-weight: bold;
}

.topic-content {
  padding: 20px;
  margin-bottom: 30px;
  border-bottom: 1px solid #ebeef5;
}

.author-info {
  display: flex;
  align-items: flex-start;
  margin-bottom: 15px;
}

.author-info .info {
  margin-left: 10px;
}

.author-info .name {
  font-size: 14px;
  font-weight: bold;
  color: #303133;
}

.author-info .time {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

.content {
  color: #303133;
  line-height: 1.8;
  white-space: pre-wrap;
}

.reply-list {
  padding: 20px 0;
}

.reply-item {
  padding: 20px;
  border-bottom: 1px solid #ebeef5;
}

.reply-item:last-child {
  border-bottom: none;
}

.reply-item .actions {
  margin-top: 10px;
  text-align: right;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
