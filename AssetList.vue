<template>
  <page-container title="资产管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>新增资产
      </el-button>
    </template>

    <!-- 搜索栏 -->
    <template #search>
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="资产编号">
          <el-input
            v-model="searchForm.assetId"
            placeholder="请输入资产编号"
            type="number"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item label="资产名称">
          <el-input
            v-model="searchForm.name"
            placeholder="请输入资产名称"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item label="资产类型">
          <el-select
            v-model="searchForm.assetType"
            placeholder="请选择资产类型"
            clearable
            filterable
            style="width: 150px"
          >
            <el-option
              v-for="type in assetTypes"
              :key="type"
              :label="type"
              :value="type"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="价格区间">
          <el-input-number
            v-model="searchForm.price1"
            placeholder="最低价格"
            :precision="2"
            :step="100"
            :min="0"
            style="width: 150px"
          />
          <span class="mx-2">-</span>
          <el-input-number
            v-model="searchForm.price2"
            placeholder="最高价格"
            :precision="2"
            :step="100"
            :min="0"
            style="width: 150px"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>搜索
          </el-button>
          <el-button @click="resetSearch">
            <el-icon><Refresh /></el-icon>重置
          </el-button>
        </el-form-item>
      </el-form>
    </template>

    <!-- 表格内容 -->
    <el-table
      :data="tableData"
      style="width: 100%"
      border
      stripe
      v-loading="loading"
    >
      <el-table-column
        prop="assetId"
        label="资产编号"
        width="100"
        align="center"
      />
      <el-table-column
        prop="assetName"
        label="资产名称"
        min-width="120"
        show-overflow-tooltip
      />
      <el-table-column
        prop="assetType"
        label="资产类型"
        width="120"
        align="center"
      >
        <template #default="scope">
          <el-tag size="small" effect="plain">{{ scope.row.assetType }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="purchaseDate"
        label="购买日期"
        width="120"
        align="center"
      />
      <el-table-column
        prop="purchasePrice"
        label="购买价格"
        width="120"
        align="right"
      >
        <template #default="scope">
          ¥{{
            Number(scope.row.purchasePrice).toLocaleString("zh-CN", {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            })
          }}
        </template>
      </el-table-column>
      <el-table-column
        prop="supplier"
        label="供应商"
        min-width="120"
        show-overflow-tooltip
      />
      <el-table-column
        prop="warrantyEnd"
        label="保修期至"
        width="150"
        align="center"
      >
        <template #default="scope">
          <el-tooltip
            :content="getWarrantyStatus(scope.row.warrantyEnd).text"
            placement="top"
          >
            <el-tag
              :type="getWarrantyStatus(scope.row.warrantyEnd).type"
              effect="light"
              size="small"
            >
              {{ scope.row.warrantyEnd || "未设置" }}
              <el-icon
                v-if="getWarrantyStatus(scope.row.warrantyEnd).type !== 'info'"
                class="ml-1"
              >
                <component :is="getWarrantyStatusIcon(scope.row.warrantyEnd)" />
              </el-icon>
            </el-tag>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="120" fixed="right" align="center">
        <template #default="scope">
          <el-button-group>
            <el-tooltip content="编辑" placement="top">
              <el-button type="primary" link @click="handleEdit(scope.row)">
                <el-icon><Edit /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="删除" placement="top">
              <div>
                <el-popconfirm
                  title="确认删除该资产记录吗？"
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

    <!-- 新增/编辑资产对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增资产' : '编辑资产'"
      width="500px"
      :close-on-click-modal="false"
      @closed="resetForm"
    >
      <el-form
        ref="assetFormRef"
        :model="assetForm"
        :rules="rules"
        label-width="100px"
        :validate-on-rule-change="false"
      >
        <el-form-item label="资产名称" prop="assetName">
          <el-input
            v-model="assetForm.assetName"
            placeholder="请输入资产名称"
            maxlength="100"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="资产类型" prop="assetType">
          <el-select
            v-model="assetForm.assetType"
            placeholder="请选择资产类型"
            filterable
            allow-create
            style="width: 100%"
          >
            <el-option
              v-for="type in assetTypes"
              :key="type"
              :label="type"
              :value="type"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="购买日期" prop="purchaseDate">
          <el-date-picker
            v-model="assetForm.purchaseDate"
            type="date"
            placeholder="选择日期"
            value-format="YYYY-MM-DD"
            :disabled-date="(time) => time > new Date()"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="购买价格" prop="purchasePrice">
          <el-input-number
            v-model="assetForm.purchasePrice"
            :precision="2"
            :step="100"
            :min="0"
            :max="9999999.99"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="供应商" prop="supplier">
          <el-input
            v-model="assetForm.supplier"
            placeholder="请输入供应商"
            maxlength="100"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="保修期至" prop="warrantyEnd">
          <el-date-picker
            v-model="assetForm.warrantyEnd"
            type="date"
            placeholder="选择日期"
            value-format="YYYY-MM-DD"
            :disabled-date="(time) => time < new Date(assetForm.purchaseDate)"
            style="width: 100%"
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
import { ref, reactive } from "vue";
import { ElMessage } from "element-plus";
import api from "../../api/asset";
import { Plus, Edit, Delete, Search, Refresh } from "@element-plus/icons-vue";
import PageContainer from "../../components/PageContainer.vue";
import { Warning, CircleCheck, CircleClose } from "@element-plus/icons-vue";

// 搜索表单
const searchForm = reactive({
  assetId: "",
  name: "",
  assetType: "",
  price1: null,
  price2: null,
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
const assetFormRef = ref();
const assetForm = reactive({
  assetId: null,
  assetName: "",
  assetType: "",
  purchaseDate: "",
  purchasePrice: 0,
  supplier: "",
  warrantyEnd: "",
});

// 表单验证规则
const rules = {
  assetName: [
    { required: true, message: "请输入资产名称", trigger: "blur" },
    { max: 100, message: "资产名称不能超过100个字符", trigger: "blur" },
  ],
  assetType: [
    { required: true, message: "请输入资产类型", trigger: "blur" },
    { max: 50, message: "资产类型不能超过50个字符", trigger: "blur" },
  ],
  purchaseDate: [
    { required: true, message: "请选择购买日期", trigger: "change" },
  ],
  purchasePrice: [
    { required: true, message: "请输入购买价格", trigger: "change" },
    {
      validator: (rule, value, callback) => {
        if (value < 0 || value > 9999999.99) {
          callback(new Error("购买价格必须在0-9999999.99之间"));
        } else {
          callback();
        }
      },
      trigger: "change",
    },
  ],
  supplier: [
    { required: true, message: "请输入供应商", trigger: "blur" },
    { max: 100, message: "供应商不能超过100个字符", trigger: "blur" },
  ],
  warrantyEnd: [{ required: true, message: "请选择保修期", trigger: "change" }],
};

// 资产类型列表
const assetTypes = ref([
  "办公设备",
  "电子设备",
  "家具",
  "运输设备",
  "其他设备",
]);

// 计算保修状态
const getWarrantyStatus = (warrantyEnd) => {
  if (!warrantyEnd) return { type: "info", text: "未设置" };

  const now = new Date();
  const end = new Date(warrantyEnd);
  const diffDays = Math.ceil((end - now) / (1000 * 60 * 60 * 24));

  if (diffDays < 0) {
    return { type: "danger", text: "已过期" };
  } else if (diffDays <= 30) {
    return { type: "warning", text: "即将到期" };
  } else {
    return { type: "success", text: "保修中" };
  }
};

// 获取保修状态图标
const getWarrantyStatusIcon = (warrantyEnd) => {
  const status = getWarrantyStatus(warrantyEnd);
  switch (status.type) {
    case "danger":
      return CircleClose;
    case "warning":
      return Warning;
    case "success":
      return CircleCheck;
    default:
      return null;
  }
};

// 获取资产列表
const fetchAssets = async () => {
  loading.value = true;
  try {
    const params = {
      id: searchForm.assetId ? parseInt(searchForm.assetId) : undefined,
      name: searchForm.name || undefined,
      type: searchForm.assetType || undefined,
      price1: searchForm.price1 ? parseFloat(searchForm.price1) : undefined,
      price2: searchForm.price2 ? parseFloat(searchForm.price2) : undefined,
      pageNum: currentPage.value,
      pageSize: pageSize.value,
    };

    // 如果设置了price1，但没有设置price2，则将price2设置为一个较大的值
    if (params.price1 !== undefined && params.price2 === undefined) {
      params.price2 = 9999999.99;
    }
    // 如果设置了price2，但没有设置price1，则将price1设置为0
    if (params.price2 !== undefined && params.price1 === undefined) {
      params.price1 = 0;
    }

    console.log("查询参数:", params);

    const res = await api.getAssetsPage(params);
    if (res.data.code === 0) {
      console.log("查询结果:", res.data.data);
      // 处理分页数据
      tableData.value = res.data.data.list || [];
      total.value = res.data.data.total || 0;
    } else {
      throw new Error(res.data.msg || "获取资产列表失败");
    }
  } catch (error) {
    console.error("获取资产列表错误:", error);
    ElMessage.error(error.message || "获取资产列表失败");
    tableData.value = [];
    total.value = 0;
  } finally {
    loading.value = false;
  }
};

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1;
  fetchAssets();
};

const resetSearch = () => {
  searchForm.assetId = "";
  searchForm.name = "";
  searchForm.assetType = "";
  searchForm.price1 = null;
  searchForm.price2 = null;
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  fetchAssets();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  fetchAssets();
};

// 重置表单
const resetForm = () => {
  if (assetFormRef.value) {
    assetFormRef.value.resetFields();
  }
  Object.assign(assetForm, {
    assetId: null,
    assetName: "",
    assetType: "",
    purchaseDate: "",
    purchasePrice: 0,
    supplier: "",
    warrantyEnd: "",
  });
};

// 新增资产
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  resetForm();
};

// 编辑资产
const handleEdit = async (row) => {
  try {
    const res = await api.getAssetById(row.assetId);
    if (res.data.code === 0) {
      dialogType.value = "edit";
      dialogVisible.value = true;
      Object.assign(assetForm, res.data.data);
    } else {
      throw new Error(res.data.msg || "获取资产详情失败");
    }
  } catch (error) {
    console.error("获取资产详情错误:", error);
    ElMessage.error(error.message || "获取资产详情失败");
  }
};

// 删除资产
const handleDelete = async (row) => {
  try {
    const res = await api.deleteAsset(row.assetId);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      fetchAssets();
    } else {
      throw new Error(res.data.msg || "删除失败");
    }
  } catch (error) {
    console.error("删除资产错误:", error);
    ElMessage.error(error.message || "删除失败");
  }
};

