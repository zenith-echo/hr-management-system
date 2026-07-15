<template>
  <div class="announcement">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>公告管理</span>
          <el-button type="primary" @click="handleAdd">发布公告</el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="标题">
          <el-input v-model="searchForm.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="发布日期">
          <el-date-picker
            v-model="searchForm.postDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>
        <el-form-item label="优先级">
          <el-select v-model="searchForm.priority" placeholder="请选择">
            <el-option label="低" value="low" />
            <el-option label="中" value="medium" />
            <el-option label="高" value="high" />
          </el-select>
        </el-form-item>
        <el-form-item label="目标受众">
          <el-select v-model="searchForm.targetAudience" placeholder="请选择">
            <el-option label="全体员工" value="all" />
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

      <!-- 公告列表 -->
      <el-table :data="tableData" style="width: 100%" border>
        <el-table-column prop="title" label="标题" show-overflow-tooltip />
        <el-table-column prop="postedByName" label="发布者" width="120" />
        <el-table-column prop="postDate" label="发布日期" width="120" />
        <el-table-column prop="expiryDate" label="过期日期" width="120" />
        <el-table-column prop="priority" label="优先级" width="100">
          <template #default="scope">
            <el-tag :type="getPriorityType(scope.row.priority)">
              {{ getPriorityText(scope.row.priority) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="targetAudience" label="目标受众" width="120">
          <template #default="scope">
            {{ getTargetAudienceText(scope.row.targetAudience) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250">
          <template #default="scope">
            <el-button size="small" @click="handleView(scope.row)"
              >查看</el-button
            >
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

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '发布公告' : '编辑公告'"
      width="800px"
    >
      <el-form
        ref="announcementForm"
        :model="announcementForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="标题" prop="title">
          <el-input v-model="announcementForm.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input
            v-model="announcementForm.content"
            type="textarea"
            :rows="10"
            placeholder="请输入公告内容（支持Markdown格式）"
          />
        </el-form-item>
        <el-form-item label="发布日期" prop="postDate">
          <el-date-picker
            v-model="announcementForm.postDate"
            type="date"
            placeholder="选择日期"
          />
        </el-form-item>
        <el-form-item label="过期日期" prop="expiryDate">
          <el-date-picker
            v-model="announcementForm.expiryDate"
            type="date"
            placeholder="选择日期"
          />
        </el-form-item>
        <el-form-item label="优先级" prop="priority">
          <el-select v-model="announcementForm.priority" placeholder="请选择">
            <el-option label="低" value="low" />
            <el-option label="中" value="medium" />
            <el-option label="高" value="high" />
          </el-select>
        </el-form-item>
        <el-form-item label="目标受众" prop="targetAudience">
          <el-select
            v-model="announcementForm.targetAudience"
            placeholder="请选择"
          >
            <el-option label="全体员工" value="all" />
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

    <!-- 查看对话框 -->
    <el-dialog v-model="viewDialogVisible" title="公告详情" width="800px">
      <div class="announcement-content">
        <h2>{{ selectedAnnouncement?.title }}</h2>
        <div class="metadata">
          <p>
            <span>发布者：{{ selectedAnnouncement?.postedByName }}</span>
            <span class="separator">|</span>
            <span>发布日期：{{ selectedAnnouncement?.postDate }}</span>
            <span class="separator">|</span>
            <span>过期日期：{{ selectedAnnouncement?.expiryDate }}</span>
          </p>
          <p>
            <span
              >优先级：
              <el-tag :type="getPriorityType(selectedAnnouncement?.priority)">
                {{ getPriorityText(selectedAnnouncement?.priority) }}
              </el-tag>
            </span>
            <span class="separator">|</span>
            <span
              >目标受众：{{
                getTargetAudienceText(selectedAnnouncement?.targetAudience)
              }}</span
            >
          </p>
        </div>
        <div class="content">
          {{ selectedAnnouncement?.content }}
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";

// 搜索表单
const searchForm = reactive({
  title: "",
  postDate: [],
  priority: "",
  targetAudience: "",
});

// 表格数据
const tableData = ref([
  {
    announcementId: 1,
    title: "公司年度会议通知",
    postedByName: "张三",
    postDate: "2024-03-01",
    expiryDate: "2024-03-31",
    priority: "high",
    targetAudience: "all",
    content:
      "# 公司年度会议通知\n\n各位同事：\n\n公司将于2024年3月15日举行年度会议...",
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
const selectedAnnouncement = ref(null);

// 表单数据
const announcementForm = reactive({
  title: "",
  content: "",
  postDate: "",
  expiryDate: "",
  priority: "medium",
  targetAudience: "all",
});

// 部门选项
const departmentOptions = [
  { value: "1", label: "技术部" },
  { value: "2", label: "市场部" },
  { value: "3", label: "运营部" },
];

// 表单规则
const rules = {
  title: [{ required: true, message: "请输入标题", trigger: "blur" }],
  content: [{ required: true, message: "请输入内容", trigger: "blur" }],
  postDate: [{ required: true, message: "请选择发布日期", trigger: "change" }],
  expiryDate: [
    { required: true, message: "请选择过期日期", trigger: "change" },
  ],
  priority: [{ required: true, message: "请选择优先级", trigger: "change" }],
  targetAudience: [
    { required: true, message: "请选择目标受众", trigger: "change" },
  ],
};

// 优先级样式
const getPriorityType = (priority) => {
  const priorityMap = {
    low: "info",
    medium: "warning",
    high: "danger",
  };
  return priorityMap[priority] || "";
};

// 优先级文本
const getPriorityText = (priority) => {
  const priorityMap = {
    low: "低",
    medium: "中",
    high: "高",
  };
  return priorityMap[priority] || priority;
};

// 目标受众文本
const getTargetAudienceText = (targetAudience) => {
  if (targetAudience === "all") {
    return "全体员工";
  }
  const department = departmentOptions.find(
    (item) => item.value === targetAudience
  );
  return department ? department.label : targetAudience;
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
  Object.keys(announcementForm).forEach((key) => {
    announcementForm[key] =
      key === "priority" ? "medium" : key === "targetAudience" ? "all" : "";
  });
};

const handleView = (row) => {
  selectedAnnouncement.value = row;
  viewDialogVisible.value = true;
};

const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  Object.assign(announcementForm, row);
};

const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该公告吗？", "提示", {
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
.announcement {
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

.announcement-content {
  padding: 20px;
}

.announcement-content h2 {
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
