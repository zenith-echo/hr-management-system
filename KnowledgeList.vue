<template>
  <page-container title="知识库管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>新增条目
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="标题">
          <el-input
            v-model="searchForm.title"
            placeholder="请输入标题"
            clearable
          />
        </el-form-item>
        <el-form-item label="分类">
          <el-cascader
            v-model="searchForm.categoryId"
            :options="categoryOptions"
            :props="{ checkStrictly: true }"
            placeholder="请选择分类"
            clearable
          />
        </el-form-item>
        <el-form-item label="创建日期">
          <el-date-picker
            v-model="searchForm.createdDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            clearable
          />
        </el-form-item>
      </el-form>
    </template>

    <!-- 数据表格 -->
    <el-table :data="tableData" border v-loading="loading">
      <el-table-column prop="title" label="标题" show-overflow-tooltip />
      <el-table-column prop="categoryName" label="分类" width="120" />
      <el-table-column prop="creatorName" label="创建者" width="100" />
      <el-table-column prop="createdDate" label="创建日期" width="120">
        <template #default="scope">
          {{ formatDate(scope.row.createdDate) }}
        </template>
      </el-table-column>
      <el-table-column prop="lastUpdated" label="最后更新" width="120">
        <template #default="scope">
          {{ formatDate(scope.row.lastUpdated) }}
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
        layout="total, sizes, prev, pager, next"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增知识库条目' : '编辑知识库条目'"
      width="800px"
    >
      <el-form
        ref="knowledgeFormRef"
        :model="knowledgeForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="标题" prop="title">
          <el-input v-model="knowledgeForm.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="分类" prop="categoryId">
          <el-cascader
            v-model="knowledgeForm.categoryId"
            :options="categoryOptions"
            :props="{ checkStrictly: true }"
            placeholder="请选择分类"
          />
        </el-form-item>
        <el-form-item label="创建者" prop="createdBy">
          <el-select
            v-model="knowledgeForm.createdBy"
            placeholder="请选择创建者"
            filterable
            clearable
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input
            v-model="knowledgeForm.content"
            type="textarea"
            :rows="15"
            placeholder="请输入内容"
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

    <!-- 查看对话框 -->
    <el-dialog
      v-model="viewDialogVisible"
      :title="selectedKnowledge?.title"
      width="800px"
    >
      <div class="knowledge-content">
        <div class="metadata">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="创建者">
              {{ selectedKnowledge?.creatorName }}
            </el-descriptions-item>
            <el-descriptions-item label="分类">
              {{ selectedKnowledge?.categoryName }}
            </el-descriptions-item>
            <el-descriptions-item label="创建日期">
              {{ formatDate(selectedKnowledge?.createdDate) }}
            </el-descriptions-item>
            <el-descriptions-item label="最后更新">
              {{ formatDate(selectedKnowledge?.lastUpdated) }}
            </el-descriptions-item>
          </el-descriptions>
        </div>
        <div class="content">
          {{ selectedKnowledge?.content }}
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="viewDialogVisible = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import { useRouter } from "vue-router";
import { ElMessage, ElMessageBox } from "element-plus";
import { Plus, View, Delete } from "@element-plus/icons-vue";
import PageContainer from "@/components/PageContainer.vue";
import knowledgeListApi from "@/api/KnowledgeList";
import categoryApi from "@/api/knowledge";
import employeeApi from "@/api/employee";

const router = useRouter();

// 搜索表单
const searchForm = reactive({
  title: "",
  categoryId: "",
  createdDate: [],
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
const viewDialogVisible = ref(false);
const dialogType = ref("add");
const selectedKnowledge = ref(null);
const knowledgeFormRef = ref(null);
const knowledgeForm = reactive({
  title: "",
  categoryId: "",
  content: "",
  createdBy: "",
  createdDate: "",
  lastUpdated: "",
});

// 表单规则
const rules = {
  title: [{ required: true, message: "请输入标题", trigger: "blur" }],
  categoryId: [{ required: true, message: "请选择分类", trigger: "change" }],
  content: [{ required: true, message: "请输入内容", trigger: "blur" }],
  createdBy: [{ required: true, message: "请选择创建者", trigger: "change" }],
  createdDate: [
    { required: true, message: "请选择创建时间", trigger: "change" },
  ],
  lastUpdated: [
    { required: true, message: "请选择更新时间", trigger: "change" },
  ],
};

// 分类选项
const categoryOptions = ref([]);
// 分类映射
const categoryMap = ref({});
// 员工映射
const employeeMap = ref({});

// 员工选项
const employeeOptions = ref([]);

// 获取分类列表
const fetchCategories = async () => {
  try {
    const res = await categoryApi.getCategoriesPage({ pageSize: 1000 });
    if (res.data.code === 0) {
      // 将后端返回的扁平结构转换为树形结构
      const categories = res.data.data.list || [];
      const tree = [];
      const map = {};

      // 先建立映射关系
      categoryMap.value = {}; // 重置映射
      categories.forEach((item) => {
        map[item.categoryId] = {
          value: item.categoryId, // 不转换为字符串
          label: item.categoryName,
          children: [],
        };
        // 同时建立分类ID到名称的映射
        categoryMap.value[item.categoryId] = item.categoryName;
      });

      // 构建树形结构
      categories.forEach((item) => {
        const node = map[item.categoryId];
        if (item.parentId === null || item.parentId === 0) {
          tree.push(node);
        } else {
          const parent = map[item.parentId];
          if (parent) {
            parent.children.push(node);
          }
        }
      });

      categoryOptions.value = tree;
    } else {
      throw new Error(res.data.msg || "获取分类列表失败");
    }
  } catch (error) {
    console.error("获取分类列表错误:", error);
    ElMessage.error(error.message || "获取分类列表失败");
  }
};

// 获取员工列表
const fetchEmployees = async () => {
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
    } else {
      throw new Error(res.data.msg || "获取员工列表失败");
    }
  } catch (error) {
    console.error("获取员工列表错误:", error);
    ElMessage.error(error.message || "获取员工列表失败");
  }
};

