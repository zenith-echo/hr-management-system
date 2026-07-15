<template>
  <page-container title="福利计划">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>新建福利计划
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="关键词">
          <el-input
            v-model="searchForm.keyword"
            placeholder="请输入计划名称/描述"
            clearable
          />
        </el-form-item>
        <el-form-item label="计划日期">
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
    <el-table :data="planList" border v-loading="loading">
      <el-table-column prop="planName" label="计划名称" />
      <el-table-column prop="description" label="描述" show-overflow-tooltip />
      <el-table-column prop="startDate" label="生效日期" width="120" />
      <el-table-column prop="endDate" label="结束日期" width="120" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
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
      :title="dialogType === 'add' ? '新建福利计划' : '编辑福利计划'"
      width="500px"
    >
      <el-form
        ref="planFormRef"
        :model="planForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="计划名称" prop="planName">
          <el-input v-model="planForm.planName" placeholder="请输入计划名称" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="planForm.description"
            type="textarea"
            placeholder="请输入描述"
          />
        </el-form-item>
        <el-form-item label="计划日期" prop="dateRange">
          <el-date-picker
            v-model="planForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
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
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { Plus, Edit, Delete } from "@element-plus/icons-vue";
import PageContainer from "@/components/PageContainer.vue";
import api from "@/api/benefitsPlan";

// 搜索表单
const searchForm = reactive({
  keyword: "",
  dateRange: [],
});

// 列表数据
const planList = ref([]);
const loading = ref(false);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 对话框控制
const dialogVisible = ref(false);
const dialogType = ref("add");
const planFormRef = ref(null);
const planForm = reactive({
  benefitsplanId: null,
  planName: "",
  description: "",
  dateRange: [],
});

// 表单验证规则
const rules = {
  planName: [{ required: true, message: "请输入计划名称", trigger: "blur" }],
  description: [{ required: true, message: "请输入描述", trigger: "blur" }],
  dateRange: [{ required: true, message: "请选择计划日期", trigger: "change" }],
};

// 获取福利计划列表
const getPlanList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      keyword: searchForm.keyword,
      startDate: searchForm.dateRange?.[0],
      endDate: searchForm.dateRange?.[1],
    };

    const res = await api.getBenefitsPlanList(params);
    if (res.data.code === 0) {
      const pageInfo = res.data.data;
      planList.value = pageInfo.list;
      total.value = pageInfo.total;
    } else {
      ElMessage.error(res.data.msg || "获取数据失败");
    }
  } catch (error) {
    ElMessage.error(error.message || "获取数据失败");
  } finally {
    loading.value = false;
  }
};

// 搜索和重置
const handleSearch = () => {
  currentPage.value = 1;
  getPlanList();
};

const resetSearch = () => {
  searchForm.keyword = "";
  searchForm.dateRange = [];
  handleSearch();
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  getPlanList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  getPlanList();
};

// 新增福利计划
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;
  // 重置表单数据
  planForm.benefitsplanId = null;
  planForm.planName = "";
  planForm.description = "";
  planForm.dateRange = [];
  // 如果表单引用存在，重置验证
  if (planFormRef.value) {
    planFormRef.value.resetFields();
  }
};

// 编辑福利计划
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;
  planForm.planName = row.planName;
  planForm.description = row.description;
  planForm.dateRange = [row.startDate, row.endDate];
  planForm.benefitsplanId = row.benefitsplanId;
};

// 删除福利计划
const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该福利计划吗？", "提示", {
    type: "warning",
  })
    .then(async () => {
      try {
        const res = await api.deleteBenefitsPlan(row.benefitsplanId);
        if (res.data.code === 0) {
          ElMessage.success(res.data.msg || "删除成功");
          getPlanList();
        } else {
          ElMessage.error(res.data.msg || "删除失败");
        }
      } catch (error) {
        ElMessage.error(error.message || "删除失败");
      }
    })
    .catch(() => {});
};

// 提交表单
const handleSubmit = async () => {
  if (!planFormRef.value) return;

  await planFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const data = {
          planName: planForm.planName,
          description: planForm.description,
          startDate: planForm.dateRange[0],
          endDate: planForm.dateRange[1],
        };

        if (dialogType.value === "edit") {
          if (!planForm.benefitsplanId) {
            ElMessage.error("缺少必要的ID信息");
            return;
          }
          data.benefitsplanId = planForm.benefitsplanId;
        }

        console.log("提交的表单数据:", {
          type: dialogType.value,
          formData: planForm,
          submitData: data,
        });

        const apiCall =
          dialogType.value === "add"
            ? api.addBenefitsPlan
            : api.updateBenefitsPlan;

        const res = await apiCall(data);
        if (res.data.code === 0) {
          ElMessage.success(
            res.data.msg ||
              (dialogType.value === "add" ? "创建成功" : "更新成功")
          );
          dialogVisible.value = false;
          getPlanList();
        } else {
          throw new Error(
            res.data.msg ||
              (dialogType.value === "add" ? "创建失败" : "更新失败")
          );
        }
      } catch (error) {
        console.error("提交表单错误:", error);
        ElMessage.error(
          error.message ||
            (dialogType.value === "add" ? "创建失败" : "更新失败")
        );
      }
    }
  });
};

onMounted(() => {
  getPlanList();
});
</script>

<style scoped>
.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
