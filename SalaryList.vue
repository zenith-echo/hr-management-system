<template>
  <page-container title="薪资福利">
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
        <el-form-item label="年份">
          <el-date-picker
            v-model="searchForm.year"
            type="year"
            placeholder="选择年份"
            clearable
            style="width: 120px"
          />
        </el-form-item>
        <el-form-item label="月份">
          <el-select
            v-model="searchForm.month"
            placeholder="请选择月份"
            clearable
            style="width: 120px"
          >
            <el-option v-for="i in 12" :key="i" :label="`${i}月`" :value="i" />
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
      <el-table-column
        prop="employeeName"
        label="员工姓名"
        width="120"
        align="center"
      />
      <el-table-column prop="year" label="年份" width="80" align="center" />
      <el-table-column prop="month" label="月份" width="80" align="center">
        <template #default="scope">{{ scope.row.month }}月</template>
      </el-table-column>
      <el-table-column
        prop="baseSalary"
        label="基本工资"
        width="120"
        align="right"
      >
        <template #default="scope">
          {{ formatMoney(scope.row.baseSalary) }}
        </template>
      </el-table-column>
      <el-table-column
        prop="performanceBonus"
        label="绩效奖金"
        width="120"
        align="right"
      >
        <template #default="scope">
          {{ formatMoney(scope.row.performanceBonus) }}
        </template>
      </el-table-column>
      <el-table-column
        prop="netSalary"
        label="实发工资"
        width="120"
        align="right"
      >
        <template #default="scope">
          <span class="net-salary">{{ formatMoney(scope.row.netSalary) }}</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="paymentStatus"
        label="发放状态"
        width="100"
        align="center"
      >
        <template #default="scope">
          <el-tag :type="getStatusType(scope.row.paymentStatus)" effect="light">
            {{ scope.row.paymentStatus }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="paymentDate"
        label="发放日期"
        width="120"
        align="center"
      />
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
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import { Search, Refresh } from "@element-plus/icons-vue";
import { ElMessage } from "element-plus";
import salaryApi from "@/api/salary";
import employeeApi from "@/api/employee";
import PageContainer from "@/components/PageContainer.vue";

// 表格数据
const loading = ref(false);
const tableData = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 搜索表单
const searchForm = reactive({
  employeeId: "",
  year: "",
  month: "",
});

// 员工选项
const employeeOptions = ref([]);

// 格式化金额
const formatMoney = (amount) => {
  if (amount === null || amount === undefined) {
    return "￥0.00";
  }
  return `￥${Number(amount).toFixed(2)}`;
};

// 获取状态对应的标签类型
const getStatusType = (status) => {
  const statusMap = {
    未发放: "warning",
    已发放: "success",
    发放失败: "danger",
  };
  return statusMap[status] || "";
};

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
    } else {
      throw new Error("获取员工列表失败");
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
    if (res.data?.code === 0 && res.data?.data) {
      return res.data.data.name || "";
    }
    return "";
  } catch (error) {
    console.error("获取员工姓名失败:", error);
    return "";
  }
};

// 处理表格数据，补充员工信息
const processTableData = async (data) => {
  if (!Array.isArray(data)) return [];

  const processedData = await Promise.all(
    data.map(async (item) => {
      const employeeName = await getEmployeeName(item.employeeId);

      return {
        ...item,
        employeeName,
        baseSalary: item.baseSalary ? Number(item.baseSalary) : 0,
        performanceBonus: item.performanceBonus
          ? Number(item.performanceBonus)
          : 0,
        netSalary: item.netSalary ? Number(item.netSalary) : 0,
      };
    })
  );

  return processedData;
};

// 获取薪资记录列表
const getSalaryList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      employeeId: searchForm.employeeId || undefined,
      year: searchForm.year
        ? new Date(searchForm.year).getFullYear()
        : undefined,
      month: searchForm.month,
    };

    const res = await salaryApi.getSalaryPage(params);
    if (res.code === 0 && res.data) {
      tableData.value = await processTableData(res.data.list || []);
      total.value = res.data.total || 0;
    } else {
      throw new Error(res.msg || "获取数据失败");
    }
  } catch (error) {
    console.error("获取薪资记录列表失败:", error);
    ElMessage.error(error.message || "获取数据失败");
  } finally {
    loading.value = false;
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getSalaryList();
};

// 重置查询条件
const resetSearch = () => {
  searchForm.employeeId = "";
  searchForm.year = "";
  searchForm.month = "";
  handleSearch();
};

// 处理分页大小变化
const handleSizeChange = (val) => {
  pageSize.value = val;
  getSalaryList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getSalaryList();
};

// 页面加载时获取数据
onMounted(async () => {
  await getEmployeeList();
  await getSalaryList();
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

.net-salary {
  color: #67c23a;
  font-weight: bold;
}
</style>
