<template>
  <div class="asset-maintenance">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>资产维护管理</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>新增维护记录
          </el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="关键字">
          <el-input
            v-model="searchForm.keyword"
            placeholder="搜索服务提供商/备注"
          />
        </el-form-item>
        <el-form-item label="维护类型">
          <el-select
            v-model="searchForm.maintenanceType"
            placeholder="请选择维护类型"
            clearable
            filterable
          >
            <el-option
              v-for="item in maintenanceTypeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <span style="float: left">{{ item.label }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">
                {{ item.description }}
              </span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="维护日期">
          <el-date-picker
            v-model="searchForm.maintenanceDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item label="资产">
          <el-select
            v-model="searchForm.assetId"
            placeholder="请选择资产"
            clearable
            filterable
            :filter-method="filterAssets"
            style="width: 300px"
          >
            <el-option
              v-for="item in filteredAssetOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <div class="asset-option">
                <div class="asset-name">{{ item.label }}</div>
                <div class="asset-info">
                  <span>类型：{{ item.type || "未知" }}</span>
                  <span class="asset-id">编号：{{ item.value }}</span>
                </div>
              </div>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 维护记录表格 -->
      <el-table
        :data="tableData"
        style="width: 100%"
        border
        v-loading="loading"
      >
        <el-table-column label="资产信息" min-width="200">
          <template #default="scope">
            <div v-if="getAssetInfo(scope.row.assetId)">
              <div>
                <strong>名称：</strong
                >{{ getAssetInfo(scope.row.assetId).assetName }}
              </div>
              <div>
                <strong>类型：</strong
                >{{ getAssetInfo(scope.row.assetId).assetType }}
              </div>
              <div><strong>编号：</strong>{{ scope.row.assetId }}</div>
            </div>
            <div v-else>未知资产</div>
          </template>
        </el-table-column>
        <el-table-column prop="maintenanceType" label="维护类型" width="120">
          <template #default="scope">
            {{ getMaintenanceTypeText(scope.row.maintenanceType) }}
          </template>
        </el-table-column>
        <el-table-column prop="maintenanceDate" label="维护日期" width="120" />
        <el-table-column prop="cost" label="维护费用" width="120">
          <template #default="scope">
            ¥{{ Number(scope.row.cost).toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column prop="provider" label="服务提供商" min-width="150" />
        <el-table-column
          prop="notes"
          label="备注"
          min-width="200"
          show-overflow-tooltip
        />
        <el-table-column label="操作" width="220" fixed="right">
          <template #default="scope">
            <el-button
              size="small"
              type="primary"
              link
              @click="handleEdit(scope.row)"
            >
              <el-icon><Edit /></el-icon>编辑
            </el-button>
            <el-popconfirm
              title="确认删除该维护记录吗？"
              @confirm="handleDelete(scope.row)"
            >
              <template #reference>
                <el-button size="small" type="danger" link>
                  <el-icon><Delete /></el-icon>删除
                </el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 新增/编辑维护记录对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增维护记录' : '编辑维护记录'"
      width="600px"
      :close-on-click-modal="false"
      @closed="resetForm"
    >
      <el-form
        ref="maintenanceFormRef"
        :model="maintenanceForm"
        :rules="rules"
        label-width="100px"
        :validate-on-rule-change="false"
      >
        <el-form-item label="选择资产" prop="assetId">
          <el-select
            v-model="maintenanceForm.assetId"
            placeholder="请选择资产"
            style="width: 100%"
            filterable
            :filter-method="filterAssets"
          >
            <el-option
              v-for="item in filteredAssetOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <div class="asset-option">
                <div class="asset-name">{{ item.label }}</div>
                <div class="asset-info">
                  <span>类型：{{ item.type || "未知" }}</span>
                  <span class="asset-id">编号：{{ item.value }}</span>
                </div>
              </div>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="维护类型" prop="maintenanceType">
          <el-select
            v-model="maintenanceForm.maintenanceType"
            placeholder="请选择维护类型"
            style="width: 100%"
            filterable
          >
            <el-option
              v-for="item in maintenanceTypeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <span style="float: left">{{ item.label }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">
                {{ item.description }}
              </span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="维护日期" prop="maintenanceDate">
          <el-date-picker
            v-model="maintenanceForm.maintenanceDate"
            type="date"
            placeholder="选择维护日期"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="维护费用" prop="cost">
          <el-input-number
            v-model="maintenanceForm.cost"
            :precision="2"
            :step="100"
            :min="0"
            :max="9999999.99"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="服务提供商" prop="provider">
          <el-input
            v-model="maintenanceForm.provider"
            placeholder="请输入服务提供商"
            maxlength="100"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="备注" prop="notes">
          <el-input
            v-model="maintenanceForm.notes"
            type="textarea"
            :rows="3"
            placeholder="请输入维护备注信息"
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
import { useRoute } from "vue-router";
import api from "../../api/assetMaintenance";
import assetApi from "../../api/asset";
import { Plus, Edit, Delete } from "@element-plus/icons-vue";

const route = useRoute();

// 搜索表单
const searchForm = reactive({
  keyword: "",
  maintenanceType: "",
  maintenanceDate: [],
  assetId: "",
});

// 表格数据
const tableData = ref([]);
const loading = ref(false);

// 分页
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref("add");
const maintenanceForm = reactive({
  maintenanceId: null,
  assetId: "",
  maintenanceType: "",
  maintenanceDate: "",
  cost: 0,
  provider: "",
  notes: "",
});

// 表单ref
const maintenanceFormRef = ref(null);
const submitting = ref(false);

// 表单规则
const rules = {
  assetId: [{ required: true, message: "请选择资产", trigger: "change" }],
  maintenanceType: [
    { required: true, message: "请选择维护类型", trigger: "change" },
  ],
  maintenanceDate: [
    { required: true, message: "请选择维护日期", trigger: "change" },
  ],
  cost: [
    { required: true, message: "请输入维护费用", trigger: "change" },
    {
      validator: (rule, value, callback) => {
        if (value < 0 || value > 9999999.99) {
          callback(new Error("维护费用必须在0-9999999.99之间"));
        } else {
          callback();
        }
      },
      trigger: "change",
    },
  ],
  provider: [
    { required: true, message: "请输入服务提供商", trigger: "blur" },
    { max: 100, message: "服务提供商不能超过100个字符", trigger: "blur" },
  ],
  notes: [{ max: 500, message: "备注不能超过500个字符", trigger: "blur" }],
};

// 资产选项（模拟数据）
const assetOptions = ref([]);

// 维护类型选项
const maintenanceTypeOptions = [
  {
    value: "hardware",
    label: "硬件维修",
    description: "维修或更换硬件设备",
  },
  {
    value: "software",
    label: "软件升级",
    description: "系统升级或软件更新",
  },
  {
    value: "cleaning",
    label: "清洁保养",
    description: "定期清洁和基础保养",
  },
  {
    value: "preventive",
    label: "预防性维护",
    description: "预防性检查和维护",
  },
];

// 资产选项过滤
const filteredAssetOptions = ref([]);

// 初始化过滤选项
const initFilteredAssetOptions = () => {
  filteredAssetOptions.value = assetOptions.value;
};

// 过滤资产选项
const filterAssets = (query) => {
  if (query !== "") {
    filteredAssetOptions.value = assetOptions.value.filter((item) => {
      return (
        item.label.toLowerCase().includes(query.toLowerCase()) ||
        item.value.toString().includes(query) ||
        (item.type || "").toLowerCase().includes(query.toLowerCase())
      );
    });
  } else {
    filteredAssetOptions.value = assetOptions.value;
  }
};

// 监听资产选项变化
watch(assetOptions, () => {
  initFilteredAssetOptions();
});

// 获取资产详细信息
const getAssetInfo = (assetId) => {
  const asset = assetOptions.value.find(
    (item) => Number(item.value) === Number(assetId)
  );
  if (!asset) {
    return {
      assetName: "未知资产",
      assetType: "未知类型",
      assetId: assetId,
    };
  }
  return {
    assetName: asset.label,
    assetType: asset.type || "未知类型",
    assetId: asset.value,
  };
};

// 获取资产列表
const fetchAssets = async () => {
  try {
    const res = await assetApi.getAssetsPage({
      pageNum: 1,
      pageSize: 1000,
    });
    if (res.data.code === 0 && res.data.data.list) {
      assetOptions.value = res.data.data.list.map((item) => ({
        value: Number(item.assetId),
        label: item.assetName,
        type: item.assetType, // 保存资产类型
      }));
    }
  } catch (error) {
    console.error("获取资产列表错误:", error);
    ElMessage.error("获取资产列表失败");
  }
};

// 获取维护记录列表
const fetchMaintenanceList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      keyword: searchForm.keyword || "",
      startDate: searchForm.maintenanceDate?.[0] || "",
      endDate: searchForm.maintenanceDate?.[1] || "",
      assetId: searchForm.assetId || "",
    };

    // 如果选择了维护类型，将其添加到关键字中
    if (searchForm.maintenanceType) {
      params.keyword = params.keyword
        ? `${params.keyword} ${searchForm.maintenanceType}`
        : searchForm.maintenanceType;
    }

    const res = await api.getMaintenancePage(params);
    if (res.data.code === 0) {
      tableData.value = res.data.data.list || [];
      total.value = res.data.data.total || 0;
    } else {
      throw new Error(res.data.msg || "获取维护记录失败");
    }
  } catch (error) {
    console.error("获取维护记录错误:", error);
    ElMessage.error(error.message || "获取维护记录失败");
  } finally {
    loading.value = false;
  }
};

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1;
  fetchMaintenanceList();
};

