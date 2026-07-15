<template>
  <page-container title="风险评估管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>新增评估
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="关键词">
          <el-input
            v-model="searchForm.keyword"
            placeholder="风险领域/描述"
            clearable
          />
        </el-form-item>
        <el-form-item label="影响级别">
          <el-select
            v-model="searchForm.impactLevel"
            placeholder="请选择"
            clearable
          >
            <el-option
              v-for="item in impactLevelOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <el-tag :type="item.type" size="small">{{ item.label }}</el-tag>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="可能性">
          <el-select
            v-model="searchForm.probability"
            placeholder="请选择"
            clearable
          >
            <el-option
              v-for="item in probabilityOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <span>{{ item.label }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">
                {{ item.description }}
              </span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="评估日期">
          <el-date-picker
            v-model="searchForm.assessmentDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
      </el-form>
    </template>

    <!-- 数据表格 -->
    <el-table :data="tableData" border v-loading="loading">
      <el-table-column type="index" label="序号" width="60" align="center" />
      <el-table-column prop="riskArea" label="风险领域" width="120">
        <template #default="{ row }">
          {{ getRiskAreaLabel(row.riskArea) }}
        </template>
      </el-table-column>
      <el-table-column
        prop="description"
        label="描述"
        min-width="200"
        show-overflow-tooltip
      />
      <el-table-column prop="impactLevel" label="影响级别" width="100">
        <template #default="{ row }">
          <el-tag :type="getImpactType(row.impactLevel)">
            {{ getImpactLabel(row.impactLevel) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="probability" label="可能性" width="180">
        <template #default="{ row }">
          <el-tooltip
            :content="
              probabilityOptions.find((p) => p.value === row.probability)
                ?.description
            "
            placement="top"
          >
            <div>
              <el-rate
                :model-value="getProbabilityRate(row.probability)"
                disabled
                text-color="#ff9900"
              />
            </div>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column prop="assessmentDate" label="评估日期" width="120">
        <template #default="{ row }">
          {{ formatDate(row.assessmentDate) }}
        </template>
      </el-table-column>
      <el-table-column prop="nextReview" label="下次审核" width="120">
        <template #default="{ row }">
          {{ formatDate(row.nextReview) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="handleView(row)">
            <el-icon><View /></el-icon>查看
          </el-button>
          <el-button type="primary" link @click="handleEdit(row)">
            <el-icon><Edit /></el-icon>编辑
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
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增风险评估' : '编辑风险评估'"
      width="800px"
      :close-on-click-modal="false"
      @closed="handleDialogClosed"
    >
      <el-form
        ref="riskFormRef"
        :model="riskForm"
        :rules="rules"
        label-width="100px"
        :disabled="formLoading"
      >
        <el-form-item label="风险领域" prop="riskArea">
          <el-select
            v-model="riskForm.riskArea"
            placeholder="请选择风险领域"
            style="width: 100%"
          >
            <el-option
              v-for="item in riskAreaOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="riskForm.description"
            type="textarea"
            :rows="3"
            placeholder="请详细描述风险情况，至少10个字符"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="影响级别" prop="impactLevel">
          <el-select
            v-model="riskForm.impactLevel"
            placeholder="请选择影响级别"
            style="width: 100%"
          >
            <el-option
              v-for="item in impactLevelOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <el-tag :type="item.type" size="small">{{ item.label }}</el-tag>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="可能性" prop="probability">
          <el-select
            v-model="riskForm.probability"
            placeholder="请选择发生可能性"
            style="width: 100%"
          >
            <el-option
              v-for="item in probabilityOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <span>{{ item.label }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">
                {{ item.description }}
              </span>
            </el-option>
          </el-select>
          <el-rate
            v-if="riskForm.probability"
            :model-value="getProbabilityRate(riskForm.probability)"
            disabled
            text-color="#ff9900"
            style="margin-top: 8px"
          />
        </el-form-item>
        <el-form-item label="评估日期" prop="assessmentDate">
          <el-date-picker
            v-model="riskForm.assessmentDate"
            type="date"
            placeholder="选择评估日期"
            value-format="YYYY-MM-DD"
            style="width: 100%"
            :disabled-date="(date) => date > new Date()"
          />
        </el-form-item>
        <el-form-item label="下次审核" prop="nextReview">
          <el-date-picker
            v-model="riskForm.nextReview"
            type="date"
            placeholder="选择下次审核日期"
            value-format="YYYY-MM-DD"
            style="width: 100%"
            :disabled-date="(date) => date <= new Date(riskForm.assessmentDate)"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false" :disabled="formLoading"
            >取消</el-button
          >
          <el-button type="primary" @click="submitForm" :loading="formLoading">
            {{ dialogType === "add" ? "新增" : "保存" }}
          </el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 查看风险评估对话框 -->
    <el-dialog v-model="viewDialogVisible" title="风险评估详情" width="800px">
      <div class="risk-content">
        <div class="metadata">
          <h3>
            {{ getRiskAreaLabel(selectedRisk?.riskArea) }} -
            {{ selectedRisk?.description }}
          </h3>
          <p>
            <span>
              影响级别：
              <el-tag :type="getImpactType(selectedRisk?.impactLevel)">
                {{ getImpactLabel(selectedRisk?.impactLevel) }}
              </el-tag>
            </span>
            <span class="separator">|</span>
            <span
              >可能性：
              <el-rate
                :model-value="getProbabilityRate(selectedRisk?.probability)"
                disabled
                text-color="#ff9900"
              />
            </span>
          </p>
          <p>
            <span
              >评估日期：{{ formatDate(selectedRisk?.assessmentDate) }}</span
            >
            <span class="separator">|</span>
            <span>下次审核：{{ formatDate(selectedRisk?.nextReview) }}</span>
          </p>
        </div>
      </div>
    </el-dialog>
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, nextTick } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import {
  Plus,
  Edit,
  Delete,
  Search,
  Refresh,
  View,
  ArrowDown,
} from "@element-plus/icons-vue";
import PageContainer from "@/components/PageContainer.vue";
import riskAssessmentApi from "@/api/riskAssessment";
import { useRoute, useRouter } from "vue-router";

// 常量定义
const riskAreaOptions = [
  { value: "HR", label: "人事管理" },
  { value: "Finance", label: "财务管理" },
  { value: "InfoSec", label: "信息安全" },
  { value: "Operations", label: "运营管理" },
  { value: "Compliance", label: "合规管理" },
];

// 修改影响级别选项定义
const impactLevelOptions = [
  { value: "低", label: "低", type: "info" },
  { value: "中", label: "中", type: "warning" },
  { value: "高", label: "高", type: "danger" },
  { value: "极高", label: "极高", type: "danger" },
];

// 修改可能性等级定义为文本格式
const probabilityOptions = [
  { value: "低", label: "低", description: "不太可能发生（<30%）", rate: 1 },
  { value: "中", label: "中", description: "可能发生（30-70%）", rate: 3 },
  { value: "高", label: "高", description: "很可能发生（>70%）", rate: 5 },
];

// 状态定义
const loading = ref(false);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);
const tableData = ref([]);
const dialogVisible = ref(false);
const dialogType = ref("add");
const viewDialogVisible = ref(false);
const selectedRisk = ref(null);
const riskFormRef = ref(null);
const formLoading = ref(false);

// 搜索表单
const searchForm = reactive({
  keyword: "",
  impactLevel: "",
  probability: "",
  assessmentDate: [],
});

// 表单数据
const defaultFormData = {
  assessmentId: null,
  riskArea: "",
  description: "",
  impactLevel: "",
  probability: "中",
  assessmentDate: "",
  nextReview: "",
};

const riskForm = reactive({ ...defaultFormData });

// 表单验证规则
const rules = {
  riskArea: [{ required: true, message: "请选择风险领域", trigger: "change" }],
  description: [
    { required: true, message: "请输入风险描述", trigger: "blur" },
    {
      min: 10,
      max: 500,
      message: "描述长度应在10到500个字符之间",
      trigger: "blur",
    },
  ],
  impactLevel: [
    { required: true, message: "请选择影响级别", trigger: "change" },
  ],
  probability: [
    { required: true, message: "请选择可能性", trigger: "change" },
    {
      type: "string",
      enum: ["低", "中", "高"],
      message: "可能性只能是低、中、高",
      trigger: "change",
    },
  ],
  assessmentDate: [
    { required: true, message: "请选择评估日期", trigger: "change" },
  ],
  nextReview: [
    { required: true, message: "请选择下次审核日期", trigger: "change" },
    {
      validator: (rule, value, callback) => {
        if (
          value &&
          riskForm.assessmentDate &&
          value <= riskForm.assessmentDate
        ) {
          callback(new Error("下次审核日期必须晚于评估日期"));
        } else {
          callback();
        }
      },
      trigger: "change",
    },
  ],
};

// 工具函数
const formatDate = (date) => {
  if (!date) return "";
  return date;
};

const getRiskAreaLabel = (value) => {
  const option = riskAreaOptions.find((item) => item.value === value);
  return option ? option.label : value;
};

const getImpactLabel = (value) => {
  const option = impactLevelOptions.find((item) => item.value === value);
  return option ? option.label : value;
};

const getImpactType = (level) => {
  const option = impactLevelOptions.find((item) => item.value === level);
  return option ? option.type : "info";
};

// 在 script setup 中添加计算属性
const getProbabilityRate = (probability) => {
  const option = probabilityOptions.find((p) => p.value === probability);
  return option ? option.rate : 0;
};

// API调用函数
const getList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      keyword: searchForm.keyword || undefined,
      impactLevel: searchForm.impactLevel || undefined,
      probability: searchForm.probability || undefined,
      assessmentDateStart: searchForm.assessmentDate?.[0] || undefined,
      assessmentDateEnd: searchForm.assessmentDate?.[1] || undefined,
    };

    const res = await riskAssessmentApi.getRiskAssessmentPage(params);
    if (res.data.code === 0) {
      tableData.value = res.data.data.list.map((item) => ({
        ...item,
        probability: item.probability || "中",
        impactLevel: item.impactLevel || "低",
      }));
      total.value = res.data.data.total;
    }
  } catch (error) {
    console.error("获取列表失败:", error);
    ElMessage.error(error.message || "获取列表失败");
  } finally {
    loading.value = false;
  }
};

