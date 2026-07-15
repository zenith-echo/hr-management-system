<template>
  <page-container title="薪资调整">
    <!-- 搜索栏 -->
    <template #search>
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="员工">
          <el-select
            v-model="searchForm.employeeId"
            placeholder="请选择员工"
            clearable
            style="width: 220px"
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="调整前工资">
          <el-input-number
            v-model="searchForm.previousSalaryMin"
            :precision="2"
            :step="100"
            placeholder="最小值"
            style="width: 130px"
            clearable
          />
          <span class="mx-2">-</span>
          <el-input-number
            v-model="searchForm.previousSalaryMax"
            :precision="2"
            :step="100"
            placeholder="最大值"
            style="width: 130px"
            clearable
          />
        </el-form-item>
        <el-form-item label="调整后工资">
          <el-input-number
            v-model="searchForm.newSalaryMin"
            :precision="2"
            :step="100"
            placeholder="最小值"
            style="width: 130px"
            clearable
          />
          <span class="mx-2">-</span>
          <el-input-number
            v-model="searchForm.newSalaryMax"
            :precision="2"
            :step="100"
            placeholder="最大值"
            style="width: 130px"
            clearable
          />
        </el-form-item>
        <el-form-item label="调整日期">
          <el-date-picker
            v-model="searchForm.adjustmentDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
            style="width: 240px"
            clearable
          />
        </el-form-item>
        <el-form-item label="调整原因">
          <el-input
            v-model="searchForm.keyword"
            placeholder="请输入关键字"
            clearable
            style="width: 200px"
            @keyup.enter="handleSearch"
          />
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
      <el-table-column
        prop="employeeName"
        label="员工姓名"
        width="120"
        align="center"
      />
      <el-table-column
        prop="previousSalary"
        label="调整前工资"
        width="120"
        align="right"
      >
        <template #default="scope">
          ￥{{ formatNumber(scope.row.previousSalary) }}
        </template>
      </el-table-column>
      <el-table-column
        prop="newSalary"
        label="调整后工资"
        width="120"
        align="right"
      >
        <template #default="scope">
          ￥{{ formatNumber(scope.row.newSalary) }}
        </template>
      </el-table-column>
      <el-table-column
        prop="adjustmentAmount"
        label="调整金额"
        width="120"
        align="right"
      >
        <template #default="scope">
          <span
            :class="{
              'text-success': scope.row.newSalary > scope.row.previousSalary,
              'text-danger': scope.row.newSalary < scope.row.previousSalary,
            }"
          >
            {{ formatAdjustmentAmount(scope.row) }}
          </span>
        </template>
      </el-table-column>
      <el-table-column
        prop="adjustmentDate"
        label="调整日期"
        width="120"
        align="center"
      />
      <el-table-column
        prop="reason"
        label="调整原因"
        min-width="200"
        show-overflow-tooltip
      />
      <el-table-column
        prop="approverName"
        label="审批人"
        width="120"
        align="center"
      />
      <el-table-column label="操作" width="180" fixed="right" align="center">
        <template #default="scope">
          <el-button-group>
            <el-tooltip content="查看" placement="top">
              <el-button type="primary" link @click="handleView(scope.row)">
                <el-icon><View /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip
              content="审批"
              placement="top"
              v-if="!scope.row.approverId"
            >
              <el-button type="success" link @click="handleApprove(scope.row)">
                <el-icon><Check /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip
              content="删除"
              placement="top"
              v-if="!scope.row.approverId"
            >
              <div>
                <el-popconfirm
                  title="确定要删除此记录吗？"
                  confirm-button-text="确定"
                  cancel-button-text="取消"
                  @confirm="handleDelete(scope.row)"
                >
                  <template #reference>
                    <el-button type="danger" link>
                      <el-icon><Delete /></el-icon>
                    </el-button>
                  </template>
                </el-popconfirm>
              </div>
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

    <!-- 查看详情对话框 -->
    <el-dialog
      v-model="dialogVisible"
      title="查看详情"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-descriptions :column="2" border>
        <el-descriptions-item label="员工姓名" :span="2">
          {{ adjustmentForm.employeeName }}
        </el-descriptions-item>
        <el-descriptions-item label="调整前工资">
          ￥{{ formatNumber(adjustmentForm.previousSalary) }}
        </el-descriptions-item>
        <el-descriptions-item label="调整后工资">
          ￥{{ formatNumber(adjustmentForm.newSalary) }}
        </el-descriptions-item>
        <el-descriptions-item label="调整金额">
          <span
            :class="{
              'text-success':
                adjustmentForm.newSalary > adjustmentForm.previousSalary,
              'text-danger':
                adjustmentForm.newSalary < adjustmentForm.previousSalary,
            }"
          >
            {{ formatAdjustmentAmount(adjustmentForm) }}
          </span>
        </el-descriptions-item>
        <el-descriptions-item label="调整日期">
          {{ adjustmentForm.adjustmentDate }}
        </el-descriptions-item>
        <el-descriptions-item label="调整原因" :span="2">
          {{ adjustmentForm.reason }}
        </el-descriptions-item>
        <el-descriptions-item label="审批状态">
          <el-tag :type="adjustmentForm.approverId ? 'success' : 'warning'">
            {{ adjustmentForm.approverId ? "已审批" : "待审批" }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="审批人">
          {{ adjustmentForm.approverName || "-" }}
        </el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 审批对话框 -->
    <el-dialog
      v-model="approveDialogVisible"
      title="薪资调整审批"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="approveFormRef"
        :model="approveForm"
        :rules="approveRules"
        label-width="100px"
        :validate-on-rule-change="false"
      >
        <el-form-item label="审批结果" prop="status">
          <el-radio-group v-model="approveForm.status">
            <el-radio label="已通过">通过</el-radio>
            <el-radio label="已驳回">驳回</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审批意见" prop="approverComment">
          <el-input
            v-model="approveForm.approverComment"
            type="textarea"
            :rows="3"
            placeholder="请输入审批意见"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="approveDialogVisible = false">取消</el-button>
          <el-button
            type="primary"
            @click="submitApprove"
            :loading="submitting"
          >
            确定
          </el-button>
        </span>
      </template>
    </el-dialog>
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import { Delete, Search, Refresh, View, Check } from "@element-plus/icons-vue";
import { ElMessage } from "element-plus";
import salaryAdjustmentApi from "@/api/salaryAdjustment";
import employeeApi from "@/api/employee";
import PageContainer from "@/components/PageContainer.vue";

// 表格数据
const loading = ref(false);
const submitting = ref(false);
const tableData = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 搜索表单
const searchForm = reactive({
  employeeId: "",
  previousSalaryMin: null,
  previousSalaryMax: null,
  newSalaryMin: null,
  newSalaryMax: null,
  adjustmentDate: [],
  keyword: "",
});

// 查看表单
const dialogVisible = ref(false);
const adjustmentForm = reactive({
  employeeId: "",
  employeeName: "",
  previousSalary: 0,
  newSalary: 0,
  adjustmentDate: "",
  reason: "",
  approverName: "",
});

// 审批表单
const approveDialogVisible = ref(false);
const approveFormRef = ref(null);
const approveForm = reactive({
  adjustmentId: "",
  status: "已通过",
  approverComment: "",
});

// 审批表单验证规则
const approveRules = {
  status: [{ required: true, message: "请选择审批结果", trigger: "change" }],
  approverComment: [
    { required: true, message: "请输入审批意见", trigger: "blur" },
    { max: 500, message: "审批意见不能超过500个字符", trigger: "blur" },
  ],
};

// 员工选项
const employeeOptions = ref([]);

// 获取员工列表
const getEmployeeList = async () => {
  try {
    const res = await employeeApi.getEmployeesPage({
      pageSize: 1000,
      select: "employeeId,name,status",
    });
    if (res.data?.code === 0 && res.data?.data?.list) {
      employeeOptions.value = res.data.data.list.map((item) => ({
        value: item.employeeId,
        label: item.name,
      }));
    }
  } catch (error) {
    console.error("获取员工列表失败:", error);
    ElMessage.error("获取员工列表失败");
  }
};

// 获取员工姓名
const getEmployeeName = async (employeeId) => {
  try {
    const res = await employeeApi.getEmployeeNameById(employeeId);
    return res.data?.data?.name || "";
  } catch (error) {
    console.error("获取员工姓名失败:", error);
    return "";
  }
};

// 处理表格数据，补充员工和审批人信息
const processTableData = async (data) => {
  if (!Array.isArray(data)) return [];

  const processedData = await Promise.all(
    data.map(async (item) => {
      const [employeeName, approverName] = await Promise.all([
        getEmployeeName(item.employeeId),
        item.approverId
          ? getEmployeeName(item.approverId)
          : Promise.resolve(""),
      ]);

      return {
        ...item,
        employeeName,
        approverName,
      };
    })
  );

  return processedData;
};

// 获取状态对应的标签类型
const getStatusType = (status) => {
  const statusMap = {
    待审批: "warning",
    已通过: "success",
    已驳回: "danger",
  };
  return statusMap[status] || "";
};

// 格式化数字
const formatNumber = (num) => {
  return num?.toFixed(2) || "0.00";
};

// 格式化调整金额
const formatAdjustmentAmount = (row) => {
  const amount = row.newSalary - row.previousSalary;
  return amount > 0 ? `+￥${amount.toFixed(2)}` : `￥${amount.toFixed(2)}`;
};

// 获取薪资调整列表
const getAdjustmentList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      employeeId: searchForm.employeeId || undefined,
      previousSalaryMin: searchForm.previousSalaryMin || undefined,
      previousSalaryMax: searchForm.previousSalaryMax || undefined,
      newSalaryMin: searchForm.newSalaryMin || undefined,
      newSalaryMax: searchForm.newSalaryMax || undefined,
      adjustmentDateStart: searchForm.adjustmentDate?.[0] || undefined,
      adjustmentDateEnd: searchForm.adjustmentDate?.[1] || undefined,
      keyword: searchForm.keyword || undefined,
    };

    const res = await salaryAdjustmentApi.getAdjustmentPage(params);
    if (res.code === 0 && res.data) {
      tableData.value = await processTableData(res.data.list || []);
      total.value = res.data.total || 0;
    } else {
      throw new Error(res.msg || "获取数据失败");
    }
  } catch (error) {
    console.error("获取薪资调整列表失败:", error);
    ElMessage.error(error.message || "获取数据失败");
  } finally {
    loading.value = false;
  }
};