const resetSearch = () => {
  searchForm.keyword = "";
  searchForm.maintenanceType = "";
  searchForm.maintenanceDate = [];
  searchForm.assetId = "";
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  fetchMaintenanceList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  fetchMaintenanceList();
};

// 表单处理
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  Object.keys(maintenanceForm).forEach((key) => {
    maintenanceForm[key] =
      key === "cost" ? 0 : key === "maintenanceId" ? null : "";
  });
};

const handleEdit = async (row) => {
  try {
    const res = await api.getMaintenanceById(row.maintenanceId);
    if (res.data.code === 0) {
      dialogType.value = "edit";
      dialogVisible.value = true;
      Object.assign(maintenanceForm, res.data.data);
    } else {
      throw new Error(res.data.msg || "获取维护记录详情失败");
    }
  } catch (error) {
    console.error("获取维护记录详情错误:", error);
    ElMessage.error(error.message || "获取维护记录详情失败");
  }
};

const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该维护记录吗？", "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  }).then(async () => {
    try {
      const res = await api.deleteMaintenance(row.maintenanceId);
      if (res.data.code === 0) {
        ElMessage.success("删除成功");
        fetchMaintenanceList();
      } else {
        throw new Error(res.data.msg || "删除失败");
      }
    } catch (error) {
      console.error("删除维护记录错误:", error);
      ElMessage.error(error.message || "删除失败");
    }
  });
};

