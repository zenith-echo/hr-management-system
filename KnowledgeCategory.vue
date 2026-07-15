<template>
  <div class="knowledge-category">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>知识库分类管理</span>
          <div class="header-actions">
            <el-input
              v-model="searchKeyword"
              placeholder="搜索分类名称或描述"
              class="search-input"
              clearable
              @keyup.enter="handleSearch"
            >
              <template #suffix>
                <el-icon class="search-icon" @click="handleSearch">
                  <Search />
                </el-icon>
              </template>
            </el-input>
            <el-button type="primary" @click="handleAdd">
              <el-icon><Plus /></el-icon>新增分类
            </el-button>
          </div>
        </div>
      </template>

      <div class="category-container">
        <!-- 分类树 -->
        <div class="category-tree">
          <el-tree
            ref="treeRef"
            :data="categoryData"
            :props="defaultProps"
            node-key="id"
            default-expand-all
            highlight-current
            :expand-on-click-node="false"
            @node-click="handleNodeClick"
          >
            <template #default="{ node, data }">
              <span class="custom-tree-node">
                <span class="node-label">
                  <el-icon><Folder /></el-icon>
                  {{ node.label }}
                </span>
                <span class="actions">
                  <el-button type="primary" link @click.stop="handleEdit(data)">
                    <el-icon><Edit /></el-icon>
                  </el-button>
                  <el-button
                    type="danger"
                    link
                    @click.stop="handleDelete(node, data)"
                  >
                    <el-icon><Delete /></el-icon>
                  </el-button>
                </span>
              </span>
            </template>
          </el-tree>
        </div>

        <!-- 分类详情 -->
        <div class="category-detail" v-if="selectedCategory">
          <h3>分类详情</h3>
          <el-descriptions :column="1" border>
            <el-descriptions-item label="分类名称">
              {{ selectedCategory.name }}
            </el-descriptions-item>
            <el-descriptions-item label="上级分类">
              {{ selectedCategory.parentName }}
            </el-descriptions-item>
            <el-descriptions-item label="描述">
              {{ selectedCategory.description }}
            </el-descriptions-item>
          </el-descriptions>
        </div>
      </div>
    </el-card>

    <!-- 新增/编辑分类对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增分类' : '编辑分类'"
      width="500px"
      :close-on-click-modal="false"
      @closed="resetForm"
    >
      <el-form
        ref="categoryFormRef"
        :model="categoryForm"
        :rules="rules"
        label-width="100px"
        :validate-on-rule-change="false"
      >
        <el-form-item label="分类名称" prop="name">
          <el-input
            v-model="categoryForm.name"
            placeholder="请输入分类名称"
            maxlength="100"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="上级分类" prop="parentId">
          <el-select
            v-model="categoryForm.parentId"
            placeholder="请选择上级分类"
            clearable
            style="width: 100%"
          >
            <el-option
              v-for="item in categoryOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
              :disabled="
                dialogType === 'edit' && item.value === categoryForm.categoryId
              "
            />
          </el-select>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="categoryForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入分类描述"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm" :loading="submitting"
            >确定</el-button
          >
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { Plus, Edit, Delete, Search, Folder } from "@element-plus/icons-vue";
import api from "../../api/knowledge";

// 搜索关键字
const searchKeyword = ref("");

// 分类树数据
const categoryData = ref([]);
const treeRef = ref(null);

// 加载状态
const loading = ref(false);
const submitting = ref(false);

// 树配置
const defaultProps = {
  children: "children",
  label: "categoryName",
};

// 选中的分类
const selectedCategory = ref(null);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const categoryFormRef = ref();
const categoryForm = reactive({
  categoryId: "",
  name: "",
  parentId: "",
  description: "",
});

// 表单规则
const rules = {
  name: [
    { required: true, message: "请输入分类名称", trigger: "blur" },
    { max: 100, message: "分类名称不能超过100个字符", trigger: "blur" },
  ],
  description: [
    { max: 500, message: "描述不能超过500个字符", trigger: "blur" },
  ],
};

// 分类选项
const categoryOptions = ref([]);

// 获取分类树数据
const fetchCategoryTree = async () => {
  loading.value = true;
  try {
    const params = {
      pageSize: 1000,
      keyword: searchKeyword.value,
    };
    const res = await api.getCategoriesPage(params);
    if (res.data.code === 0) {
      const list = res.data.data.list || [];
      categoryData.value = buildTree(list);
      categoryOptions.value = buildSelectOptions(list);
    } else {
      throw new Error(res.data.msg || "获取分类列表失败");
    }
  } catch (error) {
    console.error("获取分类列表错误:", error);
    ElMessage.error(error.message || "获取分类列表失败");
  } finally {
    loading.value = false;
  }
};

// 构建树形结构
const buildTree = (list) => {
  const map = {};
  const tree = [];

  // 创建节点映射
  list.forEach((item) => {
    map[item.categoryId] = {
      id: item.categoryId,
      categoryName: item.categoryName,
      description: item.description,
      parentId: item.parentId,
      children: [],
    };
  });

  // 构建树
  list.forEach((item) => {
    const node = map[item.categoryId];
    if (item.parentId && map[item.parentId]) {
      map[item.parentId].children.push(node);
    } else {
      tree.push(node);
    }
  });

  return tree;
};

// 构建选择器选项
const buildSelectOptions = (list) => {
  // 过滤掉当前正在编辑的分类及其子分类
  const currentId =
    dialogType.value === "edit" ? categoryForm.categoryId : null;
  const childrenIds = currentId ? getChildrenIds(list, currentId) : [];

  return list
    .filter(
      (item) =>
        !currentId ||
        (item.categoryId !== currentId &&
          !childrenIds.includes(item.categoryId))
    )
    .map((item) => ({
      value: item.categoryId,
      label: item.categoryName,
    }));
};