// 事件处理函数
const handleSearch = () => {
  currentPage.value = 1;
  // 更新路由查询参数
  router.push({
    query: {
      ...route.query,
      keyword: searchForm.keyword || undefined,
      impactLevel: searchForm.impactLevel || undefined,
      probability: searchForm.probability || undefined,
      assessmentDateStart: searchForm.assessmentDate?.[0] || undefined,
      assessmentDateEnd: searchForm.assessmentDate?.[1] || undefined,
      pageNum: 1,
    },
  });
  getList();
};

const resetSearch = () => {
  Object.keys(searchForm).forEach((key) => {
    searchForm[key] = key === "assessmentDate" ? [] : "";
  });
  // 清除路由查询参数
  router.push({ query: {} });
  currentPage.value = 1;
  getList();
};

const handleSizeChange = (val) => {
  pageSize.value = val;
  router.push({
    query: {
      ...route.query,
      pageSize: val,
      pageNum: currentPage.value,
    },
  });
  getList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  router.push({
    query: {
      ...route.query,
      pageNum: val,
    },
  });
  getList();
};

const handleAdd = () => {
  dialogType.value = "add";
  Object.assign(riskForm, defaultFormData);
  nextTick(() => {
    if (riskFormRef.value) {
      riskFormRef.value.resetFields();
    }
  });
  dialogVisible.value = true;
};

