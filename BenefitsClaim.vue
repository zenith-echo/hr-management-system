<template>
  <page-container title="福利申请">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>提交申请
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="申请人">
          <el-select
            v-model="searchForm.employeeId"
            placeholder="请选择申请人"
            clearable
            filterable
          >
            <el-option
              v-for="emp in employeeList"
              :key="emp.employeeId"
              :label="emp.name"
              :value="emp.employeeId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="福利计划">
          <el-select
            v-model="searchForm.planId"
            placeholder="请选择福利计划"
            clearable
            filterable
          >
            <el-option
              v-for="plan in planList"
              :key="plan.benefitsplanId"
              :label="plan.planName"
              :value="plan.benefitsplanId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="申请日期">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
            clearable
          />
        </el-form-item>
      </el-form>
    </template>

    <!-- 数据表格 -->
    <el-table :data="claimList" border v-loading="loading">
      <el-table-column label="申请人">
        <template #default="{ row }">
          {{ employeeNames.get(row.employeeId) || row.employeeId }}
        </template>
      </el-table-column>
      <el-table-column label="福利计划">
        <template #default="{ row }">
          {{
            planList.find((p) => p.benefitsplanId === row.benefitsplanId)
              ?.planName || row.benefitsplanId
          }}
        </template>
      </el-table-column>
      <el-table-column prop="claimDate" label="申请日期" width="120" />
      <el-table-column prop="amount" label="申请金额">
        <template #default="{ row }">
          {{ formatAmount(row.amount) }}
        </template>
      </el-table-column>
      <el-table-column prop="reason" label="申请原因" show-overflow-tooltip />
      <el-table-column label="审批人">
        <template #default="{ row }">
          {{ employeeNames.get(row.approverId) || row.approverId }}
        </template>
      </el-table-column>
      <el-table-column prop="approvalDate" label="审批日期" width="120" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button
            type="success"
            link
            @click="handleApprove(row)"
            v-if="row.status === 'PENDING'"
          >
            <el-icon><Check /></el-icon>通过
          </el-button>
          <el-button
            type="danger"
            link
            @click="handleReject(row)"
            v-if="row.status === 'PENDING'"
          >
            <el-icon><Close /></el-icon>拒绝
          </el-button>
          <el-button type="primary" link @click="handleView(row)">
            <el-icon><View /></el-icon>查看
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
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '提交申请' : '查看申请'"
      width="500px"
    >
      <el-form
        ref="claimFormRef"
        :model="claimForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="申请人" prop="employeeId">
          <el-select
            v-if="dialogType === 'add'"
            v-model="claimForm.employeeId"
            placeholder="请选择申请人"
            filterable
          >
            <el-option
              v-for="emp in employeeList"
              :key="emp.employeeId"
              :label="emp.name"
              :value="emp.employeeId"
            />
          </el-select>
          <span v-else>{{
            employeeNames.get(claimForm.employeeId) || claimForm.employeeId
          }}</span>
        </el-form-item>
        <el-form-item label="福利计划" prop="benefitsplanId">
          <el-select
            v-if="dialogType === 'add'"
            v-model="claimForm.benefitsplanId"
            placeholder="请选择福利计划"
            filterable
          >
            <el-option
              v-for="plan in planList"
              :key="plan.benefitsplanId"
              :label="plan.planName"
              :value="plan.benefitsplanId"
            />
          </el-select>
          <span v-else>{{
            planList.find((p) => p.benefitsplanId === claimForm.benefitsplanId)
              ?.planName || claimForm.benefitsplanId
          }}</span>
        </el-form-item>
        <el-form-item label="申请金额" prop="amount">
          <el-input-number
            v-if="dialogType === 'add'"
            v-model="claimForm.amount"
            :precision="2"
            :step="100"
            :min="0"
          />
          <span v-else>{{ formatAmount(claimForm.amount) }}</span>
        </el-form-item>
        <el-form-item label="申请原因" prop="reason">
          <el-input
            v-if="dialogType === 'add'"
            v-model="claimForm.reason"
            type="textarea"
            placeholder="请输入申请原因"
          />
          <span v-else>{{ claimForm.reason }}</span>
        </el-form-item>
        <template v-if="dialogType === 'view'">
          <el-form-item label="审批人" v-if="claimForm.approverId">
            <span>{{
              employeeNames.get(claimForm.approverId) || claimForm.approverId
            }}</span>
          </el-form-item>
          <el-form-item label="审批日期" v-if="claimForm.approvalDate">
            <span>{{ claimForm.approvalDate }}</span>
          </el-form-item>
        </template>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">{{
            dialogType === "view" ? "关闭" : "取消"
          }}</el-button>
          <el-button
            type="primary"
            @click="handleSubmit"
            v-if="dialogType === 'add'"
            >提交</el-button
          >
        </span>
      </template>
    </el-dialog>
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import {
  Plus,
  Edit,
  Delete,
  View,
  Check,
  Close,
} from "@element-plus/icons-vue";
import PageContainer from "@/components/PageContainer.vue";
import api from "@/api/benefitsClaims";
import benefitsPlanApi from "@/api/benefitsPlan";
import employeeApi from "@/api/employee";

