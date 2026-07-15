<template>
  <page-container title="文档管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Upload /></el-icon>上传文档
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="关键词">
          <el-input
            v-model="searchForm.keyword"
            placeholder="请输入文档标题/描述"
            clearable
          />
        </el-form-item>
        <el-form-item label="文档类型">
          <el-select
            v-model="searchForm.documentType"
            placeholder="请选择"
            clearable
          >
            <el-option label="制度文件" value="制度文件" />
            <el-option label="技术文档" value="技术文档" />
            <el-option label="市场文档" value="市场文档" />
            <el-option label="需求文档" value="需求文档" />
            <el-option label="财务文档" value="财务文档" />
            <el-option label="培训文档" value="培训文档" />
            <el-option label="销售文档" value="销售文档" />
            <el-option label="人力文档" value="人力文档" />
            <el-option label="设计文档" value="设计文档" />
            <el-option label="项目文档" value="项目文档" />
            <el-option label="行政文档" value="行政文档" />
            <el-option label="客服文档" value="客服文档" />
            <el-option label="安全文档" value="安全文档" />
          </el-select>
        </el-form-item>
        <el-form-item label="上传日期">
          <el-date-picker
            v-model="dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
            @change="handleDateChange"
            clearable
          />
        </el-form-item>
        <el-form-item label="版本">
          <el-input
            v-model="searchForm.version"
            placeholder="请输入版本号"
            clearable
          />
        </el-form-item>
        <el-form-item label="上传者">
          <el-select
            v-model="searchForm.uploaderId"
            placeholder="请选择上传者"
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
      </el-form>
    </template>

    <!-- 数据表格 -->
    <el-table :data="tableData" border v-loading="loading">
      <el-table-column type="index" label="序号" width="60" align="center" />
      <el-table-column prop="title" label="文档标题" show-overflow-tooltip />
      <el-table-column prop="documentType" label="文档类型" width="120">
        <template #default="{ row }">
          {{ getDocumentTypeText(row.documentType) }}
        </template>
      </el-table-column>
      <el-table-column prop="uploadDate" label="上传日期" width="120" />
      <el-table-column prop="uploaderId" label="上传者" width="100">
        <template #default="{ row }">
          {{ getUploaderName(row.uploaderId) }}
        </template>
      </el-table-column>
      <el-table-column prop="version" label="版本" width="80" />
      <el-table-column label="操作" width="180" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="handleEdit(row)">
            <el-icon><Edit /></el-icon>编辑
          </el-button>
          <el-button type="danger" link @click="handleDelete(row)">
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
        layout="total, sizes, prev, pager, next"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '上传文档' : '编辑文档'"
      width="600px"
      :close-on-click-modal="false"
      @closed="handleDialogClosed"
    >
      <el-form
        ref="documentFormRef"
        :model="documentForm"
        :rules="rules"
        label-width="100px"
        :disabled="formLoading"
      >
        <el-form-item label="文档标题" prop="title">
          <el-input v-model="documentForm.title" placeholder="请输入文档标题" />
        </el-form-item>
        <el-form-item label="文档类型" prop="documentType">
          <el-select
            v-model="documentForm.documentType"
            placeholder="请选择文档类型"
          >
            <el-option label="制度文件" value="制度文件" />
            <el-option label="技术文档" value="技术文档" />
            <el-option label="市场文档" value="市场文档" />
            <el-option label="需求文档" value="需求文档" />
            <el-option label="财务文档" value="财务文档" />
            <el-option label="培训文档" value="培训文档" />
            <el-option label="销售文档" value="销售文档" />
            <el-option label="人力文档" value="人力文档" />
            <el-option label="设计文档" value="设计文档" />
            <el-option label="项目文档" value="项目文档" />
            <el-option label="行政文档" value="行政文档" />
            <el-option label="客服文档" value="客服文档" />
            <el-option label="安全文档" value="安全文档" />
          </el-select>
        </el-form-item>
        <el-form-item label="版本" prop="version">
          <el-input v-model="documentForm.version" placeholder="请输入版本号" />
        </el-form-item>
        <el-form-item label="文档描述" prop="description">
          <el-input
            v-model="documentForm.description"
            type="textarea"
            :rows="6"
            placeholder="请输入文档描述"
          />
        </el-form-item>
        <el-form-item label="上传者" prop="uploaderId">
          <el-select
            v-model="documentForm.uploaderId"
            placeholder="请选择上传者"
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
        <el-form-item label="文档文件" prop="file">
          <el-upload
            class="upload-demo"
            :action="uploadUrl"
            :on-success="handleUploadSuccess"
            :on-error="handleUploadError"
            :before-upload="beforeUpload"
            :file-list="fileList"
          >
            <el-button type="primary">选择文件</el-button>
            <template #tip>
              <div class="el-upload__tip">
                支持格式：doc, docx, xls, xlsx, pdf, txt, zip, rar
              </div>
            </template>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button
            type="primary"
            @click="handleSubmit"
            :loading="formLoading"
          >
            确定
          </el-button>
        </span>
      </template>
    </el-dialog>
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, nextTick } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { Upload, Edit, Delete } from "@element-plus/icons-vue";
import PageContainer from "@/components/PageContainer.vue";
import documentsApi from "@/api/documents";
import employeeApi from "@/api/employee";