// 提交表单
const submitForm = async () => {
  if (!assetFormRef.value) return;

  try {
    await assetFormRef.value.validate();
    submitting.value = true;

    const submitData = {
      ...assetForm,
      assetName: assetForm.assetName.trim(),
      assetType: assetForm.assetType.trim(),
      supplier: assetForm.supplier.trim(),
      purchasePrice: parseFloat(assetForm.purchasePrice).toFixed(2),
    };

    // 如果是新增，删除assetId字段
    if (dialogType.value === "add") {
      delete submitData.assetId;
    }

    console.log("提交数据:", submitData);

    const res = await (dialogType.value === "add"
      ? api.addAsset(submitData)
      : api.updateAsset(submitData));

    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "add" ? "新增成功" : "修改成功");
      dialogVisible.value = false;
      fetchAssets();
    } else {
      throw new Error(
        res.data.msg || (dialogType.value === "add" ? "新增失败" : "修改失败")
      );
    }
  } catch (error) {
    console.error("提交表单错误:", error);
    ElMessage.error(
      error.message || (dialogType.value === "add" ? "新增失败" : "修改失败")
    );
  } finally {
    submitting.value = false;
  }
};

// 初始加载
fetchAssets();
</script>

<style scoped>
.mx-2 {
  margin: 0 8px;
}

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

.ml-1 {
  margin-left: 4px;
}

:deep(.el-tag .el-icon) {
  vertical-align: middle;
}
</style>