// 搜索表单
const searchForm = reactive({
  employeeId: "",
  planId: "",
  keyword: "",
  dateRange: [],
});

// 列表数据
const claimList = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);
const loading = ref(false);

// 对话框控制
const dialogVisible = ref(false);
const dialogType = ref("add");
const claimFormRef = ref(null);
const claimForm = reactive({
  employeeId: "",
  benefitsplanId: "",
  amount: 0,
  reason: "",
  status: "",
  approverId: "",
  approvalDate: "",
  claimDate: new Date().toISOString().split("T")[0], // 设置当前日期为申请日期
});

// 下拉选项数据
const planList = ref([]);
const employeeList = ref([]);
const approverList = ref([]);

// 员工姓名缓存
const employeeNames = reactive(new Map());

// 表单验证规则
const rules = {
  employeeId: [{ required: true, message: "请选择申请人", trigger: "change" }],
  benefitsplanId: [
    { required: true, message: "请选择福利计划", trigger: "change" },
  ],
  amount: [{ required: true, message: "请输入申请金额", trigger: "blur" }],
  reason: [{ required: true, message: "请输入申请原因", trigger: "blur" }],
  approverId: [{ required: true, message: "请输入审批人ID", trigger: "blur" }],
  approvalDate: [
    { required: true, message: "请选择审批日期", trigger: "change" },
  ],
};

// 获取员工列表
const getEmployeeList = async () => {
  try {
    const res = await employeeApi.getEmployeesPage({
      pageNum: 1,
      pageSize: 1000,
      status: "ACTIVE", // 只获取在职员工
    });
    if (res.data.code === 0) {
      employeeList.value = res.data.data.list;
    } else {
      ElMessage.error(res.data.msg || "获取员工列表失败");
    }
  } catch (error) {
    console.error("获取员工列表失败:", error);
    ElMessage.error(error.message || "获取员工列表失败");
  }
};

// 获取审批人列表（这里假设审批人也是员工）
const getApproverList = async () => {
  try {
    const res = await employeeApi.getEmployeesPage({
      pageNum: 1,
      pageSize: 1000,
      status: "ACTIVE",
      // 这里可以添加筛选条件，比如特定职位或部门的员工才能作为审批人
    });
    if (res.data.code === 0) {
      approverList.value = res.data.data.list;
    } else {
      ElMessage.error(res.data.msg || "获取审批人列表失败");
    }
  } catch (error) {
    console.error("获取审批人列表失败:", error);
    ElMessage.error(error.message || "获取审批人列表失败");
  }
};

// 获取福利计划列表
const getPlanList = async () => {
  try {
    const res = await benefitsPlanApi.getBenefitsPlanList({
      pageNum: 1,
      pageSize: 100,
    });
    if (res.data.code === 0) {
      planList.value = res.data.data.list;
    } else {
      ElMessage.error(res.data.msg || "获取福利计划列表失败");
    }
  } catch (error) {
    console.error("获取福利计划列表失败:", error);
    ElMessage.error(error.message || "获取福利计划列表失败");
  }
};

