<template>
  <div class="career-stage">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>职业阶段管理</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>新增阶段
          </el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="职业路径">
          <el-select
            v-model="searchForm.pathId"
            placeholder="请选择"
            clearable
            filterable
            :loading="pathLoading"
            style="width: 200px"
          >
            <el-option
              v-for="item in pathOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="阶段名称">
          <el-input
            v-model="searchForm.stageName"
            placeholder="请输入阶段名称"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item label="级别">
          <el-select
            v-model="searchForm.level"
            placeholder="请选择"
            clearable
            style="width: 120px"
          >
            <el-option label="P1" value="1" />
            <el-option label="P2" value="2" />
            <el-option label="P3" value="3" />
            <el-option label="P4" value="4" />
            <el-option label="P5" value="5" />
          </el-select>
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

      <!-- 阶段列表 -->
      <el-table
        :data="tableData"
        style="width: 100%"
        border
        v-loading="loading"
      >
        <el-table-column prop="pathName" label="职业路径" width="150" />
        <el-table-column prop="stageName" label="阶段名称" width="150" />
        <el-table-column prop="displayLevel" label="级别" width="100" />
        <el-table-column
          prop="requirements"
          label="要求"
          show-overflow-tooltip
        />
        <el-table-column label="操作" width="180" fixed="right">
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
              title="确认删除该职业阶段吗？"
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

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增职业阶段' : '编辑职业阶段'"
      width="500px"
      :close-on-click-modal="false"
      @closed="handleDialogClose"
    >
      <el-form
        ref="stageFormRef"
        :model="stageForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="职业路径" prop="pathId">
          <el-select
            v-model="stageForm.pathId"
            placeholder="请选择"
            filterable
            :loading="pathLoading"
            style="width: 100%"
          >
            <el-option
              v-for="item in pathOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="阶段名称" prop="stageName">
          <el-input
            v-model="stageForm.stageName"
            placeholder="请输入阶段名称"
            maxlength="100"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="级别" prop="level">
          <el-select
            v-model="stageForm.level"
            placeholder="请选择"
            style="width: 100%"
          >
            <el-option label="P1" value="1" />
            <el-option label="P2" value="2" />
            <el-option label="P3" value="3" />
            <el-option label="P4" value="4" />
            <el-option label="P5" value="5" />
          </el-select>
        </el-form-item>
        <el-form-item label="要求" prop="requirements">
          <el-input
            v-model="stageForm.requirements"
            type="textarea"
            :rows="4"
            placeholder="请输入阶段要求"
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

    <!-- 查看对话框 -->
    <el-dialog v-model="viewDialogVisible" title="职业阶段详情" width="500px">
      <div class="stage-content">
        <h3>
          {{ selectedStage?.stageName }} ({{ selectedStage?.displayLevel }})
        </h3>
        <p class="path-name">
          所属路径：{{ getPathName(selectedStage?.pathId) }}
        </p>
        <div class="requirements">
          <h4>阶段要求</h4>
          <p>{{ selectedStage?.requirements }}</p>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import api from "@/api/careerStage";
import careerPathApi from "@/api/careerPath";
import { Plus, Edit, Delete, Search, Refresh } from "@element-plus/icons-vue";

