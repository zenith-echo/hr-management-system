<template>
  <div class="candidate-list">
    <div class="page-header">
      <h2>应聘者管理</h2>
      <div class="actions">
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>添加应聘者
        </el-button>
      </div>
    </div>

    <!-- 搜索区域 -->
    <el-card class="search-card">
      <el-form :model="searchForm" inline>
        <el-form-item label="姓名">
          <el-input
            v-model="searchForm.name"
            placeholder="请输入姓名"
            clearable
          />
        </el-form-item>
        <el-form-item label="手机">
          <el-input
            v-model="searchForm.phone"
            placeholder="请输入手机号"
            clearable
          />
        </el-form-item>
        <el-form-item label="学历">
          <el-select
            v-model="searchForm.education"
            placeholder="请选择学历"
            clearable
          >
            <el-option label="大专" value="大专" />
            <el-option label="本科" value="本科" />
            <el-option label="硕士" value="硕士" />
            <el-option label="博士" value="博士" />
          </el-select>
        </el-form-item>
        <el-form-item label="工作经验">
          <el-select
            v-model="searchForm.experience"
            placeholder="请选择工作经验"
            clearable
          >
            <el-option label="应届生" value="应届生" />
            <el-option label="1-3年" value="1-3年" />
            <el-option label="3-5年" value="3-5年" />
            <el-option label="5-10年" value="5-10年" />
            <el-option label="10年以上" value="10年以上" />
          </el-select>
        </el-form-item>
        <el-form-item label="来源">
          <el-select
            v-model="searchForm.source"
            placeholder="请选择来源"
            clearable
          >
            <el-option label="内部推荐" value="内部推荐" />
            <el-option label="社会招聘" value="社会招聘" />
            <el-option label="校园招聘" value="校园招聘" />
            <el-option label="猎头推荐" value="猎头推荐" />
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
        <el-table-column prop="name" label="姓名" width="100" />
        <el-table-column prop="gender" label="性别" width="80">
          <template #default="scope">
            {{ scope.row.gender === "M" ? "男" : "女" }}
          </template>
        </el-table-column>
        <el-table-column prop="birthDate" label="出生日期" width="120" />
        <el-table-column prop="phone" label="手机" width="120" />
        <el-table-column prop="email" label="邮箱" width="180" />
        <el-table-column prop="education" label="学历" width="100" />
        <el-table-column prop="experience" label="工作经验" width="100" />
        <el-table-column prop="source" label="来源" width="100" />
        <el-table-column label="简历" width="100">
          <template #default="scope">
            <el-button
              type="primary"
              link
              @click="handleViewResume(scope.row)"
              v-if="scope.row.resumePath"
            >
              <el-icon><Document /></el-icon>查看
            </el-button>
            <span v-else>未上传</span>
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
              @click="handleUploadResume(scope.row)"
            >
              <el-icon><Upload /></el-icon>上传简历
            </el-button>
            <el-popconfirm
              title="确定要删除此应聘者吗？"
              @confirm="handleDelete(scope.row)"
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

    <!-- 应聘者表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '添加应聘者' : '编辑应聘者'"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="candidateFormRef"
        :model="candidateForm"
        :rules="candidateRules"
        label-width="100px"
      >
        <el-form-item label="姓名" prop="name">
          <el-input v-model="candidateForm.name" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="candidateForm.gender">
            <el-radio label="M">男</el-radio>
            <el-radio label="F">女</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="出生日期" prop="birthDate">
          <el-date-picker
            v-model="candidateForm.birthDate"
            type="date"
            placeholder="选择日期"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="手机" prop="phone">
          <el-input v-model="candidateForm.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="candidateForm.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="学历" prop="education">
          <el-select
            v-model="candidateForm.education"
            placeholder="请选择学历"
            style="width: 100%"
          >
            <el-option label="大专" value="大专" />
            <el-option label="本科" value="本科" />
            <el-option label="硕士" value="硕士" />
            <el-option label="博士" value="博士" />
          </el-select>
        </el-form-item>
        <el-form-item label="工作经验" prop="experience">
          <el-select
            v-model="candidateForm.experience"
            placeholder="请选择工作经验"
            style="width: 100%"
          >
            <el-option label="应届生" value="应届生" />
            <el-option label="1-3年" value="1-3年" />
            <el-option label="3-5年" value="3-5年" />
            <el-option label="5-10年" value="5-10年" />
            <el-option label="10年以上" value="10年以上" />
          </el-select>
        </el-form-item>
        <el-form-item label="来源" prop="source">
          <el-select
            v-model="candidateForm.source"
            placeholder="请选择来源"
            style="width: 100%"
          >
            <el-option label="内部推荐" value="内部推荐" />
            <el-option label="社会招聘" value="社会招聘" />
            <el-option label="校园招聘" value="校园招聘" />
            <el-option label="猎头推荐" value="猎头推荐" />
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

    <!-- 简历上传对话框 -->
    <el-dialog
      v-model="uploadDialogVisible"
      title="上传简历"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-upload
        class="upload-demo"
        drag
        action="/api/upload"
        :on-success="handleUploadSuccess"
        :on-error="handleUploadError"
        :before-upload="beforeUpload"
        accept=".pdf,.doc,.docx"
      >
        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <template #tip>
          <div class="el-upload__tip">
            只能上传 PDF/Word 文件，且不超过 10MB
          </div>
        </template>
      </el-upload>
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
  Document,
  UploadFilled,
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
  name: "",
  phone: "",
  education: "",
  experience: "",
  source: "",
});