// 获取员工姓名
const getEmployeeName = async (employeeId) => {
  if (!employeeId) return "";
  if (employeeNames.has(employeeId)) {
    return employeeNames.get(employeeId);
  }
  try {
    const res = await employeeApi.getEmployeeNameById(employeeId);
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

// 批量获取员工姓名
const getEmployeeNames = async (employeeIds) => {
  const uniqueIds = [...new Set(employeeIds)].filter(
    (id) => !employeeNames.has(id)
  );
  if (uniqueIds.length === 0) return;

  try {
    // 串行查询每个员工的姓名
    for (const id of uniqueIds) {
      const res = await employeeApi.getEmployeeNameById(id);
      if (res.data.code === 0 && res.data.data) {
        employeeNames.set(res.data.data.employeeId, res.data.data.name);
      }
    }
  } catch (error) {
    console.error("批量获取员工姓名失败:", error);
  }
};

// 获取福利申请列表
const getClaimList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      employeeId: searchForm.employeeId,
      benefitsplanId: searchForm.planId,
      keyword: searchForm.keyword,
      claimDateStart: searchForm.dateRange?.[0],
      claimDateEnd: searchForm.dateRange?.[1],
    };

    const res = await api.getClaimsList(params);
    if (res.data.code === 0) {
      const pageInfo = res.data.data;
      claimList.value = pageInfo.list;
      total.value = pageInfo.total;

      // 批量获取员工姓名
      const employeeIds = claimList.value.reduce((ids, claim) => {
        if (claim.employeeId) ids.push(claim.employeeId);
        if (claim.approverId) ids.push(claim.approverId);
        return ids;
      }, []);
      await getEmployeeNames(employeeIds);
    } else {
      ElMessage.error(res.data.msg || "获取数据失败");
    }
  } catch (error) {
    console.error("获取福利申请列表失败:", error);
    ElMessage.error(error.message || "获取福利申请列表失败");
  } finally {
    loading.value = false;
  }
};

// 状态处理
const getStatusType = (status) => {
  const statusMap = {
    PENDING: "warning",
    APPROVED: "success",
    REJECTED: "danger",
  };
  return statusMap[status] || "";
};

const getStatusText = (status) => {
  const statusMap = {
    PENDING: "待审批",
    APPROVED: "已通过",
    REJECTED: "已拒绝",
  };
  return statusMap[status] || status;
};

// 金额格式化
const formatAmount = (amount) => {
  return `¥${amount.toLocaleString()}`;
};

// 搜索和重置
const handleSearch = () => {
  currentPage.value = 1;
  getClaimList();
};

const resetSearch = () => {
  searchForm.employeeId = "";
  searchForm.planId = "";
  searchForm.keyword = "";
  searchForm.dateRange = [];
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  getClaimList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  getClaimList();
};

// 新增申请
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  // 重置表单数据
  claimForm.employeeId = "";
  claimForm.benefitsplanId = "";
  claimForm.amount = 0;
  claimForm.reason = "";
  claimForm.claimDate = new Date().toISOString().split("T")[0];
  claimForm.approverId = "";
  claimForm.approvalDate = "";
  // 重置表单验证
  if (claimFormRef.value) {
    claimFormRef.value.resetFields();
  }
};

// 查看申请
const handleView = async (row) => {
  loading.value = true;
  try {
    const res = await api.getClaimById(row.claimId);
    if (res.data.code === 0) {
      dialogType.value = "view";
      dialogVisible.value = true;
      Object.assign(claimForm, res.data.data);
    } else {
      ElMessage.error(res.data.msg || "获取申请详情失败");
    }
  } catch (error) {
    console.error("获取申请详情失败:", error);
    ElMessage.error(error.message || "获取申请详情失败");
  } finally {
    loading.value = false;
  }
};

// 审批处理
const handleApprove = (row) => {
  ElMessageBox.confirm("确认通过该福利申请吗？", "提示", {
    type: "warning",
  })
    .then(async () => {
      try {
        const data = {
          ...row,
          status: "APPROVED",
          approvalDate: new Date().toISOString().split("T")[0],
          approverId: 1, // TODO: 从登录用户信息中获取
        };
        const res = await api.updateClaim(data);
        if (res.data.code === 0) {
          ElMessage.success(res.data.msg || "审批通过");
          getClaimList();
        } else {
          throw new Error(res.data.msg || "审批失败");
        }
      } catch (error) {
        console.error("审批失败:", error);
        ElMessage.error(error.message || "审批失败");
      }
    })
    .catch(() => {});
};

