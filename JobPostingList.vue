<template>
  <div class="job-posting-list">
    <div class="page-header">
      <h2>职位发布</h2>
      <div class="actions">
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>发布职位
        </el-button>
      </div>
    </div>

    <!-- 搜索区域 -->
    <el-card class="search-card">
      <el-form :model="searchForm" inline>
        <el-form-item label="职位">
          <el-select
            v-model="searchForm.positionId"
            placeholder="请选择职位"
            clearable
          >
            <el-option
              v-for="item in positionOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="部门">
          <el-select
            v-model="searchForm.departmentId"
            placeholder="请选择部门"
            clearable
          >
            <el-option
              v-for="item in departmentOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="发布日期">
          <el-date-picker
            v-model="searchForm.publishDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            clearable
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="searchForm.status"
            placeholder="请选择状态"
            clearable
          >
            <el-option label="草稿" value="草稿" />
            <el-option label="已发布" value="已发布" />
            <el-option label="已关闭" value="已关闭" />
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
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="title" label="职位标题" min-width="150" />
        <el-table-column prop="departmentName" label="所属部门" width="120" />
        <el-table-column prop="positionName" label="职位名称" width="120" />
        <el-table-column prop="headcount" label="招聘人数" width="100" />
        <el-table-column prop="salaryRange" label="薪资范围" width="150" />
        <el-table-column prop="publishDate" label="发布日期" width="120" />
        <el-table-column prop="deadline" label="截止日期" width="120" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="scope">
            <el-button type="primary" link @click="handleEdit(scope.row)">
              <el-icon><Edit /></el-icon>编辑
            </el-button>
            <el-button
              type="success"
              link
              @click="handlePublish(scope.row)"
              v-if="scope.row.status === '草稿'"
            >
              <el-icon><Upload /></el-icon>发布
            </el-button>
            <el-button
              type="warning"
              link
              @click="handleClose(scope.row)"
              v-if="scope.row.status === '已发布'"
            >
              <el-icon><CircleClose /></el-icon>关闭
            </el-button>
            <el-popconfirm
              title="确定要删除此职位发布吗？"
              @confirm="handleDelete(scope.row)"
              v-if="scope.row.status === '草稿'"
            >
              <template #reference>
                <el-button type="danger" link>
                  <el-icon><Delete /></el-icon>删除
                </el-button>
              </template>
            </el-popconfirm>
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

    <!-- 职位发布表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '发布职位' : '编辑职位'"
      width="700px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="postingFormRef"
        :model="postingForm"
        :rules="postingRules"
        label-width="100px"
      >
        <el-form-item label="职位标题" prop="title">
          <el-input v-model="postingForm.title" placeholder="请输入职位标题" />
        </el-form-item>
        <el-form-item label="部门" prop="departmentId">
          <el-select
            v-model="postingForm.departmentId"
            placeholder="请选择部门"
            style="width: 100%"
          >
            <el-option
              v-for="item in departmentOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="职位" prop="positionId">
          <el-select
            v-model="postingForm.positionId"
            placeholder="请选择职位"
            style="width: 100%"
          >
            <el-option
              v-for="item in positionOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="招聘人数" prop="headcount">
          <el-input-number
            v-model="postingForm.headcount"
            :min="1"
            :max="999"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="薪资范围" prop="salaryRange">
          <el-input
            v-model="postingForm.salaryRange"
            placeholder="例如：8k-15k"
          />
        </el-form-item>
        <el-form-item label="截止日期" prop="deadline">
          <el-date-picker
            v-model="postingForm.deadline"
            type="date"
            placeholder="选择截止日期"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="职位描述" prop="description">
          <el-input
            v-model="postingForm.description"
            type="textarea"
            rows="4"
            placeholder="请输入职位描述"
          />
        </el-form-item>
        <el-form-item label="任职要求" prop="requirements">
          <el-input
            v-model="postingForm.requirements"
            type="textarea"
            rows="4"
            placeholder="请输入任职要求"
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
import {
  Plus,
  Edit,
  Delete,
  Search,
  Refresh,
  Upload,
  CircleClose,
} from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";

// 表格数据
const loading = ref(false);
const tableData = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 搜索表单
const searchForm = reactive({
  positionId: "",
  departmentId: "",
  publishDate: "",
  status: "",
});

// 职位发布表单
const dialogVisible = ref(false);
const dialogType = ref("add");
const postingFormRef = ref(null);
const postingForm = reactive({
  postingId: "",
  title: "",
  positionId: "",
  departmentId: "",
  description: "",
  requirements: "",
  salaryRange: "",
  headcount: 1,
  publishDate: "",
  deadline: "",
  status: "草稿",
});