// 处理查看详情
const handleView = async (row) => {
  try {
    const res = await salaryAdjustmentApi.getAdjustmentById(row.adjustmentId);
    if (res.code === 0 && res.data) {
      dialogVisible.value = true;

      // 获取员工和审批人信息
      const [employeeName, approverName] = await Promise.all([
        getEmployeeName(res.data.employeeId),
        res.data.approverId
          ? getEmployeeName(res.data.approverId)
          : Promise.resolve(""),
      ]);

      // 合并数据
      Object.assign(adjustmentForm, {
        ...res.data,
        employeeName,
        approverName,
      });
    } else {
      throw new Error(res.msg || "获取详情失败");
    }
  } catch (error) {
    console.error("获取详情失败", error);
    ElMessage.error(error.message || "获取详情失败");
  }
};

// 处理删除调整
const handleDelete = async (row) => {
  try {
    const res = await salaryAdjustmentApi.deleteAdjustment(row.adjustmentId);
    if (res.code === 0) {
      ElMessage.success("删除成功");
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      getAdjustmentList();
    } else {
      throw new Error(res.msg || "删除失败");
    }
  } catch (error) {
    console.error("删除失败", error);
    ElMessage.error(error.message || "删除失败");
  }
};

// 处理审批
const handleApprove = (row) => {
  approveDialogVisible.value = true;
  approveForm.adjustmentId = row.adjustmentId;
  approveForm.status = "已通过";
  approveForm.approverComment = "";
};