const handleReject = (row) => {
  ElMessageBox.confirm("确认拒绝该福利申请吗？", "提示", {
    type: "warning",
  })
    .then(async () => {
      try {
        const data = {
          ...row,
          status: "REJECTED",
          approvalDate: new Date().toISOString().split("T")[0],
          approverId: 1, // TODO: 从登录用户信息中获取
        };
        const res = await api.updateClaim(data);
        if (res.data.code === 0) {
          ElMessage.success(res.data.msg || "已拒绝");
          getClaimList();
        } else {
          throw new Error(res.data.msg || "操作失败");
        }
      } catch (error) {
        console.error("拒绝申请失败:", error);
        ElMessage.error(error.message || "操作失败");
      }
    })
    .catch(() => {});
};

// 删除申请
const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该福利申请吗？此操作不可恢复", "提示", {
    type: "warning",
  })
    .then(async () => {
      loading.value = true;
      try {
        const res = await api.deleteClaim(row.claimId);
        if (res.data.code === 0) {
          ElMessage.success(res.data.msg || "删除成功");
          getClaimList(); // 刷新列表
        } else {
          throw new Error(res.data.msg || "删除失败");
        }
      } catch (error) {
        console.error("删除申请失败:", error);
        ElMessage.error(error.message || "删除失败");
      } finally {
        loading.value = false;
      }
    })
    .catch(() => {
      // 取消删除，不做任何操作
    });
};

// 提交表单
const handleSubmit = async () => {
  if (!claimFormRef.value) return;

  await claimFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true;
      try {
        const data = {
          employeeId: Number(claimForm.employeeId), // 确保是数字类型
          benefitsplanId: Number(claimForm.benefitsplanId), // 确保是数字类型
          amount: Number(claimForm.amount), // 确保是数字类型
          reason: claimForm.reason?.trim() || "", // 确保不是undefined
          claimDate:
            claimForm.claimDate || new Date().toISOString().split("T")[0], // 确保有默认值
          approverId: Number(claimForm.approverId), // 确保是数字类型
          approvalDate:
            claimForm.approvalDate || new Date().toISOString().split("T")[0], // 确保有默认值
        };

        // 数据验证
        if (!data.employeeId || isNaN(data.employeeId)) {
          throw new Error("请输入有效的申请人ID");
        }
        if (!data.benefitsplanId || isNaN(data.benefitsplanId)) {
          throw new Error("请选择福利计划");
        }
        if (!data.amount || isNaN(data.amount) || data.amount <= 0) {
          throw new Error("请输入有效的申请金额");
        }
        if (!data.reason) {
          throw new Error("请输入申请原因");
        }
        if (!data.approverId || isNaN(data.approverId)) {
          throw new Error("请输入有效的审批人ID");
        }

        console.log("提交的申请数据:", data); // 添加日志

        const res = await api.addClaim(data);
        if (res.data.code === 0) {
          ElMessage.success(res.data.msg || "提交成功");
          dialogVisible.value = false;
          // 重置表单
          claimForm.employeeId = "";
          claimForm.benefitsplanId = "";
          claimForm.amount = 0;
          claimForm.reason = "";
          claimForm.claimDate = new Date().toISOString().split("T")[0];
          claimForm.approverId = "";
          claimForm.approvalDate = "";
          if (claimFormRef.value) {
            claimFormRef.value.resetFields();
          }
          // 刷新列表
          getClaimList();
        } else {
          throw new Error(res.data.msg || "提交失败");
        }
      } catch (error) {
        console.error("提交申请失败:", error);
        ElMessage.error(error.message || "提交失败");
      } finally {
        loading.value = false;
      }
    }
  });
};

onMounted(() => {
  getClaimList();
  getPlanList();
  getEmployeeList();
  getApproverList();
});
</script>

<style scoped>
.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.form-item-hint {
  font-size: 12px;
  color: #909399;
  margin-left: 10px;
}
</style>
