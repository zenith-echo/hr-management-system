<template>
  <page-container title="职业路径管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>新增路径
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="路径名称">
          <el-input
            v-model="searchForm.keyword"
            placeholder="请输入路径名称"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item label="所属部门">
          <el-select
            v-model="searchForm.departmentId"
            placeholder="请选择部门"
            clearable
            filterable
            style="width: 200px"
          >
            <el-option
              v-for="item in departmentOptions"
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

    <!-- 表格内容 -->
    <el-table :data="tableData" border v-loading="loading" style="width: 100%">
      <el-table-column prop="pathName" label="路径名称" min-width="150" />
      <el-table-column prop="departmentName" label="所属部门" width="150" />
      <el-table-column
        prop="description"
        label="描述"
        min-width="200"
        show-overflow-tooltip
      />
      <el-table-column label="操作" width="120" fixed="right" align="center">
        <template #default="scope">
          <el-button-group>
            <el-tooltip content="编辑" placement="top">
              <el-button type="primary" link @click="handleEdit(scope.row)">
                <el-icon><Edit /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="删除" placement="top">
              <el-button type="danger" link @click="handleDelete(scope.row)">
                <el-icon><Delete /></el-icon>
              </el-button>
            </el-tooltip>
          </el-button-group>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <template #pagination>
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </template>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增职业路径' : '编辑职业路径'"
      width="500px"
      :close-on-click-modal="false"
      @closed="handleDialogClose"
    >
      <el-form
        ref="pathFormRef"
        :model="pathForm"
        :rules="rules"
        label-width="100px"
        :validate-on-rule-change="false"
      >
        <el-form-item label="路径名称" prop="pathName">
          <el-input
            v-model="pathForm.pathName"
            placeholder="请输入路径名称"
            maxlength="100"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="所属部门" prop="departmentId">
          <el-select
            v-model="pathForm.departmentId"
            placeholder="请选择部门"
            style="width: 100%"
            filterable
          >
            <el-option
              v-for="item in departmentOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="pathForm.description"
            type="textarea"
            :rows="4"
            placeholder="请输入路径描述"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm" :loading="submitting">
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
import { Plus, Edit, Delete, Search, Refresh } from "@element-plus/icons-vue";
import api from "@/api/careerPath";
import departmentApi from "@/api/department";
import PageContainer from "@/components/PageContainer.vue";

// 搜索表单
const searchForm = reactive({
  keyword: "",
  departmentId: undefined,
});

// 表格数据
const tableData = ref([]);
const loading = ref(false);
const submitting = ref(false);

// 分页
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const pathFormRef = ref(null);

// 表单数据
const initPathForm = () => ({
  pathId: null,
  pathName: "",
  departmentId: undefined,
  description: "",
});

const pathForm = reactive(initPathForm());

// 表单规则
const rules = {
  pathName: [
    { required: true, message: "请输入路径名称", trigger: "blur" },
    { max: 100, message: "路径名称不能超过100个字符", trigger: "blur" },
  ],
  departmentId: [
    { required: true, message: "请选择所属部门", trigger: "change" },
  ],
  description: [
    { required: true, message: "请输入路径描述", trigger: "blur" },
    { max: 500, message: "路径描述不能超过500个字符", trigger: "blur" },
  ],
};

// 部门选项
const departmentOptions = ref([]);
const loadDepartments = async () => {
  try {
    const res = await departmentApi.getDepartmentPage({
      pageNum: 1,
      pageSize: 1000, // 获取足够多的部门数据用于下拉选择
    });
    if (res.data.code === 0) {
      departmentOptions.value = (res.data.data.list || []).map((dept) => ({
        value: dept.departmentId,
        label: dept.departmentName,
      }));
    } else {
      throw new Error(res.data.msg || "获取部门数据失败");
    }
  } catch (error) {
    console.error("获取部门列表失败:", error);
    ElMessage.error(error.message || "获取部门数据失败");
    departmentOptions.value = [];
  }
};

// 获取部门名称
const getDepartmentName = (departmentId) => {
  if (!departmentId) return "未分配";
  const department = departmentOptions.value.find(
    (dept) => dept.value === departmentId
  );
  return department ? department.label : "未知部门";
};

