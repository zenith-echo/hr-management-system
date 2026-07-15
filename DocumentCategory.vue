<template>
  <div class="document-category">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>文档分类管理</span>
          <el-button type="primary" @click="handleAdd">新增分类</el-button>
        </div>
      </template>

      <div class="category-container">
        <!-- 分类树 -->
        <div class="category-tree">
          <el-tree
            ref="treeRef"
            v-loading="loading"
            :data="categoryData"
            :props="defaultProps"
            node-key="categoryId"
            default-expand-all
            highlight-current
            :expand-on-click-node="false"
            @node-click="handleNodeClick"
          >
            <template #default="{ node, data }">
              <span class="custom-tree-node">
                <span>
                  <el-icon v-if="data.children && data.children.length > 0"
                    ><Folder
                  /></el-icon>
                  <el-icon v-else><Document /></el-icon>
                  {{ node.label }}
                </span>
                <span class="actions">
                  <el-button type="primary" link @click.stop="handleAdd(data)">
                    <el-icon><Plus /></el-icon>
                  </el-button>
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
    >
      <el-form
        ref="categoryForm"
        :model="categoryForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="分类名称" prop="categoryName">
          <el-input
            v-model="categoryForm.categoryName"
            placeholder="请输入分类名称"
          />
        </el-form-item>
        <el-form-item label="上级分类">
          <el-cascader
            v-model="categoryForm.parentId"
            :options="categoryOptions"
            :props="{
              checkStrictly: true,
              value: 'value',
              label: 'label',
              emitPath: false,
            }"
            placeholder="请选择上级分类"
            clearable
          />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="categoryForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入分类描述"
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
import { Plus, Edit, Delete, Document, Folder } from "@element-plus/icons-vue";
import documentCategoryApi from "@/api/documentCategory";

// 分类树数据
const categoryData = ref([]);
const loading = ref(false);

// 树配置
const defaultProps = {
  children: "children",
  label: "categoryName", // 使用后端返回的categoryName字段
  value: "categoryId", // 使用后端的categoryId作为值
};

// 选中的分类
const selectedCategory = ref(null);
const treeRef = ref(null);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const categoryForm = reactive({
  categoryId: null,
  categoryName: "",
  parentId: null,
  description: "",
});

// 表单规则
const rules = {
  categoryName: [
    { required: true, message: "请输入分类名称", trigger: "blur" },
    { min: 2, max: 50, message: "长度在2到50个字符之间", trigger: "blur" },
  ],
  description: [
    { max: 200, message: "描述不能超过200个字符", trigger: "blur" },
  ],
};

// 分类选项（用于级联选择器）
const categoryOptions = ref([]);

// 获取分类列表
const getCategories = async () => {
  try {
    loading.value = true;
    const res = await documentCategoryApi.getCategoryPage({
      pageNum: 1,
      pageSize: 1000, // 获取所有分类
    });
    if (res.data.code === 0) {
      const list = res.data.data.list || [];
      console.log("获取到的分类列表:", list);

      // 将扁平数据转换为树形结构
      categoryData.value = buildTree(list);
      // 构建级联选择器选项
      const options = buildCascaderOptions(list);
      console.log("级联选择器选项:", options);
      categoryOptions.value = options;
    }
  } catch (error) {
    console.error("获取分类列表失败:", error);
    ElMessage.error("获取分类列表失败");
  } finally {
    loading.value = false;
  }
};

// 构建树形结构
const buildTree = (list) => {
  console.log("原始数据列表:", list);

  const map = {};
  const tree = [];

  // 首先创建一个以id为键的映射
  list.forEach((item) => {
    map[item.categoryId] = {
      ...item,
      children: [],
    };
  });

  console.log("映射对象:", map);

  // 构建树形结构
  list.forEach((item) => {
    const node = map[item.categoryId];
    if (item.parentId && map[item.parentId]) {
      // 如果有父节点，将当前节点添加到父节点的children中
      map[item.parentId].children.push(node);
    } else {
      // 如果没有父节点或父节点不存在，作为根节点
      tree.push(node);
    }
  });

  console.log("构建的树形结构:", tree);
  return tree;
};

// 构建级联选择器的选项
const buildCascaderOptions = (list) => {
  // 先构建树形结构
  const tree = buildTree(list);

  // 递归构建级联选择器选项
  const buildOptions = (nodes) => {
    return nodes.map((node) => ({
      value: node.categoryId,
      label: node.categoryName,
      children:
        node.children && node.children.length > 0
          ? buildOptions(node.children)
          : undefined,
    }));
  };

  return buildOptions(tree);
};

// 节点点击
const handleNodeClick = (data) => {
  selectedCategory.value = {
    name: data.categoryName,
    parentName: getParentName(data),
    description: data.description || "暂无描述",
    createTime: data.createTime,
    updateTime: data.updateTime,
  };
};

// 获取父分类名称
const getParentName = (data) => {
  if (!data.parentId) return "无";
  const parent = findNodeById(categoryData.value, data.parentId);
  return parent ? parent.categoryName : "未知";
};

// 根据ID查找节点
const findNodeById = (nodes, id) => {
  for (const node of nodes) {
    if (node.categoryId === id) return node;
    if (node.children) {
      const found = findNodeById(node.children, id);
      if (found) return found;
    }
  }
  return null;
};

// 表单处理
const handleAdd = (parentNode = null) => {
  dialogType.value = "add";
  dialogVisible.value = true;
  Object.assign(categoryForm, {
    categoryId: null,
    categoryName: "",
    parentId: parentNode ? parentNode.categoryId : null,
    description: "",
  });
};

const handleEdit = (data) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  Object.assign(categoryForm, {
    categoryId: data.categoryId,
    categoryName: data.categoryName,
    parentId: data.parentId,
    description: data.description,
  });
};

const handleDelete = async (node, data) => {
  try {
    await ElMessageBox.confirm("确认删除该分类吗？删除后将无法恢复！", "提示", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    const res = await documentCategoryApi.deleteCategory(data.categoryId);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      getCategories();
      selectedCategory.value = null;
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除失败:", error);
      ElMessage.error("删除失败");
    }
  }
};

const submitForm = async () => {
  if (!categoryForm.value) return;

  try {
    await categoryForm.value.validate();
    const api =
      dialogType.value === "add"
        ? documentCategoryApi.addCategory
        : documentCategoryApi.updateCategory;

    const res = await api(categoryForm);
    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "add" ? "添加成功" : "修改成功");
      dialogVisible.value = false;
      getCategories();
    }
  } catch (error) {
    console.error("提交失败:", error);
    ElMessage.error(error.message || "提交失败");
  }
};

// 初始化
onMounted(() => {
  getCategories();
});
</script>

<style scoped>
.document-category {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.category-container {
  display: flex;
  gap: 20px;
  min-height: 400px;
}

.category-tree {
  flex: 1;
  max-width: 400px;
  border-right: 1px solid #ebeef5;
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

.custom-tree-node > span:first-child {
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
  margin-left: 8px;
}

.el-tree {
  background: transparent;
}

:deep(.el-tree-node__content) {
  height: 32px;
}

:deep(.el-tree-node__content:hover) {
  background-color: var(--el-tree-node-hover-bg-color);
}
</style>