// 状态定义
const loading = ref(false);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);
const tableData = ref([]);
const dialogVisible = ref(false);
const dialogType = ref("add");
const documentFormRef = ref(null);
const formLoading = ref(false);
const dateRange = ref([]);
const employeeOptions = ref([]);
const employeeMap = ref({});

// 搜索表单
const searchForm = reactive({
  keyword: "",
  documentType: "",
  uploadDateStart: "",
  uploadDateEnd: "",
  version: "",
  uploaderId: "",
});

// 表单数据
const defaultFormData = {
  documentId: null,
  title: "",
  documentType: "",
  version: "",
  description: "",
  uploaderId: "",
};

const documentForm = reactive({ ...defaultFormData });

// 表单验证规则
const rules = {
  title: [
    { required: true, message: "请输入文档标题", trigger: "blur" },
    {
      min: 2,
      max: 100,
      message: "标题长度在2到100个字符之间",
      trigger: "blur",
    },
  ],
  documentType: [
    { required: true, message: "请选择文档类型", trigger: "change" },
  ],
  version: [{ required: true, message: "请输入版本号", trigger: "blur" }],
  description: [{ required: true, message: "请输入文档描述", trigger: "blur" }],
  uploaderId: [{ required: true, message: "请选择上传者", trigger: "change" }],
};

// 文档类型文本映射
const getDocumentTypeText = (type) => {
  return type || "未知类型"; // 因为type就是显示文本，所以直接返回
};

// 日期范围变化处理
const handleDateChange = (val) => {
  if (val) {
    searchForm.uploadDateStart = val[0];
    searchForm.uploadDateEnd = val[1];
  } else {
    searchForm.uploadDateStart = "";
    searchForm.uploadDateEnd = "";
  }
};

// 获取员工列表
const getEmployeeList = async () => {
  try {
    const res = await employeeApi.getEmployeesPage({ pageSize: 1000 });
    if (res.data.code === 0) {
      const employees = res.data.data.list || [];
      // 更新员工映射
      employeeMap.value = {};
      employees.forEach((emp) => {
        employeeMap.value[emp.employeeId] = emp.name;
      });
      // 转换为选择器选项格式
      employeeOptions.value = employees.map((emp) => ({
        value: emp.employeeId,
        label: emp.name,
      }));
    }
  } catch (error) {
    console.error("获取员工列表失败:", error);
    ElMessage.error("获取员工列表失败");
  }
};

// 获取上传者姓名
const getUploaderName = (employeeId) => {
  return employeeMap.value[employeeId] || "未知用户";
};