// 搜索表单
const searchForm = reactive({
  pathId: "",
  stageName: "",
  level: "",
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
const viewDialogVisible = ref(false);
const dialogType = ref("add");
const stageFormRef = ref(null);
const selectedStage = ref(null);

// 职业路径选项
const pathOptions = ref([]);
const pathLoading = ref(false);

// 加载职业路径选项
const loadPathOptions = async () => {
  if (pathOptions.value.length > 0) return; // 如果已经加载过，就不再加载

  pathLoading.value = true;
  try {
    const res = await careerPathApi.getCareerPathPage({
      pageNum: 1,
      pageSize: 1000, // 获取足够多的路径数据用于下拉选择
    });
    if (res.data.code === 0) {
      pathOptions.value = res.data.data.list.map((path) => ({
        value: path.pathId,
        label: path.pathName,
      }));
    } else {
      ElMessage.error(res.data.msg || "获取职业路径数据失败");
    }
  } catch (error) {
    console.error("获取职业路径列表失败:", error);
    ElMessage.error(error.message || "获取职业路径数据失败");
  } finally {
    pathLoading.value = false;
  }
};

// 获取路径名称
const getPathName = (pathId) => {
  const path = pathOptions.value.find((p) => p.value === pathId);
  return path ? path.label : "未知路径";
};

// 获取列表数据
const getList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      pathId: searchForm.pathId || undefined,
      level: searchForm.level ? parseInt(searchForm.level) : undefined,
      keyword: searchForm.stageName || undefined,
    };

    const res = await api.getCareerStagePage(params);
    if (res.data.code === 0) {
      const pageInfo = res.data.data;
      // 确保职业路径选项已加载
      await loadPathOptions();
      // 添加路径名称到列表数据中
      tableData.value = pageInfo.list.map((item) => ({
        ...item,
        pathName: getPathName(item.pathId),
        displayLevel: item.level ? `P${item.level}` : "-",
      }));
      total.value = pageInfo.total;
    } else {
      ElMessage.error(res.data.msg || "获取数据失败");
    }
  } catch (error) {
    console.error("获取职业阶段列表失败:", error);
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
  Object.keys(searchForm).forEach((key) => {
    searchForm[key] = "";
  });
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

// 表单数据
const initStageForm = () => ({
  stageId: null,
  pathId: "",
  stageName: "",
  level: "",
  requirements: "",
});

const stageForm = ref(initStageForm());

// 表单规则
const rules = {
  pathId: [{ required: true, message: "请选择职业路径", trigger: "change" }],
  stageName: [{ required: true, message: "请输入阶段名称", trigger: "blur" }],
  level: [{ required: true, message: "请选择级别", trigger: "change" }],
  requirements: [
    { required: true, message: "请输入阶段要求", trigger: "blur" },
  ],
};

// 重置表单
const resetForm = () => {
  Object.assign(stageForm.value, initStageForm());
  if (stageFormRef.value) {
    stageFormRef.value.resetFields();
  }
};

// 表单处理
const handleAdd = async () => {
  // 确保职业路径选项已加载
  await loadPathOptions();
  dialogType.value = "add";
  dialogVisible.value = true;
  resetForm();
};

const handleView = async (row) => {
  try {
    const res = await api.getCareerStageById(row.stageId);
    if (res.data.code === 0) {
      selectedStage.value = res.data.data;
  viewDialogVisible.value = true;
    } else {
      ElMessage.error(res.data.msg || "获取阶段详情失败");
    }
  } catch (error) {
    console.error("获取阶段详情失败:", error);
    ElMessage.error(error.message || "获取阶段详情失败");
  }
};

const handleEdit = async (row) => {
  // 确保职业路径选项已加载
  await loadPathOptions();
  dialogType.value = "edit";
  dialogVisible.value = true;

  try {
    const res = await api.getCareerStageById(row.stageId);
    if (res.data.code === 0) {
      const stageData = res.data.data;
      Object.assign(stageForm.value, {
        ...stageData,
        level: stageData.level ? stageData.level.toString() : "",
      });
    } else {
      ElMessage.error(res.data.msg || "获取阶段详情失败");
    }
  } catch (error) {
    console.error("获取阶段详情失败:", error);
    ElMessage.error(error.message || "获取阶段详情失败");
    dialogVisible.value = false;
  }
};

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm("确认删除该职业阶段吗？", "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
    });

    const res = await api.deleteCareerStage(row.stageId);
    if (res.data.code === 0) {
    ElMessage.success("删除成功");
      getList();
    } else {
      ElMessage.error(res.data.msg || "删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除职业阶段失败:", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

// 提交前的数据处理
const prepareSubmitData = (formData) => {
  return {
    ...formData,
    stageId: formData.stageId ? parseInt(formData.stageId) : 0,
    pathId: parseInt(formData.pathId),
    level: parseInt(formData.level),
  };
};

// 表单提交
const submitForm = async () => {
  if (!stageFormRef.value) return;

  try {
    await stageFormRef.value.validate();
    submitting.value = true;
    const submitApi =
      dialogType.value === "add" ? api.addCareerStage : api.updateCareerStage;

    // 准备提交数据
    const submitData = prepareSubmitData(stageForm.value);
    const res = await submitApi(submitData);

    if (res.data.code === 0) {
      ElMessage.success(dialogType.value === "add" ? "新增成功" : "修改成功");
  dialogVisible.value = false;
      resetForm();
      getList();
    } else {
      ElMessage.error(
        res.data.msg || (dialogType.value === "add" ? "新增失败" : "修改失败")
      );
    }
  } catch (error) {
    console.error("提交职业阶段失败:", error);
    ElMessage.error(error.message || "操作失败");
  } finally {
    submitting.value = false;
  }
};

// 监听对话框关闭
const handleDialogClose = () => {
  resetForm();
};

onMounted(() => {
  loadPathOptions();
  getList();
});
</script>

<style scoped>
.career-stage {
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

.stage-content {
  padding: 20px;
}

.stage-content h3 {
  margin-top: 0;
  color: #303133;
}

.path-name {
  color: #606266;
  margin: 10px 0;
}

.requirements,
.duration {
  margin: 20px 0;
}

.requirements h4,
.duration h4 {
  color: #303133;
  margin-bottom: 10px;
}

.requirements p,
.duration p {
  color: #606266;
  line-height: 1.6;
  white-space: pre-wrap;
}

.metadata {
  color: #909399;
  font-size: 14px;
}

.metadata p {
  margin: 5px 0;
}
</style>