// 表单验证规则
const postingRules = {
  title: [{ required: true, message: "请输入职位标题", trigger: "blur" }],
  departmentId: [{ required: true, message: "请选择部门", trigger: "change" }],
  positionId: [{ required: true, message: "请选择职位", trigger: "change" }],
  headcount: [{ required: true, message: "请输入招聘人数", trigger: "blur" }],
  salaryRange: [{ required: true, message: "请输入薪资范围", trigger: "blur" }],
  deadline: [{ required: true, message: "请选择截止日期", trigger: "change" }],
  description: [{ required: true, message: "请输入职位描述", trigger: "blur" }],
  requirements: [
    { required: true, message: "请输入任职要求", trigger: "blur" },
  ],
};

// 部门选项
const departmentOptions = ref([]);

// 职位选项
const positionOptions = ref([]);

// 获取状态对应的标签类型
const getStatusType = (status) => {
  const statusMap = {
    草稿: "info",
    已发布: "success",
    已关闭: "warning",
  };
  return statusMap[status] || "";
};

// 获取职位发布列表
const getJobPostingList = async () => {
  loading.value = true;
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      const mockData = Array.from({ length: 10 }, (_, index) => ({
        postingId: `${index + 1}`,
        title: `高级前端开发工程师${index + 1}`,
        departmentId: `${(index % 3) + 1}`,
        departmentName: ["技术部", "产品部", "市场部"][index % 3],
        positionId: `${(index % 4) + 1}`,
        positionName: ["前端开发", "后端开发", "产品经理", "UI设计师"][
          index % 4
        ],
        description: "负责公司前端项目的开发和维护",
        requirements: "3年以上前端开发经验，精通Vue.js",
        salaryRange: "15k-25k",
        headcount: 2,
        publishDate: "2024-03-15",
        deadline: "2024-04-15",
        status: ["草稿", "已发布", "已关闭"][index % 3],
      }));

      tableData.value = mockData;
      total.value = 100;
      loading.value = false;
    }, 500);
  } catch (error) {
    console.error("获取职位发布列表失败", error);
    loading.value = false;
  }
};

// 获取部门列表
const getDepartmentList = async () => {
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      departmentOptions.value = [
        { value: "1", label: "技术部" },
        { value: "2", label: "产品部" },
        { value: "3", label: "市场部" },
      ];
    }, 300);
  } catch (error) {
    console.error("获取部门列表失败", error);
  }
};

// 获取职位列表
const getPositionList = async () => {
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      positionOptions.value = [
        { value: "1", label: "前端开发" },
        { value: "2", label: "后端开发" },
        { value: "3", label: "产品经理" },
        { value: "4", label: "UI设计师" },
      ];
    }, 300);
  } catch (error) {
    console.error("获取职位列表失败", error);
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getJobPostingList();
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
  getJobPostingList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getJobPostingList();
};

// 处理添加职位
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(postingForm).forEach((key) => {
    if (key === "headcount") {
      postingForm[key] = 1;
    } else {
      postingForm[key] = "";
    }
  });
  postingForm.status = "草稿";

  // 下一个事件循环重置表单验证
  setTimeout(() => {
    postingFormRef.value?.resetFields();
  });
};

// 处理编辑职位
const handleEdit = (row) => {
  if (row.status === "已关闭") {
    ElMessage.warning("已关闭的职位不能编辑");
    return;
  }

  dialogType.value = "edit";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(postingForm).forEach((key) => {
    postingForm[key] = row[key];
  });
};

// 处理发布职位
const handlePublish = (row) => {
  ElMessageBox.confirm("确定要发布此职位吗？", "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "info",
  })
    .then(() => {
      // 这里应该调用API发布职位
      ElMessage.success("发布成功");
      getJobPostingList();
    })
    .catch(() => {});
};

// 处理关闭职位
const handleClose = (row) => {
  ElMessageBox.confirm("确定要关闭此职位吗？", "警告", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(() => {
      // 这里应该调用API关闭职位
      ElMessage.success("关闭成功");
      getJobPostingList();
    })
    .catch(() => {});
};

// 处理删除职位
const handleDelete = (row) => {
  ElMessageBox.confirm("确定要删除此职位发布吗？", "警告", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(() => {
      // 这里应该调用API删除数据
      ElMessage.success("删除成功");
      getJobPostingList();
    })
    .catch(() => {});
};

// 提交表单
const submitForm = () => {
  postingFormRef.value.validate((valid) => {
    if (valid) {
      if (dialogType.value === "add") {
        // 这里应该调用API添加数据
        ElMessage.success("添加成功");
      } else if (dialogType.value === "edit") {
        // 这里应该调用API更新数据
        ElMessage.success("更新成功");
      }
      dialogVisible.value = false;
      getJobPostingList();
    }
  });
};

// 页面加载时获取数据
onMounted(() => {
  getJobPostingList();
  getDepartmentList();
  getPositionList();
});
</script>

<style scoped>
.job-posting-list {
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