const handleView = async (row) => {
  try {
    const res = await riskAssessmentApi.getRiskAssessmentById(row.assessmentId);
    if (res.data.code === 0) {
      selectedRisk.value = {
        ...res.data.data,
        probability: res.data.data.probability || "中",
      };
      viewDialogVisible.value = true;
    }
  } catch (error) {
    console.error("获取详情失败:", error);
    ElMessage.error("获取详情失败");
  }
};

const handleEdit = async (row) => {
  dialogType.value = "edit";
  formLoading.value = true;
  try {
    const res = await riskAssessmentApi.getRiskAssessmentById(row.assessmentId);
    if (res.data.code === 0) {
      Object.assign(riskForm, {
        ...defaultFormData,
        ...res.data.data,
        probability: res.data.data.probability || "中",
        impactLevel: res.data.data.impactLevel || "低",
      });
      dialogVisible.value = true;
    }
  } catch (error) {
    console.error("获取详情失败:", error);
    ElMessage.error(error.message || "获取详情失败");
  } finally {
    formLoading.value = false;
  }
};

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm("确定要删除此评估记录吗？", "提示", {
      type: "warning",
    });
    const res = await riskAssessmentApi.deleteRiskAssessment(row.assessmentId);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      getList();
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除失败:", error);
      ElMessage.error("删除失败");
    }
  }
};

