<template>
  <page-container title="部门管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>添加部门
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="部门名称">
          <el-input
            v-model="searchForm.keyword"
            placeholder="请输入部门名称"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item label="部门负责人">
          <el-select
            v-model="searchForm.managerId"
            placeholder="请选择部门负责人"
            clearable
            filterable
          >
            <el-option
              v-for="item in managerOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
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
    </template>

    <!-- 树形结构 -->
    <div class="department-tree-container">
      <el-tree
        v-loading="loading"
        :data="departmentTreeData"
        :props="{ label: 'departmentName', children: 'children' }"
        node-key="departmentId"
        default-expand-all
        :expand-on-click-node="false"
        highlight-current
      >
        <template #default="{ node, data }">
          <div class="custom-tree-node">
            <div class="node-content">
              <span class="department-name">{{ data.departmentName }}</span>
              <div class="department-info">
                <el-tag
                  size="small"
                  effect="plain"
                  type="info"
                  v-if="data.parentId"
                >
                  上级部门: {{ getDepartmentName(data.parentId) }}
                </el-tag>
                <el-tag size="small" effect="plain" v-if="data.managerId">
                  负责人: {{ formatManagerInfo(data.managerId) }}
                </el-tag>
                <span v-else class="no-manager">未指定负责人</span>
              </div>
            </div>
            <div class="node-actions">
              <el-button type="primary" link @click="handleEdit(data)">
                <el-icon><Edit /></el-icon>编辑
              </el-button>
              <el-button type="primary" link @click="handleAddChild(data)">
                <el-icon><Plus /></el-icon>添加子部门
              </el-button>
              <el-popconfirm
                title="确定要删除此部门吗？"
                @confirm="handleDelete(data)"
              >
                <template #reference>
                  <el-button type="danger" link>
                    <el-icon><Delete /></el-icon>删除
                  </el-button>
                </template>
              </el-popconfirm>
            </div>
          </div>
        </template>
      </el-tree>
    </div>

    <!-- 部门表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="500px"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <el-form
        ref="departmentFormRef"
        :model="departmentForm"
        :rules="departmentRules"
        label-width="100px"
      >
        <el-form-item label="部门名称" prop="departmentName">
          <el-input
            v-model="departmentForm.departmentName"
            placeholder="请输入部门名称"
            maxlength="50"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="上级部门" prop="parentId" v-if="!isEditRoot">
          <el-tree-select
            v-model="departmentForm.parentId"
            :data="departmentTreeData"
            check-strictly
            node-key="departmentId"
            :render-after-expand="false"
            :props="{ label: 'departmentName', children: 'children' }"
            placeholder="请选择上级部门"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="部门负责人" prop="managerId">
          <el-select
            v-model="departmentForm.managerId"
            placeholder="请选择部门负责人"
            style="width: 100%"
            filterable
          >
            <el-option
              v-for="item in managerOptions"
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
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from "vue";
import { Plus, Edit, Delete, Search, Refresh } from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";
import api from "../../api/department";
import employeeApi from "../../api/employee";
import PageContainer from "../../components/PageContainer.vue";

// 表格数据
const loading = ref(false);
const departmentTreeData = ref([]);

// 搜索表单
const searchForm = reactive({
  keyword: "",
  managerId: null,
});

// 部门表单
const dialogVisible = ref(false);
const dialogType = ref("add"); // add, edit, addChild
const departmentFormRef = ref(null);
const departmentForm = reactive({
  departmentId: null,
  departmentName: "",
  parentId: null,
  managerId: null,
});

// 表单验证规则
const departmentRules = {
  departmentName: [
    { required: true, message: "请输入部门名称", trigger: "blur" },
    { max: 50, message: "部门名称不能超过50个字符", trigger: "blur" },
  ],
  parentId: [{ required: false, message: "请选择上级部门", trigger: "change" }],
  managerId: [
    { required: true, message: "请选择部门负责人", trigger: "change" },
  ],
};

// 负责人选项
const managerOptions = ref([]);

// 对话框标题
const dialogTitle = computed(() => {
  if (dialogType.value === "add") {
    return "添加部门";
  } else if (dialogType.value === "edit") {
    return "编辑部门";
  } else {
    return "添加子部门";
  }
});

// 是否编辑根部门
const isEditRoot = computed(() => {
  return dialogType.value === "edit" && !departmentForm.parentId;
});

// 获取部门列表
const getDepartmentList = async () => {
  loading.value = true;
  try {
    const params = {
      keyword: searchForm.keyword || undefined,
      managerId: searchForm.managerId || undefined,
    };

    const res = await api.getDepartmentPage({ ...params, pageSize: 1000 });
    if (res.data.code === 0) {
      const departments = res.data.data.list || [];
      departmentTreeData.value = buildDepartmentTree(departments);
    } else {
      throw new Error(res.data.msg || "获取部门列表失败");
    }
  } catch (error) {
    console.error("获取部门列表错误:", error);
    ElMessage.error(error.message || "获取部门列表失败");
    departmentTreeData.value = [];
  } finally {
    loading.value = false;
  }
};

// 构建部门树
const buildDepartmentTree = (departments) => {
  const departmentMap = new Map();
  const result = [];

  // 先创建所有部门节点
  departments.forEach((dept) => {
    departmentMap.set(dept.departmentId, {
      ...dept,
      children: [],
    });
  });

  // 构建树形结构
  departments.forEach((dept) => {
    const node = departmentMap.get(dept.departmentId);
    if (dept.parentId === null) {
      result.push(node);
    } else {
      const parent = departmentMap.get(dept.parentId);
      if (parent) {
        parent.children.push(node);
      } else {
        result.push(node);
      }
    }
  });

  return result;
};

