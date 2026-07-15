<template>
  <page-container title="合规政策管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>新增政策
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="政策名称">
          <el-input
            v-model="searchForm.keyword"
            placeholder="请输入政策名称"
            clearable
          />
        </el-form-item>
        <el-form-item label="生效日期">
          <el-date-picker
            v-model="searchForm.effectiveDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item label="审核日期">
          <el-date-picker
            v-model="searchForm.reviewDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
      </el-form>
    </template>

    <!-- 数据表格 -->
    <el-table :data="tableData" border v-loading="loading">
      <el-table-column type="index" label="序号" width="60" align="center" />
      <el-table-column
        prop="policyName"
        label="政策名称"
        min-width="200"
        show-overflow-tooltip
      />
      <el-table-column prop="effectiveDate" label="生效日期" width="120">
        <template #default="scope">
          {{ formatDate(scope.row.effectiveDate) }}
        </template>
      </el-table-column>
      <el-table-column prop="reviewDate" label="审核日期" width="120">
        <template #default="scope">
          {{ formatDate(scope.row.reviewDate) }}
        </template>
      </el-table-column>
      <el-table-column
        prop="description"
        label="描述"
        min-width="300"
        show-overflow-tooltip
      />
      <el-table-column label="操作" width="180" fixed="right">
        <template #default="scope">
          <el-button type="primary" link @click="handleView(scope.row)">
            <el-icon><View /></el-icon>查看
          </el-button>
          <el-button type="primary" link @click="handleEdit(scope.row)">
            <el-icon><Edit /></el-icon>编辑
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
        layout="total, sizes, prev, pager, next"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 新增/编辑政策对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增政策' : '编辑政策'"
      width="800px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="policyFormRef"
        :model="policyForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="政策名称" prop="policyName">
          <el-input
            v-model="policyForm.policyName"
            placeholder="请输入政策名称"
          />
        </el-form-item>
        <el-form-item label="生效日期" prop="effectiveDate">
          <el-date-picker
            v-model="policyForm.effectiveDate"
            type="date"
            placeholder="选择日期"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="审核日期" prop="reviewDate">
          <el-date-picker
            v-model="policyForm.reviewDate"
            type="date"
            placeholder="选择日期"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="policyForm.description"
            type="textarea"
            :rows="15"
            placeholder="请输入政策描述"
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

    <!-- 查看政策对话框 -->
    <el-dialog
      v-model="viewDialogVisible"
      :title="selectedPolicy?.policyName"
      width="800px"
    >
      <div class="policy-content">
        <div class="metadata">
          <p>
            <span
              >生效日期：{{ formatDate(selectedPolicy?.effectiveDate) }}</span
            >
            <span class="separator">|</span>
            <span>审核日期：{{ formatDate(selectedPolicy?.reviewDate) }}</span>
          </p>
        </div>
        <div class="content">{{ selectedPolicy?.description }}</div>
      </div>
    </el-dialog>
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import {
  Plus,
  Edit,
  Delete,
  Search,
  Refresh,
  View,
} from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";
import PageContainer from "@/components/PageContainer.vue";
import policyApi from "../../api/compliancePolicy";

// 加载状态
const loading = ref(false);

// 搜索表单
const searchForm = reactive({
  keyword: "",
  effectiveDate: [],
  reviewDate: [],
});

// 表格数据
const tableData = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const policyFormRef = ref(null);
const policyForm = reactive({
  policyId: null,
  policyName: "",
  effectiveDate: "",
  reviewDate: "",
  description: "",
});

// 查看对话框
const viewDialogVisible = ref(false);
const selectedPolicy = ref(null);

// 表单规则
const rules = {
  policyName: [
    { required: true, message: "请输入政策名称", trigger: "blur" },
    { min: 2, max: 100, message: "长度在 2 到 100 个字符", trigger: "blur" },
  ],
  effectiveDate: [
    { required: true, message: "请选择生效日期", trigger: "change" },
  ],
  reviewDate: [
    { required: true, message: "请选择审核日期", trigger: "change" },
  ],
  description: [{ required: true, message: "请输入政策描述", trigger: "blur" }],
};

// 格式化日期
const formatDate = (date) => {
  if (!date) return "";
  return date;
};

// 获取政策列表
const getPolicyList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      keyword: searchForm.keyword,
      effectiveDateStart: searchForm.effectiveDate?.[0],
      effectiveDateEnd: searchForm.effectiveDate?.[1],
      reviewDateStart: searchForm.reviewDate?.[0],
      reviewDateEnd: searchForm.reviewDate?.[1],
    };

    const res = await policyApi.getPolicyPage(params);
    if (res.data.code === 0) {
      tableData.value = res.data.data.list || [];
      total.value = res.data.data.total || 0;
    } else {
      throw new Error(res.data.msg || "获取政策列表失败");
    }
  } catch (error) {
    console.error("获取政策列表失败:", error);
    ElMessage.error(error.message || "获取政策列表失败");
  } finally {
    loading.value = false;
  }
};

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1;
  getPolicyList();
};

const resetSearch = () => {
  searchForm.keyword = "";
  searchForm.effectiveDate = [];
  searchForm.reviewDate = [];
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  getPolicyList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  getPolicyList();
};

// 表单处理
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  Object.keys(policyForm).forEach((key) => {
    policyForm[key] = null;
  });
  if (policyFormRef.value) {
    policyFormRef.value.resetFields();
  }
};

const handleView = (row) => {
  selectedPolicy.value = row;
  viewDialogVisible.value = true;
};

const handleEdit = async (row) => {
  try {
    const res = await policyApi.getPolicyById(row.policyId);
    if (res.data.code === 0) {
      dialogType.value = "edit";
      dialogVisible.value = true;
      Object.assign(policyForm, res.data.data);
    } else {
      throw new Error(res.data.msg || "获取政策详情失败");
    }
  } catch (error) {
    console.error("获取政策详情失败:", error);
    ElMessage.error(error.message || "获取政策详情失败");
  }
};

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm("确定要删除此政策吗？", "警告", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    const res = await policyApi.deletePolicy(row.policyId);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      getPolicyList();
    } else {
      throw new Error(res.data.msg || "删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除政策失败:", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

const submitForm = async () => {
  if (!policyFormRef.value) return;

  try {
    await policyFormRef.value.validate();

    const api =
      dialogType.value === "add" ? policyApi.addPolicy : policyApi.updatePolicy;

    const res = await api(policyForm);
    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "add" ? "添加成功" : "更新成功");
      dialogVisible.value = false;
      getPolicyList();
    } else {
      throw new Error(
        res.data.msg || (dialogType.value === "add" ? "添加失败" : "更新失败")
      );
    }
  } catch (error) {
    console.error("提交表单失败:", error);
    ElMessage.error(error.message || "操作失败");
  }
};

// 页面加载时获取数据
onMounted(() => {
  getPolicyList();
});
</script>

<style scoped>
.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.policy-content {
  padding: 20px;
}

.metadata {
  margin-bottom: 20px;
}

.separator {
  margin: 0 10px;
  color: #dcdfe6;
}

.content {
  white-space: pre-wrap;
  line-height: 1.6;
}

:deep(.el-button) {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}
</style>