// 重置表单
const resetForm = () => {
  if (maintenanceFormRef.value) {
    maintenanceFormRef.value.resetFields();
  }
  maintenanceForm.maintenanceId = null;
  maintenanceForm.assetId = "";
  maintenanceForm.maintenanceType = "";
  maintenanceForm.maintenanceDate = "";
  maintenanceForm.cost = 0;
  maintenanceForm.provider = "";
  maintenanceForm.notes = "";
  submitting.value = false;
};

// 提交表单
const submitForm = async () => {
  if (!maintenanceFormRef.value) return;

  try {
    await maintenanceFormRef.value.validate();
    submitting.value = true;

    const submitData = {
      maintenanceId:
        dialogType.value === "add" ? null : maintenanceForm.maintenanceId,
      assetId: Number(maintenanceForm.assetId),
      maintenanceType: maintenanceForm.maintenanceType,
      maintenanceDate: maintenanceForm.maintenanceDate,
      cost: parseFloat(maintenanceForm.cost || 0),
      provider: maintenanceForm.provider?.trim() || "",
      notes: maintenanceForm.notes?.trim() || "",
    };

    console.log("准备提交的数据:", JSON.stringify(submitData, null, 2));

    const res = await (dialogType.value === "add"
      ? api.addMaintenance(submitData)
      : api.updateMaintenance(submitData));

    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "add" ? "新增成功" : "修改成功");
      dialogVisible.value = false;
      fetchMaintenanceList();
    } else {
      throw new Error(
        res.data.msg || (dialogType.value === "add" ? "新增失败" : "修改失败")
      );
    }
  } catch (error) {
    console.error("提交表单错误:", error);
    if (error.response?.data?.msg) {
      ElMessage.error(error.response.data.msg);
    } else {
      ElMessage.error(
        error.message || (dialogType.value === "add" ? "新增失败" : "修改失败")
      );
    }
  } finally {
    submitting.value = false;
  }
};

// 修改维护类型文本获取方法
const getMaintenanceTypeText = (type) => {
  const option = maintenanceTypeOptions.find((item) => item.value === type);
  return option ? option.label : type;
};

// 初始化
onMounted(async () => {
  await fetchAssets();
  const assetId = route.query.assetId;
  if (assetId) {
    searchForm.assetId = assetId;
    handleSearch();
  } else {
    fetchMaintenanceList();
  }
});
</script>

<style scoped>
.asset-maintenance {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 资产选择框样式 */
.asset-option {
  padding: 5px 0;
}

.asset-name {
  font-weight: bold;
  margin-bottom: 3px;
}

.asset-info {
  font-size: 12px;
  color: #666;
  display: flex;
  justify-content: space-between;
}

.asset-id {
  margin-left: 15px;
}

:deep(.el-select-dropdown__item) {
  padding: 0 10px;
}

:deep(.el-button) {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

:deep(.el-button .el-icon) {
  margin-right: 2px;
}
</style>