// 获取部门名称
const getDepartmentName = (departmentId) => {
  const findDepartment = (departments, id) => {
    for (const dept of departments) {
      if (dept.departmentId === id) {
        return dept.departmentName;
      }
      if (dept.children && dept.children.length > 0) {
        const found = findDepartment(dept.children, id);
        if (found) return found;
      }
    }
    return null;
  };

  if (!departmentId) return "无";
  const name = findDepartment(departmentTreeData.value, departmentId);
  return name || "未知部门";
};

// 获取员工列表（用于选择部门负责人）
const getManagerList = async () => {
  try {
    const res = await employeeApi.getEmployeesPage({
      pageSize: 1000,
      status: "在职", // 只获取在职员工
    });
    if (res.data.code === 0) {
      const employees = res.data.data.list || [];
      managerOptions.value = employees.map((emp) => ({
        value: emp.employeeId,
        label: emp.name,
      }));
    } else {
      throw new Error(res.data.msg || "获取员工列表失败");
    }
  } catch (error) {
    console.error("获取员工列表失败", error);
    ElMessage.error("获取员工列表失败");
    managerOptions.value = [];
  }
};

// 搜索处理
const handleSearch = () => {
  getDepartmentList();
};

const resetSearch = () => {
  searchForm.keyword = "";
  searchForm.managerId = null;
  getDepartmentList();
};

// 新增部门
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  resetForm();
};

// 编辑部门
const handleEdit = async (row) => {
  try {
    const res = await api.getDepartmentById(row.departmentId);
    if (res.data.code === 0) {
      dialogType.value = "edit";
      dialogVisible.value = true;
      Object.assign(departmentForm, res.data.data);
    } else {
      throw new Error(res.data.msg || "获取部门详情失败");
    }
  } catch (error) {
    console.error("获取部门详情错误:", error);
    ElMessage.error(error.message || "获取部门详情失败");
  }
};

// 添加子部门
const handleAddChild = (row) => {
  dialogType.value = "addChild";
  dialogVisible.value = true;
  resetForm();
  departmentForm.parentId = row.departmentId;
};

// 删除部门
const handleDelete = async (row) => {
  try {
    const res = await api.deleteDepartment(row.departmentId);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      getDepartmentList();
    } else {
      throw new Error(res.data.msg || "删除失败");
    }
  } catch (error) {
    console.error("删除部门错误:", error);
    ElMessage.error(error.message || "删除失败");
  }
};

// 提交表单
const submitForm = async () => {
  if (!departmentFormRef.value) return;

  try {
    await departmentFormRef.value.validate();

    const submitData = {
      ...departmentForm,
      departmentName: departmentForm.departmentName.trim(),
    };

    const res = await (dialogType.value === "edit"
      ? api.updateDepartment(submitData)
      : api.addDepartment(submitData));

    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "edit" ? "更新成功" : "添加成功");
      dialogVisible.value = false;
      getDepartmentList();
    } else {
      throw new Error(
        res.data.msg || (dialogType.value === "edit" ? "更新失败" : "添加失败")
      );
    }
  } catch (error) {
    console.error("提交表单错误:", error);
    ElMessage.error(
      error.message || (dialogType.value === "edit" ? "更新失败" : "添加失败")
    );
  }
};

// 重置表单
const resetForm = () => {
  if (departmentFormRef.value) {
    departmentFormRef.value.resetFields();
  }
  Object.assign(departmentForm, {
    departmentId: null,
    departmentName: "",
    parentId: null,
    managerId: null,
  });
};

// 初始加载
onMounted(async () => {
  await getDepartmentList();
  await getManagerList();
});

// 表格显示处理
const formatManagerInfo = (managerId) => {
  const manager = managerOptions.value.find((m) => m.value === managerId);
  return manager ? manager.label : "未指定";
};
</script>

<style scoped>
.department-tree-container {
  padding: 20px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.custom-tree-node {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-right: 8px;
  width: 100%;
}

.node-content {
  display: flex;
  align-items: center;
  gap: 16px;
}

.department-name {
  font-weight: 500;
  color: #303133;
  min-width: 120px;
}

.department-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.node-actions {
  display: flex;
  align-items: center;
  gap: 8px;
  opacity: 0;
  transition: opacity 0.2s;
}

.custom-tree-node:hover .node-actions {
  opacity: 1;
}

:deep(.el-tree-node__content) {
  height: auto;
  padding: 8px 0;
}

:deep(.el-tree-node__content:hover) {
  background-color: #f5f7fa;
}

:deep(.el-tag) {
  font-weight: normal;
}

.no-manager {
  color: #909399;
  font-size: 13px;
}

:deep(.el-form-item__label) {
  font-weight: 500;
  color: #606266;
}

:deep(.el-input),
:deep(.el-select),
:deep(.el-tree-select) {
  width: 220px;
}

:deep(.el-dialog__body) {
  padding: 20px 30px;
}

:deep(.el-form--inline .el-form-item) {
  margin-right: 20px;
}

:deep(.el-button) {
  font-weight: normal;
}

:deep(.el-button.is-link) {
  padding: 4px 8px;
}

:deep(.el-dialog__header) {
  margin-right: 0;
  border-bottom: 1px solid var(--el-border-color-lighter);
  padding: 20px;
}

:deep(.el-dialog__footer) {
  border-top: 1px solid var(--el-border-color-lighter);
  padding: 20px;
}
</style>