// 获取分类名称
const getCategoryName = (categoryId) => {
  // 确保 categoryId 是数字类型
  const id = typeof categoryId === "string" ? parseInt(categoryId) : categoryId;
  return categoryMap.value[id] || "未知分类";
};

// 获取创建者名称
const getCreatorName = (employeeId) => {
  return employeeMap.value[employeeId] || "未知用户";
};

// 获取知识库列表
const fetchKnowledgeList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      title: searchForm.title,
      categoryId: searchForm.categoryId,
      createdDate: searchForm.createdDate,
    };

    const res = await knowledgeListApi.getKnowledgeListPage(params);
    if (res.data.code === 0) {
      // 处理数据，添加分类名称和创建者名称
      tableData.value = (res.data.data.list || []).map((item) => {
        console.log("处理项目:", item); // 添加日志
        return {
          ...item,
          categoryName: getCategoryName(item.categoryId),
          creatorName: getCreatorName(item.createdBy),
        };
      });
      total.value = res.data.data.total || 0;
    } else {
      throw new Error(res.data.msg || "获取知识库列表失败");
    }
  } catch (error) {
    console.error("获取知识库列表错误:", error);
    ElMessage.error(error.message || "获取知识库列表失败");
  } finally {
    loading.value = false;
  }
};

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1;
  fetchKnowledgeList();
};

const resetSearch = () => {
  Object.keys(searchForm).forEach((key) => {
    searchForm[key] = "";
  });
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  fetchKnowledgeList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  fetchKnowledgeList();
};

// 表单处理
const handleAdd = () => {
  dialogVisible.value = true;
  resetForm();
};

const handleView = async (row) => {
  try {
    const res = await knowledgeListApi.getKnowledgeListById(row.kbId);
    if (res.data.code === 0) {
      selectedKnowledge.value = res.data.data;
      viewDialogVisible.value = true;
    } else {
      throw new Error(res.data.msg || "获取知识库详情失败");
    }
  } catch (error) {
    console.error("获取知识库详情错误:", error);
    ElMessage.error(error.message || "获取知识库详情失败");
  }
};

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm("确认删除该知识库条目吗？", "提示", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    const res = await knowledgeListApi.deleteKnowledgeList(row.kbId);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      fetchKnowledgeList();
    } else {
      throw new Error(res.data.msg || "删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除知识库错误:", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

// 重置表单
const resetForm = () => {
  if (knowledgeFormRef.value) {
    knowledgeFormRef.value.resetFields();
  }
  Object.assign(knowledgeForm, {
    title: "",
    categoryId: "",
    content: "",
    createdBy: "",
    createdDate: "",
    lastUpdated: "",
  });
};

// 提交表单
const submitForm = async () => {
  if (!knowledgeFormRef.value) return;

  try {
    await knowledgeFormRef.value.validate();
    submitting.value = true;

    const formData = {
      ...knowledgeForm,
      createdBy: knowledgeForm.createdBy,
      categoryId: Array.isArray(knowledgeForm.categoryId)
        ? parseInt(
            knowledgeForm.categoryId[knowledgeForm.categoryId.length - 1]
          )
        : parseInt(knowledgeForm.categoryId),
      createdDate: knowledgeForm.createdDate,
      lastUpdated: knowledgeForm.lastUpdated,
    };

    const res = await knowledgeListApi.addKnowledgeList(formData);
    if (res.data.code === 0) {
      ElMessage.success("新增成功");
      dialogVisible.value = false;
      fetchKnowledgeList();
    } else {
      throw new Error(res.data.msg || "新增失败");
    }
  } catch (error) {
    console.error("提交表单错误:", error);
    ElMessage.error(error.message || "新增失败");
  } finally {
    submitting.value = false;
  }
};

// 日期格式化
const formatDate = (date) => {
  if (!date) return "";
  const d = new Date(date);
  if (isNaN(d.getTime())) return "";

  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  const hour = String(d.getHours()).padStart(2, "0");
  const minute = String(d.getMinutes()).padStart(2, "0");

  return `${year}-${month}-${day} ${hour}:${minute}`;
};

// 初始加载
onMounted(async () => {
  await fetchCategories(); // 获取分类数据
  await fetchEmployees(); // 获取员工数据
  fetchKnowledgeList();
});
</script>

<style scoped>
.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.knowledge-content {
  padding: 20px;
}

.metadata {
  margin-bottom: 20px;
}

.content {
  margin-top: 20px;
  white-space: pre-wrap;
  line-height: 1.6;
}
</style>