// 提交审批
const submitApprove = async () => {
  if (!approveFormRef.value) return;
  try {
    await approveFormRef.value.validate();
    submitting.value = true;
    const res = await salaryAdjustmentApi.updateAdjustment({
      ...approveForm,
      approverId: 1, // 这里应该是当前登录用户的ID
    });
    if (res.code === 0) {
      ElMessage.success("审批成功");
      approveDialogVisible.value = false;
      getAdjustmentList();
    } else {
      throw new Error(res.msg || "审批失败");
    }
  } catch (error) {
    console.error("审批失败", error);
    ElMessage.error(error.message || "审批失败");
  } finally {
    submitting.value = false;
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getAdjustmentList();
};

// 重置查询条件
const resetSearch = () => {
  searchForm.employeeId = "";
  searchForm.previousSalaryMin = null;
  searchForm.previousSalaryMax = null;
  searchForm.newSalaryMin = null;
  searchForm.newSalaryMax = null;
  searchForm.adjustmentDate = [];
  searchForm.keyword = "";
  handleSearch();
};

// 处理分页大小变化
const handleSizeChange = (val) => {
  pageSize.value = val;
  getAdjustmentList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getAdjustmentList();
};

// 页面加载时获取数据
onMounted(async () => {
  await getEmployeeList();
  getAdjustmentList();
});
</script>

<style scoped>
:deep(.el-input-number .el-input__inner) {
  text-align: left;
}

:deep(.el-table) {
  --el-table-header-bg-color: var(--el-color-primary-light-9);
  --el-table-border-color: var(--el-border-color-lighter);
  --el-table-header-text-color: var(--el-text-color-primary);
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

:deep(.el-button-group) {
  display: inline-flex;
  gap: 4px;
}

:deep(.el-descriptions__label) {
  width: 120px;
  justify-content: flex-end;
}

:deep(.el-descriptions__content) {
  padding: 12px 16px;
}

.mx-2 {
  margin: 0 8px;
}

.text-success {
  color: #67c23a;
  font-weight: bold;
}

.text-danger {
  color: #f56c6c;
  font-weight: bold;
}
</style>
