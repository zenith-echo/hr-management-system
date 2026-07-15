<template>
  <div class="discussion-forum">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>讨论区管理</span>
          <el-button type="primary" @click="handleAdd">新增讨论区</el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="讨论区名称">
          <el-input
            v-model="searchForm.forumName"
            placeholder="请输入讨论区名称"
          />
        </el-form-item>
        <el-form-item label="创建日期">
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
            <el-option label="活跃" value="active" />
            <el-option label="已关闭" value="closed" />
            <el-option label="已归档" value="archived" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 讨论区列表 -->
      <el-table :data="tableData" style="width: 100%" border>
        <el-table-column prop="forumName" label="讨论区名称" />
        <el-table-column
          prop="description"
          label="描述"
          show-overflow-tooltip
        />
        <el-table-column prop="createdByName" label="创建者" width="120" />
        <el-table-column prop="createdDate" label="创建日期" width="120" />
        <el-table-column prop="topicCount" label="主题数" width="100" />
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
              @click="handleTopics(scope.row)"
              >主题列表</el-button
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
      :title="dialogType === 'add' ? '新增讨论区' : '编辑讨论区'"
      width="600px"
    >
      <el-form
        ref="forumForm"
        :model="forumForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="讨论区名称" prop="forumName">
          <el-input
            v-model="forumForm.forumName"
            placeholder="请输入讨论区名称"
          />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="forumForm.description"
            type="textarea"
            :rows="4"
            placeholder="请输入讨论区描述"
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="forumForm.status" placeholder="请选择">
            <el-option label="活跃" value="active" />
            <el-option label="已关闭" value="closed" />
            <el-option label="已归档" value="archived" />
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
    <el-dialog v-model="viewDialogVisible" title="讨论区详情" width="600px">
      <div class="forum-content">
        <h3>{{ selectedForum?.forumName }}</h3>
        <div class="description">
          <h4>描述</h4>
          <p>{{ selectedForum?.description }}</p>
        </div>
        <div class="statistics">
          <h4>统计信息</h4>
          <p>主题数：{{ selectedForum?.topicCount }}</p>
          <p>回复数：{{ selectedForum?.replyCount }}</p>
          <p>最后活动：{{ selectedForum?.lastActivityTime }}</p>
        </div>
        <div class="metadata">
          <p>创建者：{{ selectedForum?.createdByName }}</p>
          <p>创建时间：{{ selectedForum?.createdDate }}</p>
          <p>
            状态：
            <el-tag :type="getStatusType(selectedForum?.status)">
              {{ getStatusText(selectedForum?.status) }}
            </el-tag>
          </p>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { useRouter } from "vue-router";

const router = useRouter();

// 搜索表单
const searchForm = reactive({
  forumName: "",
  createdDate: [],
  status: "",
});

// 表格数据
const tableData = ref([
  {
    forumId: 1,
    forumName: "技术交流",
    description: "讨论技术相关话题，分享经验和最佳实践。",
    createdByName: "张三",
    createdDate: "2024-03-01",
    topicCount: 10,
    replyCount: 50,
    lastActivityTime: "2024-03-10 15:30:00",
    status: "active",
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
const selectedForum = ref(null);

// 表单数据
const forumForm = reactive({
  forumName: "",
  description: "",
  status: "active",
});

// 表单规则
const rules = {
  forumName: [{ required: true, message: "请输入讨论区名称", trigger: "blur" }],
  description: [{ required: true, message: "请输入描述", trigger: "blur" }],
  status: [{ required: true, message: "请选择状态", trigger: "change" }],
};

// 状态样式
const getStatusType = (status) => {
  const statusMap = {
    active: "success",
    closed: "warning",
    archived: "info",
  };
  return statusMap[status] || "";
};

// 状态文本
const getStatusText = (status) => {
  const statusMap = {
    active: "活跃",
    closed: "已关闭",
    archived: "已归档",
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
  Object.keys(forumForm).forEach((key) => {
    forumForm[key] = key === "status" ? "active" : "";
  });
};

const handleView = (row) => {
  selectedForum.value = row;
  viewDialogVisible.value = true;
};

const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  Object.assign(forumForm, row);
};

const handleTopics = (row) => {
  router.push(`/dashboard/communication/forum/${row.forumId}/topics`);
};

const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该讨论区吗？", "提示", {
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
.discussion-forum {
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

.forum-content {
  padding: 20px;
}

.forum-content h3 {
  margin-top: 0;
  color: #303133;
  margin-bottom: 20px;
}

.description,
.statistics {
  margin-bottom: 20px;
}

.description h4,
.statistics h4 {
  color: #303133;
  margin-bottom: 10px;
}

.description p,
.statistics p {
  color: #606266;
  line-height: 1.6;
}

.metadata {
  color: #909399;
  font-size: 14px;
  border-top: 1px solid #ebeef5;
  padding-top: 15px;
}

.metadata p {
  margin: 5px 0;
}
</style>
