<template>
  <div class="benefits-assignment">
    <div class="page-header">
      <h2>福利分配管理</h2>
      <el-button type="primary" @click="handleAdd">分配福利</el-button>
    </div>

    <!-- 搜索表单 -->
    <el-form :inline="true" :model="searchForm" class="search-form">
      <el-form-item label="员工">
        <el-input
          v-model="searchForm.employeeId"
          placeholder="请输入员工ID"
          clearable
        />
      </el-form-item>
      <el-form-item label="福利计划">
        <el-input
          v-model="searchForm.benefitsplanId"
          placeholder="请输入福利计划ID"
          clearable
        />
      </el-form-item>
      <el-form-item label="保障金额">
        <el-input-number
          v-model="searchForm.coverageAmountMin"
          placeholder="最小金额"
          :min="0"
          :precision="2"
        />
        <span class="mx-2">-</span>
        <el-input-number
          v-model="searchForm.coverageAmountMax"
          placeholder="最大金额"
          :min="0"
          :precision="2"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="resetSearch">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 福利分配列表 -->
    <el-table
      :data="assignmentList"
      border
      style="width: 100%"
      v-loading="loading"
    >
      <el-table-column prop="employeeId" label="员工">
        <template #default="{ row }">
          {{ employeeNames.get(row.employeeId) || row.employeeId }}
          <el-tag size="small" type="info">ID: {{ row.employeeId }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="benefitsplanId" label="福利计划">
        <template #default="{ row }">
          {{ benefitsPlans.get(row.benefitsplanId) || row.benefitsplanId }}
          <el-tag size="small" type="info">ID: {{ row.benefitsplanId }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="enrollmentDate" label="参保日期" width="120" />
      <el-table-column prop="coverageAmount" label="保障金额">
        <template #default="{ row }">
          {{ formatAmount(row.coverageAmount) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="handleEdit(row)"
            >编辑</el-button
          >
          <el-button type="danger" link @click="handleDelete(row)"
            >删除</el-button
          >
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 福利分配表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '分配福利' : '编辑福利分配'"
      width="500px"
    >
      <el-form
        ref="assignmentFormRef"
        :model="assignmentForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="员工ID" prop="employeeId">
          <el-input
            v-model="assignmentForm.employeeId"
            placeholder="请输入员工ID"
          />
          <span
            v-if="employeeNames.get(assignmentForm.employeeId)"
            class="form-item-hint"
          >
            员工姓名: {{ employeeNames.get(assignmentForm.employeeId) }}
          </span>
        </el-form-item>
        <el-form-item label="福利计划ID" prop="benefitsplanId">
          <el-input
            v-model="assignmentForm.benefitsplanId"
            placeholder="请输入福利计划ID"
          />
          <span
            v-if="benefitsPlans.get(assignmentForm.benefitsplanId)"
            class="form-item-hint"
          >
            计划名称: {{ benefitsPlans.get(assignmentForm.benefitsplanId) }}
          </span>
        </el-form-item>
        <el-form-item label="参保日期" prop="enrollmentDate">
          <el-date-picker
            v-model="assignmentForm.enrollmentDate"
            type="date"
            placeholder="选择日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item label="保障金额" prop="coverageAmount">
          <el-input-number
            v-model="assignmentForm.coverageAmount"
            :min="0"
            :precision="2"
            :step="1000"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmit">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import api from "@/api/employeeBenefits";

// 加载状态
const loading = ref(false);

// 搜索表单
const searchForm = reactive({
  employeeId: "",
  benefitsplanId: "",
  coverageAmountMin: null,
  coverageAmountMax: null,
});

// 列表数据
const assignmentList = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 缓存数据
const employeeNames = reactive(new Map());
const benefitsPlans = reactive(new Map());

// 对话框控制
const dialogVisible = ref(false);
const dialogType = ref("add");
const assignmentFormRef = ref(null);
const assignmentForm = reactive({
  employeebenefitsId: null, // 编辑时使用
  employeeId: "",
  benefitsplanId: "",
  enrollmentDate: "",
  coverageAmount: 0,
});

// 表单验证规则
const rules = {
  employeeId: [
    { required: true, message: "请输入员工ID", trigger: "blur" },
    {
      type: "number",
      message: "员工ID必须为数字",
      trigger: "blur",
      transform: (value) => Number(value),
    },
  ],
  benefitsplanId: [
    { required: true, message: "请输入福利计划ID", trigger: "blur" },
    {
      type: "number",
      message: "福利计划ID必须为数字",
      trigger: "blur",
      transform: (value) => Number(value),
    },
  ],
  enrollmentDate: [
    { required: true, message: "请选择参保日期", trigger: "change" },
  ],
  coverageAmount: [
    { required: true, message: "请输入保障金额", trigger: "blur" },
    { type: "number", message: "保障金额必须为数字", trigger: "blur" },
  ],
};

// 获取员工姓名
const getEmployeeName = async (employeeId) => {
  if (!employeeId) return "";
  if (employeeNames.has(employeeId)) {
    return employeeNames.get(employeeId);
  }
  try {
    const res = await api.getEmployeeNameById(employeeId);
    if (res.data.code === 0 && res.data.data) {
      const name = res.data.data.name;
      employeeNames.set(employeeId, name);
      return name;
    }
    return employeeId;
  } catch (error) {
    console.error("获取员工姓名失败:", error);
    return employeeId;
  }
};

// 获取福利计划信息
const getBenefitsPlan = async (planId) => {
  if (!planId) return "";
  if (benefitsPlans.has(planId)) {
    return benefitsPlans.get(planId);
  }
  try {
    const res = await api.getBenefitsPlanById(planId);
    if (res.data.code === 0 && res.data.data) {
      const plan = res.data.data;
      benefitsPlans.set(planId, plan.planName || plan.name); // 兼容不同的返回字段
      return plan.planName || plan.name;
    }
    return planId;
  } catch (error) {
    console.error("获取福利计划信息失败:", error);
    return planId;
  }
};

// 监听表单中的福利计划ID变化
watch(
  () => assignmentForm.benefitsplanId,
  async (newVal) => {
    if (newVal) {
      await getBenefitsPlan(Number(newVal));
    }
  }
);

// 监听搜索表单中的福利计划ID变化
watch(
  () => searchForm.benefitsplanId,
  async (newVal) => {
    if (newVal) {
      await getBenefitsPlan(Number(newVal));
    }
  }
);

// 获取福利分配列表
const getAssignmentList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      employeeId: searchForm.employeeId
        ? Number(searchForm.employeeId)
        : undefined,
      benefitsplanId: searchForm.benefitsplanId
        ? Number(searchForm.benefitsplanId)
        : undefined,
      coverageAmountMin: searchForm.coverageAmountMin,
      coverageAmountMax: searchForm.coverageAmountMax,
    };

    const res = await api.getEmployeeBenefitsPage(params);
    if (res.data.code === 0) {
      const pageInfo = res.data.data;
      assignmentList.value = pageInfo.list;
      total.value = pageInfo.total;

      // 获取员工姓名和福利计划名称
      for (const item of assignmentList.value) {
        if (item.employeeId) {
          await getEmployeeName(item.employeeId);
        }
        if (item.benefitsplanId) {
          await getBenefitsPlan(item.benefitsplanId);
        }
      }
    } else {
      throw new Error(res.data.msg || "获取数据失败");
    }
  } catch (error) {
    console.error("获取福利分配列表失败:", error);
    ElMessage.error(error.message || "获取数据失败");
  } finally {
    loading.value = false;
  }
};

// 金额格式化
const formatAmount = (amount) => {
  return `¥${amount.toLocaleString()}`;
};

// 搜索和重置
const handleSearch = () => {
  currentPage.value = 1;
  getAssignmentList();
};

const resetSearch = () => {
  searchForm.employeeId = "";
  searchForm.benefitsplanId = "";
  searchForm.coverageAmountMin = null;
  searchForm.coverageAmountMax = null;
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  getAssignmentList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  getAssignmentList();
};

// 新增福利分配
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  assignmentForm.employeebenefitsId = null;
  assignmentForm.employeeId = "";
  assignmentForm.benefitsplanId = "";
  assignmentForm.enrollmentDate = "";
  assignmentForm.coverageAmount = 0;
  if (assignmentFormRef.value) {
    assignmentFormRef.value.resetFields();
  }
};