// 获取所有子分类ID
const getChildrenIds = (list, parentId) => {
  const ids = [];
  const findChildren = (pid) => {
    list.forEach((item) => {
      if (item.parentId === pid) {
        ids.push(item.categoryId);
        findChildren(item.categoryId);
      }
    });
  };
  findChildren(parentId);
  return ids;
};

// 搜索处理
const handleSearch = async () => {
  // 清空选中状态
  selectedCategory.value = null;
  if (treeRef.value) {
    treeRef.value.setCurrentKey(null);
  }
  // 刷新树形结构数据
  await fetchCategoryTree();
};

// 监听搜索关键字变化
watch(searchKeyword, () => {
  handleSearch();
});

// 节点点击
const handleNodeClick = async (data) => {
  try {
    const res = await api.getCategoryById(data.id);
    if (res.data.code === 0) {
      const category = res.data.data;
      selectedCategory.value = {
        name: category.categoryName,
        parentName: getParentName(category.parentId),
        description: category.description || "暂无描述",
      };
    }
  } catch (error) {
    console.error("获取分类详情错误:", error);
    ElMessage.error(error.message || "获取分类详情失败");
  }
};

// 获取父分类名称
const getParentName = (parentId) => {
  if (!parentId) return "无";
  const parent = categoryOptions.value.find((item) => item.value === parentId);
  return parent ? parent.label : "无";
};

// 表单处理
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  resetForm();
};

const handleEdit = async (data) => {
  try {
    const res = await api.getCategoryById(data.id);
    if (res.data.code === 0) {
      const category = res.data.data;
      dialogType.value = "edit";
      dialogVisible.value = true;
      Object.assign(categoryForm, {
        categoryId: category.categoryId,
        name: category.categoryName,
        parentId: category.parentId,
        description: category.description,
      });
      // 重新构建选择器选项，排除当前分类及其子分类
      const res2 = await api.getCategoriesPage({ pageSize: 1000 });
      if (res2.data.code === 0) {
        const list = res2.data.data.list || [];
        categoryOptions.value = buildSelectOptions(list);
      }
    }
  } catch (error) {
    console.error("获取分类详情错误:", error);
    ElMessage.error(error.message || "获取分类详情失败");
  }
};

const handleDelete = async (node, data) => {
  try {
    await ElMessageBox.confirm("确认删除该分类吗？删除后将无法恢复！", "提示", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    const res = await api.deleteCategory(data.id);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      // 刷新树形结构数据
      await fetchCategoryTree();
      // 清空选中状态
      selectedCategory.value = null;
      if (treeRef.value) {
        treeRef.value.setCurrentKey(null);
      }
    } else {
      throw new Error(res.data.msg || "删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除分类错误:", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

// 重置表单
const resetForm = () => {
  if (categoryFormRef.value) {
    categoryFormRef.value.resetFields();
  }
  Object.assign(categoryForm, {
    categoryId: "",
    name: "",
    parentId: "",
    description: "",
  });
};

const submitForm = async () => {
  if (!categoryFormRef.value) return;

  try {
    await categoryFormRef.value.validate();
    submitting.value = true;

    const submitData = {
      name: categoryForm.name.trim(),
      parentId: categoryForm.parentId || null,
      description: categoryForm.description?.trim(),
    };

    if (dialogType.value === "edit") {
      submitData.categoryId = categoryForm.categoryId;
    }

    const res = await (dialogType.value === "add"
      ? api.addCategory(submitData)
      : api.updateCategory(submitData));

    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "add" ? "新增成功" : "修改成功");
      dialogVisible.value = false;
      // 刷新树形结构数据
      await fetchCategoryTree();
      // 如果是编辑操作，重新获取当前选中节点的详情
      if (dialogType.value === "edit" && selectedCategory.value) {
        const currentNode = treeRef.value.getCurrentNode();
        if (currentNode) {
          await handleNodeClick(currentNode);
        }
      } else {
        // 如果是新增操作，清空选中状态
        selectedCategory.value = null;
        if (treeRef.value) {
          treeRef.value.setCurrentKey(null);
        }
      }
    } else {
      throw new Error(
        res.data.msg || (dialogType.value === "add" ? "新增失败" : "修改失败")
      );
    }
  } catch (error) {
    console.error("提交表单错误:", error);
    ElMessage.error(
      error.message || (dialogType.value === "add" ? "新增失败" : "修改失败")
    );
  } finally {
    submitting.value = false;
  }
};

// 初始加载
onMounted(() => {
  fetchCategoryTree();
});
</script>

<style scoped>
.knowledge-category {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions {
  display: flex;
  gap: 16px;
  align-items: center;
}

.search-input {
  width: 250px;
}

.search-icon {
  cursor: pointer;
}

.category-container {
  display: flex;
  gap: 20px;
  margin-top: 20px;
}

.category-tree {
  flex: 1;
  max-width: 400px;
  border-right: 1px solid var(--el-border-color-light);
  padding-right: 20px;
}

.category-detail {
  flex: 2;
  padding-left: 20px;
}

.custom-tree-node {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
  padding-right: 8px;
}

.node-label {
  display: flex;
  align-items: center;
  gap: 4px;
}

.actions {
  opacity: 0;
  transition: opacity 0.2s;
}

.custom-tree-node:hover .actions {
  opacity: 1;
}

.actions .el-button {
  padding: 2px 4px;
}

:deep(.el-tree-node__content) {
  height: 32px;
}

:deep(.el-button) {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

:deep(.el-descriptions__cell) {
  padding: 12px 16px;
}
</style>