// 获取列表数据
const getList = async () => {
  loading.value = true;
  try {
    // 确保部门数据已加载
    if (departmentOptions.value.length === 0) {
      await loadDepartments();
    }

    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      departmentId: searchForm.departmentId || undefined,
      keyword: searchForm.keyword || undefined,
    };

    const res = await api.getCareerPathPage(params);
    if (res.data.code === 0) {
      const pageInfo = res.data.data;
      // 添加部门名称到列表数据中
      tableData.value = pageInfo.list.map((item) => ({
        ...item,
        departmentName: getDepartmentName(item.departmentId),
      }));
      total.value = pageInfo.total;
    } else {
      ElMessage.error(res.data.msg || "获取数据失败");
    }
  } catch (error) {
    console.error("获取职业路径列表失败:", error);
    ElMessage.error(error.message || "获取数据失败");
  } finally {
    loading.value = false;
  }
};

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1;
  getList();
};

const resetSearch = () => {
  searchForm.keyword = "";
  searchForm.departmentId = undefined; // 改为undefined
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  getList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  getList();
};

// 重置表单
const resetForm = () => {
  Object.assign(pathForm, initPathForm());
  if (pathFormRef.value) {
    pathFormRef.value.resetFields();
  }
};

// 表单处理
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  resetForm();
};

const handleEdit = async (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;

  try {
    const res = await api.getCareerPathById(row.pathId);
    if (res.data.code === 0) {
      const pathData = res.data.data;
      // 使用Object.assign来更新reactive对象
      Object.assign(pathForm, {
        pathId: pathData.pathId,
        pathName: pathData.pathName,
        departmentId: pathData.departmentId,
        description: pathData.description,
      });

      // 在下一个tick重置表单验证
      nextTick(() => {
        if (pathFormRef.value) {
          pathFormRef.value.clearValidate();
        }
      });
    } else {
      ElMessage.error(res.data.msg || "获取路径详情失败");
    }
  } catch (error) {
    console.error("获取路径详情失败:", error);
    ElMessage.error(error.message || "获取路径详情失败");
    dialogVisible.value = false;
  }
};

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除职业路径 ${row.pathName} 吗？`,
      "警告",
      {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }
    );

    const res = await api.deleteCareerPath(row.pathId);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      getList();
    } else {
      throw new Error(res.data.msg || "删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除职业路径失败", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

// 表单提交前的验证
const validateForm = async () => {
  if (!pathFormRef.value) return false;

  try {
    await pathFormRef.value.validate();
    if (!pathForm.departmentId) {
      ElMessage.error("请选择所属部门");
      return false;
    }
    return true;
  } catch (error) {
    return false;
  }
};

const submitForm = async () => {
  const valid = await validateForm();
  if (!valid) return;

  const submitApi =
    dialogType.value === "add" ? api.addCareerPath : api.updateCareerPath;
  try {
    // 创建一个新对象来提交，避免引用问题
    const submitData = {
      pathId: pathForm.pathId,
      pathName: pathForm.pathName?.trim(),
      departmentId: pathForm.departmentId,
      description: pathForm.description?.trim(),
    };

    const res = await submitApi(submitData);
    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "add" ? "新增成功" : "修改成功");
      dialogVisible.value = false;
      resetForm(); // 重置表单
      getList(); // 刷新列表
    } else {
      ElMessage.error(
        res.data.msg || (dialogType.value === "add" ? "新增失败" : "修改失败")
      );
    }
  } catch (error) {
    console.error("提交职业路径失败:", error);
    ElMessage.error(error.message || "操作失败");
  }
};

// 监听对话框关闭
const handleDialogClose = () => {
  resetForm();
};

onMounted(async () => {
  await loadDepartments(); // 先加载部门数据
  await getList(); // 再加载列表数据
});
</script>

<style scoped>
:deep(.el-table) {
  --el-table-header-bg-color: #f5f7fa;
  --el-table-border-color: #ebeef5;
  --el-table-header-text-color: #606266;
}

:deep(.el-table th) {
  font-weight: 600;
  color: var(--el-table-header-text-color);
  background: var(--el-table-header-bg-color);
}

:deep(.el-table td) {
  padding: 8px 0;
}

:deep(.el-form-item__label) {
  font-weight: 500;
  color: #606266;
}

:deep(.el-input),
:deep(.el-select) {
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