// 应聘者表单
const dialogVisible = ref(false);
const dialogType = ref("add");
const candidateFormRef = ref(null);
const candidateForm = reactive({
  candidateId: "",
  name: "",
  gender: "M",
  birthDate: "",
  phone: "",
  email: "",
  education: "",
  experience: "",
  source: "",
  resumePath: "",
});

// 简历上传对话框
const uploadDialogVisible = ref(false);
const currentCandidate = ref(null);

// 表单验证规则
const candidateRules = {
  name: [{ required: true, message: "请输入姓名", trigger: "blur" }],
  gender: [{ required: true, message: "请选择性别", trigger: "change" }],
  birthDate: [{ required: true, message: "请选择出生日期", trigger: "change" }],
  phone: [
    { required: true, message: "请输入手机号", trigger: "blur" },
    {
      pattern: /^1[3-9]\d{9}$/,
      message: "请输入正确的手机号",
      trigger: "blur",
    },
  ],
  email: [
    { required: true, message: "请输入邮箱", trigger: "blur" },
    {
      type: "email",
      message: "请输入正确的邮箱地址",
      trigger: ["blur", "change"],
    },
  ],
  education: [{ required: true, message: "请选择学历", trigger: "change" }],
  experience: [
    { required: true, message: "请选择工作经验", trigger: "change" },
  ],
  source: [{ required: true, message: "请选择来源", trigger: "change" }],
};

// 获取应聘者列表
const getCandidateList = async () => {
  loading.value = true;
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      const mockData = Array.from({ length: 10 }, (_, index) => ({
        candidateId: `${index + 1}`,
        name: `候选人${index + 1}`,
        gender: index % 2 === 0 ? "M" : "F",
        birthDate: "1990-01-01",
        phone: "13800138000",
        email: `candidate${index + 1}@example.com`,
        education: ["本科", "硕士", "博士"][index % 3],
        experience: ["应届生", "1-3年", "3-5年", "5-10年"][index % 4],
        source: ["内部推荐", "社会招聘", "校园招聘", "猎头推荐"][index % 4],
        resumePath: index % 2 === 0 ? `/uploads/resume${index + 1}.pdf` : "",
      }));

      tableData.value = mockData;
      total.value = 100;
      loading.value = false;
    }, 500);
  } catch (error) {
    console.error("获取应聘者列表失败", error);
    loading.value = false;
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getCandidateList();
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
  getCandidateList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getCandidateList();
};

// 处理添加应聘者
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(candidateForm).forEach((key) => {
    if (key === "gender") {
      candidateForm[key] = "M";
    } else {
      candidateForm[key] = "";
    }
  });

  // 下一个事件循环重置表单验证
  setTimeout(() => {
    candidateFormRef.value?.resetFields();
  });
};

// 处理编辑应聘者
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(candidateForm).forEach((key) => {
    candidateForm[key] = row[key];
  });
};

// 处理删除应聘者
const handleDelete = (row) => {
  ElMessageBox.confirm("确定要删除此应聘者吗？", "警告", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(() => {
      // 这里应该调用API删除数据
      ElMessage.success("删除成功");
      getCandidateList();
    })
    .catch(() => {});
};

// 处理查看简历
const handleViewResume = (row) => {
  // 这里应该调用API获取简历文件并在新窗口打开
  window.open(row.resumePath, "_blank");
};

// 处理上传简历
const handleUploadResume = (row) => {
  currentCandidate.value = row;
  uploadDialogVisible.value = true;
};

// 上传前校验
const beforeUpload = (file) => {
  const isValidType = [
    "application/pdf",
    "application/msword",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  ].includes(file.type);
  const isLt10M = file.size / 1024 / 1024 < 10;

  if (!isValidType) {
    ElMessage.error("只能上传PDF/Word文件!");
    return false;
  }
  if (!isLt10M) {
    ElMessage.error("文件大小不能超过 10MB!");
    return false;
  }
  return true;
};

// 上传成功回调
const handleUploadSuccess = (response) => {
  ElMessage.success("上传成功");
  uploadDialogVisible.value = false;
  getCandidateList();
};

// 上传失败回调
const handleUploadError = () => {
  ElMessage.error("上传失败");
};

// 提交表单
const submitForm = () => {
  candidateFormRef.value.validate((valid) => {
    if (valid) {
      if (dialogType.value === "add") {
        // 这里应该调用API添加数据
        ElMessage.success("添加成功");
      } else if (dialogType.value === "edit") {
        // 这里应该调用API更新数据
        ElMessage.success("更新成功");
      }
      dialogVisible.value = false;
      getCandidateList();
    }
  });
};

// 页面加载时获取数据
onMounted(() => {
  getCandidateList();
});
</script>

<style scoped>
.candidate-list {
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

.upload-demo {
  text-align: center;
}

.el-upload__tip {
  color: #909399;
  font-size: 12px;
  margin-top: 7px;
}
</style>