const handleDialogClosed = () => {
  Object.assign(riskForm, defaultFormData);
  if (riskFormRef.value) {
    riskFormRef.value.resetFields();
  }
};

const submitForm = async () => {
  if (!riskFormRef.value) return;

  try {
    await riskFormRef.value.validate();
    formLoading.value = true;

    // 验证日期
    if (new Date(riskForm.nextReview) <= new Date(riskForm.assessmentDate)) {
      ElMessage.error("下次审核日期必须晚于评估日期");
      return;
    }

    const api =
      dialogType.value === "add"
        ? riskAssessmentApi.addRiskAssessment
        : riskAssessmentApi.updateRiskAssessment;

    const res = await api(riskForm);

    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "add" ? "新增成功" : "修改成功");
      dialogVisible.value = false;
      getList();
    }
  } catch (error) {
    console.error("提交失败:", error);
    ElMessage.error(error.message || "提交失败");
  } finally {
    formLoading.value = false;
  }
};

// 在script setup顶部添加
const route = useRoute();
const router = useRouter();

// 修改初始化
onMounted(() => {
  // 从路由查询参数初始化搜索表单
  initSearchFromQuery();
  // 设置分页参数
  currentPage.value = parseInt(route.query.pageNum) || 1;
  pageSize.value = parseInt(route.query.pageSize) || 10;
  getList();
});

// 添加路由查询参数处理函数
const initSearchFromQuery = () => {
  const query = route.query;
  searchForm.keyword = query.keyword || "";
  searchForm.impactLevel = query.impactLevel || "";
  searchForm.probability = query.probability || "";
  if (query.assessmentDateStart && query.assessmentDateEnd) {
    searchForm.assessmentDate = [
      query.assessmentDateStart,
      query.assessmentDateEnd,
    ];
  } else {
    searchForm.assessmentDate = [];
  }
};

// 在script setup中添加
const showImpactSelect = ref(false);
const showProbabilitySelect = ref(false);
</script>

<style scoped>
.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.risk-content {
  padding: 20px;
}

.metadata {
  margin-bottom: 20px;
}

.metadata h3 {
  margin-top: 0;
  margin-bottom: 15px;
  color: #303133;
}

.metadata p {
  margin: 8px 0;
}

.separator {
  margin: 0 10px;
  color: #dcdfe6;
}

.section {
  margin-top: 20px;
}

.section h4 {
  color: #303133;
  margin-bottom: 10px;
}

.section p {
  white-space: pre-wrap;
  line-height: 1.6;
}

:deep(.el-button) {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

:deep(.el-tag .el-rate) {
  display: inline-flex;
  height: 16px;
}

:deep(.el-tag .el-rate__icon) {
  font-size: 12px;
  margin-right: 2px;
}
</style>