// API调用函数
const getList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      keyword: searchForm.keyword || undefined,
      documentType: searchForm.documentType || undefined,
      uploadDateStart: searchForm.uploadDateStart || undefined,
      uploadDateEnd: searchForm.uploadDateEnd || undefined,
      version: searchForm.version || undefined,
      uploaderId: searchForm.uploaderId || undefined,
    };

    const res = await documentsApi.getDocumentsPage(params);
    if (res.data.code === 0) {
      tableData.value = res.data.data.list;
      total.value = res.data.data.total;
    }
  } catch (error) {
    console.error("获取列表失败:", error);
    ElMessage.error(error.message || "获取列表失败");
  } finally {
    loading.value = false;
  }
};

// 事件处理函数
const handleSearch = () => {
  currentPage.value = 1;
  getList();
};

const resetSearch = () => {
  dateRange.value = [];
  Object.keys(searchForm).forEach((key) => {
    searchForm[key] = "";
  });
  currentPage.value = 1;
  getList();
};

const handleSizeChange = (val) => {
  pageSize.value = val;
  getList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  getList();
};

const handleAdd = () => {
  dialogType.value = "add";
  // 重置表单数据
  Object.assign(documentForm, defaultFormData);
  // 添加日志
  console.log("新增时的初始表单数据:", documentForm);

  nextTick(() => {
    if (documentFormRef.value) {
      documentFormRef.value.resetFields();
      console.log("重置字段后的表单数据:", documentForm);
    }
  });
  dialogVisible.value = true;
};

const handleEdit = async (row) => {
  dialogType.value = "edit";
  formLoading.value = true;
  try {
    const res = await documentsApi.getDocumentById(row.documentId);
    if (res.data.code === 0) {
      Object.assign(documentForm, {
        ...defaultFormData,
        ...res.data.data,
      });
      dialogVisible.value = true;
    }
  } catch (error) {
    console.error("获取详情失败:", error);
    ElMessage.error(error.message || "获取详情失败");
  } finally {
    formLoading.value = false;
  }
};

const handleDelete = async (row) => {
  try {
    await documentsApi.deleteDocument(row.documentId);
    ElMessage.success("删除成功");
    if (tableData.value.length === 1 && currentPage.value > 1) {
      currentPage.value--;
    }
    getList();
  } catch (error) {
    console.error("删除失败:", error);
    ElMessage.error("删除失败");
  }
};

const handleDialogClosed = () => {
  // 重置表单数据
  Object.assign(documentForm, defaultFormData);
  // 添加日志
  console.log("关闭对话框时的表单数据:", documentForm);

  if (documentFormRef.value) {
    documentFormRef.value.resetFields();
    console.log("关闭对话框并重置字段后的表单数据:", documentForm);
  }
};

const submitForm = async () => {
  if (!documentFormRef.value) return;

  try {
    // 添加表单数据日志
    console.log("提交前的表单数据:", documentForm);

    await documentFormRef.value.validate();
    formLoading.value = true;

    const api =
      dialogType.value === "add"
        ? documentsApi.addDocument
        : documentsApi.updateDocument;

    // 准备提交的数据
    const submitData = {
      ...documentForm,
      uploadDate: new Date().toISOString().split("T")[0], // 添加上传日期
    };

    // 如果是编辑模式，确保documentId存在
    if (dialogType.value === "edit" && !submitData.documentId) {
      throw new Error("文档ID不能为空");
    }

    console.log("准备提交的数据:", submitData);

    const res = await api(submitData);

    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "add" ? "添加成功" : "修改成功");
      dialogVisible.value = false;
      getList();
    } else {
      throw new Error(res.data.msg || "操作失败");
    }
  } catch (error) {
    console.error("提交失败:", error);
    ElMessage.error(error.message || "提交失败");
  } finally {
    formLoading.value = false;
  }
};

onMounted(() => {
  getEmployeeList();
  getList();
});
</script>

<style scoped>
.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.el-upload__tip {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
}
</style>