// 编辑福利分配
const handleEdit = async (row) => {
  loading.value = true;
  try {
    const res = await api.getEmployeeBenefitsById(row.employeebenefitsId);
    if (res.data.code === 0) {
      dialogType.value = "edit";
      dialogVisible.value = true;
      Object.assign(assignmentForm, res.data.data);
    } else {
      throw new Error(res.data.msg || "获取详情失败");
    }
  } catch (error) {
    console.error("获取福利分配详情失败:", error);
    ElMessage.error(error.message || "获取详情失败");
  } finally {
    loading.value = false;
  }
};

// 删除福利分配
const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该福利分配吗？此操作不可恢复", "提示", {
    type: "warning",
  })
    .then(async () => {
      loading.value = true;
      try {
        const res = await api.deleteEmployeeBenefits(row.employeebenefitsId);
        if (res.data.code === 0) {
          ElMessage.success(res.data.msg || "删除成功");
          getAssignmentList();
        } else {
          throw new Error(res.data.msg || "删除失败");
        }
      } catch (error) {
        console.error("删除福利分配失败:", error);
        ElMessage.error(error.message || "删除失败");
      } finally {
        loading.value = false;
      }
    })
    .catch(() => {});
};

// 提交表单
const handleSubmit = async () => {
  if (!assignmentFormRef.value) return;

  await assignmentFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true;
      try {
        const data = {
          employeebenefitsId: assignmentForm.employeebenefitsId,
          employeeId: Number(assignmentForm.employeeId),
          benefitsplanId: Number(assignmentForm.benefitsplanId),
          enrollmentDate: assignmentForm.enrollmentDate,
          coverageAmount: Number(assignmentForm.coverageAmount),
        };

        const submitApi =
          dialogType.value === "add"
            ? api.addEmployeeBenefits
            : api.updateEmployeeBenefits;
        const res = await submitApi(data);

        if (res.data.code === 0) {
          ElMessage.success(
            res.data.msg ||
              (dialogType.value === "add" ? "创建成功" : "更新成功")
          );
          dialogVisible.value = false;
          getAssignmentList();
        } else {
          throw new Error(
            res.data.msg ||
              (dialogType.value === "add" ? "创建失败" : "更新失败")
          );
        }
      } catch (error) {
        console.error("提交福利分配失败:", error);
        ElMessage.error(error.message || "提交失败");
      } finally {
        loading.value = false;
      }
    }
  });
};

onMounted(() => {
  getAssignmentList();
});
</script>

<style scoped>
.benefits-assignment {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.search-form {
  margin-bottom: 20px;
  background-color: #fff;
  padding: 20px;
  border-radius: 4px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.mx-2 {
  margin: 0 8px;
}

.form-item-hint {
  font-size: 12px;
  color: #666;
  margin-left: 10px;
}

.el-tag {
  margin-left: 8px;
}
</style>
