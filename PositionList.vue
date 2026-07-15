<template>
  <page-container title="职位管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>添加职位
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="职位名称">
          <el-input
            v-model="searchForm.positionName"
            placeholder="请输入职位名称"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item label="部门">
          <el-select
            v-model="searchForm.departmentId"
            placeholder="请选择部门"
            clearable
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
    <el-table
      v-loading="loading"
      :data="tableData"
      style="width: 100%"
      border
      stripe
    >
      <el-table-column type="index" label="序号" width="60" align="center" />
      <el-table-column prop="positionName" label="职位名称" min-width="150" />
      <el-table-column label="所属部门" width="150">
        <template #default="scope">
          <el-tag size="small" effect="plain">
            {{ getDepartmentName(scope.row.departmentId) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="positionLevel"
        label="职级"
        width="100"
        align="center"
      >
        <template #default="scope">
          <el-tag
            :type="getLevelType(scope.row.positionLevel)"
            effect="light"
            round
            size="small"
          >
            {{ scope.row.positionLevel }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="baseSalary"
        label="基本工资"
        width="120"
        align="right"
      >
        <template #default="scope">
          <span :class="{ salary: true }">
            {{
              scope.row.baseSalary
                ? `￥${formatSalary(scope.row.baseSalary)}`
                : "-"
            }}
          </span>
        </template>
      </el-table-column>
      <el-table-column
        prop="responsibilities"
        label="职责描述"
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

    <!-- 职位表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '添加职位' : '编辑职位'"
      width="600px"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <el-form
        ref="positionFormRef"
        :model="positionForm"
        :rules="positionRules"
        label-width="100px"
      >
        <el-form-item label="职位名称" prop="positionName">
          <el-input
            v-model="positionForm.positionName"
            placeholder="请输入职位名称"
            maxlength="50"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="所属部门" prop="departmentId">
          <el-select
            v-model="positionForm.departmentId"
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
        <el-form-item label="职级" prop="positionLevel">
          <el-select
            v-model="positionForm.positionLevel"
            placeholder="请选择职级"
            style="width: 100%"
          >
            <el-option
              v-for="level in positionLevels"
              :key="level.value"
              :label="level.label"
              :value="level.value"
            >
              <el-tag
                :type="getLevelType(level.value)"
                effect="light"
                round
                size="small"
                style="margin-right: 8px"
              >
                {{ level.label }}
              </el-tag>
              <span>{{ level.description }}</span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="基本工资" prop="baseSalary">
          <el-input-number
            v-model="positionForm.baseSalary"
            :min="0"
            :max="1000000"
            :precision="2"
            :step="1000"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="职责描述" prop="responsibilities">
          <el-input
            v-model="positionForm.responsibilities"
            type="textarea"
            :rows="4"
            placeholder="请输入职责描述"
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
import { ref, reactive, onMounted } from "vue";
import { Plus, Edit, Delete, Search, Refresh } from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";
import positionApi from "../../api/position";
import departmentApi from "../../api/department";
import PageContainer from "@/components/PageContainer.vue";

// 表格数据
const loading = ref(false);
const tableData = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 搜索表单
const searchForm = reactive({
  positionName: "",
  departmentId: "",
});

// 职位表单
const dialogVisible = ref(false);
const dialogType = ref("add"); // add, edit
const positionFormRef = ref(null);
const positionForm = reactive({
  positionId: "",
  positionName: "",
  departmentId: "",
  positionLevel: "",
  baseSalary: 0,
  responsibilities: "",
});

// 表单验证规则
const positionRules = {
  positionName: [
    { required: true, message: "请输入职位名称", trigger: "blur" },
    { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
  ],
  departmentId: [
    { required: true, message: "请选择所属部门", trigger: "change" },
  ],
  positionLevel: [{ required: true, message: "请选择职级", trigger: "change" }],
  baseSalary: [{ required: true, message: "请输入基本工资", trigger: "blur" }],
  responsibilities: [
    { required: true, message: "请输入职责描述", trigger: "blur" },
  ],
};

// 部门选项
const departmentOptions = ref([]);

// 职级配置
const positionLevels = [
  { value: "P1", label: "P1", description: "初级职位" },
  { value: "P2", label: "P2", description: "中级职位" },
  { value: "P3", label: "P3", description: "高级职位" },
  { value: "P4", label: "P4", description: "资深职位" },
  { value: "P5", label: "P5", description: "专家职位" },
  { value: "P6", label: "P6", description: "高级专家" },
  { value: "P7", label: "P7", description: "首席专家" },
];

// 获取职位列表
const getPositionList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      positionName: searchForm.positionName,
      departmentId: searchForm.departmentId,
    };

    const res = await positionApi.getPositionsPage(params);
    if (res.data.code === 0) {
      tableData.value = res.data.data.list || [];
      total.value = res.data.data.total || 0;
    } else {
      throw new Error(res.data.msg || "获取职位列表失败");
    }
  } catch (error) {
    console.error("获取职位列表失败", error);
    ElMessage.error(error.message || "获取职位列表失败");
    tableData.value = [];
    total.value = 0;
  } finally {
    loading.value = false;
  }
};

// 获取部门列表
const getDepartmentList = async () => {
  try {
    const res = await departmentApi.getDepartmentPage({ pageSize: 1000 });
    if (res.data.code === 0) {
      const departments = res.data.data.list || [];
      departmentOptions.value = departments.map((dept) => ({
        value: dept.departmentId,
        label: dept.departmentName,
      }));
    } else {
      throw new Error(res.data.msg || "获取部门列表失败");
    }
  } catch (error) {
    console.error("获取部门列表失败", error);
    ElMessage.error("获取部门列表失败");
    departmentOptions.value = [];
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getPositionList();
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
  getPositionList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getPositionList();
};

// 处理添加职位
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(positionForm).forEach((key) => {
    if (key === "baseSalary") {
      positionForm[key] = 0;
    } else {
      positionForm[key] = "";
    }
  });

  // 下一个事件循环重置表单验证
  setTimeout(() => {
    positionFormRef.value?.resetFields();
  });
};

// 处理编辑职位
const handleEdit = async (row) => {
  try {
    const res = await positionApi.getPositionById(row.positionId);
    if (res.data.code === 0) {
      const position = res.data.data;
      dialogType.value = "edit";
      dialogVisible.value = true;
      Object.assign(positionForm, position);
    } else {
      throw new Error(res.data.msg || "获取职位详情失败");
    }
  } catch (error) {
    console.error("获取职位详情失败", error);
    ElMessage.error(error.message || "获取职位详情失败");
  }
};

// 处理删除职位
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除职位 ${row.positionName} 吗？`,
      "警告",
      {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }
    );

    const res = await positionApi.deletePosition(row.positionId);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      getPositionList();
    } else {
      throw new Error(res.data.msg || "删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除职位失败", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

// 提交表单
const submitForm = async () => {
  if (!positionFormRef.value) return;

  try {
    await positionFormRef.value.validate();

    const api =
      dialogType.value === "add"
        ? positionApi.addPosition
        : positionApi.updatePosition;

    const res = await api(positionForm);
    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "add" ? "添加成功" : "更新成功");
      dialogVisible.value = false;
      getPositionList();
    } else {
      throw new Error(
        res.data.msg || (dialogType.value === "add" ? "添加失败" : "更新失败")
      );
    }
  } catch (error) {
    console.error("提交表单失败", error);
    ElMessage.error(
      error.message || (dialogType.value === "add" ? "添加失败" : "更新失败")
    );
  }
};

// 添加获取部门名称的方法
const getDepartmentName = (departmentId) => {
  const department = departmentOptions.value.find(
    (dept) => dept.value === departmentId
  );
  return department ? department.label : "未知部门";
};

// 获取职级标签类型
const getLevelType = (level) => {
  const levelMap = {
    P1: "info",
    P2: "success",
    P3: "warning",
    P4: "danger",
    P5: "primary",
    P6: "warning",
    P7: "danger",
  };
  return levelMap[level] || "info";
};

// 格式化工资
const formatSalary = (salary) => {
  return new Intl.NumberFormat("zh-CN", {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(salary);
};

// 页面加载时获取数据
onMounted(() => {
  getPositionList();
  getDepartmentList();
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
:deep(.el-select),
:deep(.el-date-picker) {
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

.salary {
  font-family: Monaco, Menlo, Consolas, "Courier New", monospace;
  color: #67c23a;
  font-weight: bold;
}

:deep(.el-button-group) {
  display: inline-flex;
  gap: 4px;
}

:deep(.el-select-dropdown__item) {
  display: flex;
  align-items: center;
  gap: 8px;
}
</style>
