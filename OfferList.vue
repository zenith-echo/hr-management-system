<template>
  <div class="offer-list">
    <div class="page-header">
      <h2>Offer管理</h2>
      <div class="actions">
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>发放Offer
        </el-button>
      </div>
    </div>

    <!-- 搜索区域 -->
    <el-card class="search-card">
      <el-form :model="searchForm" inline>
        <el-form-item label="应聘者">
          <el-select
            v-model="searchForm.candidateId"
            placeholder="请选择应聘者"
            clearable
          >
            <el-option
              v-for="item in candidateOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="职位">
          <el-select
            v-model="searchForm.positionId"
            placeholder="请选择职位"
            clearable
          >
            <el-option
              v-for="item in positionOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="发放日期">
          <el-date-picker
            v-model="searchForm.offerDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            clearable
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="searchForm.status"
            placeholder="请选择状态"
            clearable
          >
            <el-option label="待接受" value="待接受"></el-option>
            <el-option label="已接受" value="已接受"></el-option>
            <el-option label="已拒绝" value="已拒绝"></el-option>
            <el-option label="已过期" value="已过期"></el-option>
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
    </el-card>

    <!-- 表格区域 -->
    <el-card class="table-card">
      <el-table
        v-loading="loading"
        :data="tableData"
        style="width: 100%"
        border
        stripe
      >
        <el-table-column
          type="index"
          label="序号"
          width="60"
          align="center"
        ></el-table-column>
        <el-table-column
          prop="candidateName"
          label="应聘者"
          width="100"
        ></el-table-column>
        <el-table-column
          prop="positionName"
          label="职位"
          width="120"
        ></el-table-column>
        <el-table-column prop="salary" label="薪资" width="120">
          <template #default="scope">
            {{ formatSalary(scope.row.salary) }}
          </template>
        </el-table-column>
        <el-table-column
          prop="offerDate"
          label="发放日期"
          width="100"
        ></el-table-column>
        <el-table-column
          prop="expiryDate"
          label="过期日期"
          width="100"
        ></el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)" size="small">
              {{ scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              link
              @click="handleEdit(scope.row)"
              v-if="scope.row.status === '待接受'"
            >
              <el-icon><Edit /></el-icon>编辑
            </el-button>
            <el-button type="info" link @click="handleView(scope.row)">
              <el-icon><View /></el-icon>查看
            </el-button>
            <el-button
              type="success"
              link
              @click="handleAccept(scope.row)"
              v-if="scope.row.status === '待接受'"
            >
              <el-icon><Check /></el-icon>接受
            </el-button>
            <el-button
              type="danger"
              link
              @click="handleReject(scope.row)"
              v-if="scope.row.status === '待接受'"
            >
              <el-icon><Close /></el-icon>拒绝
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
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        ></el-pagination>
      </div>
    </el-card>

    <!-- Offer表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="
        dialogType === 'add'
          ? '发放Offer'
          : dialogType === 'edit'
          ? '编辑Offer'
          : '查看Offer'
      "
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="offerFormRef"
        :model="offerForm"
        :rules="offerRules"
        label-width="100px"
      >
        <el-form-item label="应聘者" prop="candidateId">
          <el-select
            v-model="offerForm.candidateId"
            placeholder="请选择应聘者"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          >
            <el-option
              v-for="item in candidateOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="职位" prop="positionId">
          <el-select
            v-model="offerForm.positionId"
            placeholder="请选择职位"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          >
            <el-option
              v-for="item in positionOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="薪资" prop="salary">
          <el-input-number
            v-model="offerForm.salary"
            :min="0"
            :step="1000"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          ></el-input-number>
        </el-form-item>
        <el-form-item label="发放日期" prop="offerDate">
          <el-date-picker
            v-model="offerForm.offerDate"
            type="date"
            placeholder="请选择发放日期"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="过期日期" prop="expiryDate">
          <el-date-picker
            v-model="offerForm.expiryDate"
            type="date"
            placeholder="请选择过期日期"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input
            v-model="offerForm.remark"
            type="textarea"
            rows="3"
            placeholder="请输入备注"
            :disabled="dialogType === 'view'"
          ></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button
            type="primary"
            @click="submitForm"
            v-if="dialogType !== 'view'"
          >
            确定
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue";
import {
  Plus,
  Edit,
  Delete,
  Search,
  Refresh,
  View,
  Close,
  Check,
} from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";

// 表格数据
const loading = ref(false);
const tableData = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 搜索表单
const searchForm = reactive({
  candidateId: "",
  positionId: "",
  offerDate: "",
  status: "",
});

// Offer表单
const dialogVisible = ref(false);
const dialogType = ref("add");
const offerFormRef = ref(null);
const offerForm = reactive({
  offerId: "",
  candidateId: "",
  postingId: "",
  positionId: "",
  salary: 0,
  offerDate: "",
  expiryDate: "",
  status: "待接受",
  remark: "",
});

// 选项数据
const candidateOptions = ref([]);
const positionOptions = ref([]);

// 表单验证规则
const offerRules = {
  candidateId: [{ required: true, message: "请选择应聘者", trigger: "change" }],
  positionId: [{ required: true, message: "请选择职位", trigger: "change" }],
  salary: [{ required: true, message: "请输入薪资", trigger: "blur" }],
  offerDate: [{ required: true, message: "请选择发放日期", trigger: "change" }],
  expiryDate: [
    { required: true, message: "请选择过期日期", trigger: "change" },
  ],
};

// 获取状态对应的标签类型
const getStatusType = (status) => {
  const statusMap = {
    待接受: "warning",
    已接受: "success",
    已拒绝: "danger",
    已过期: "info",
  };
  return statusMap[status] || "";
};

// 格式化薪资
const formatSalary = (salary) => {
  return `￥${salary.toLocaleString()}`;
};

// 获取Offer列表
const getOfferList = async () => {
  loading.value = true;
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      const mockData = Array.from({ length: 10 }, (_, index) => ({
        offerId: `${index + 1}`,
        candidateId: `${index + 1}`,
        candidateName: `候选人${index + 1}`,
        postingId: `${index + 1}`,
        positionId: `${index + 1}`,
        positionName: ["前端工程师", "后端工程师", "产品经理"][index % 3],
        salary: 150000 + index * 10000,
        offerDate: "2024-03-15",
        expiryDate: "2024-03-30",
        status: ["待接受", "已接受", "已拒绝", "已过期"][index % 4],
        remark: "无",
      }));

      tableData.value = mockData;
      total.value = 100;
      loading.value = false;
    }, 500);
  } catch (error) {
    console.error("获取Offer列表失败", error);
    loading.value = false;
  }
};

// 获取应聘者列表
const getCandidateList = async () => {
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      candidateOptions.value = Array.from({ length: 10 }, (_, index) => ({
        value: `${index + 1}`,
        label: `候选人${index + 1}`,
      }));
    }, 300);
  } catch (error) {
    console.error("获取应聘者列表失败", error);
  }
};

// 获取职位列表
const getPositionList = async () => {
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      positionOptions.value = [
        { value: "1", label: "前端工程师" },
        { value: "2", label: "后端工程师" },
        { value: "3", label: "产品经理" },
      ];
    }, 300);
  } catch (error) {
    console.error("获取职位列表失败", error);
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getOfferList();
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
  getOfferList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getOfferList();
};

// 处理添加Offer
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(offerForm).forEach((key) => {
    if (key === "salary") {
      offerForm[key] = 0;
    } else if (key === "status") {
      offerForm[key] = "待接受";
    } else {
      offerForm[key] = "";
    }
  });

  // 下一个事件循环重置表单验证
  setTimeout(() => {
    offerFormRef.value?.resetFields();
  });
};

// 处理编辑Offer
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(offerForm).forEach((key) => {
    offerForm[key] = row[key];
  });
};

// 处理查看Offer
const handleView = (row) => {
  dialogType.value = "view";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(offerForm).forEach((key) => {
    offerForm[key] = row[key];
  });
};

// 处理接受Offer
const handleAccept = (row) => {
  ElMessageBox.confirm("确定要接受此Offer吗？", "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "info",
  })
    .then(() => {
      // 这里应该调用API接受Offer
      ElMessage.success("操作成功");
      getOfferList();
    })
    .catch(() => {});
};

// 处理拒绝Offer
const handleReject = (row) => {
  ElMessageBox.confirm("确定要拒绝此Offer吗？", "警告", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(() => {
      // 这里应该调用API拒绝Offer
      ElMessage.success("操作成功");
      getOfferList();
    })
    .catch(() => {});
};

// 提交表单
const submitForm = () => {
  offerFormRef.value.validate((valid) => {
    if (valid) {
      if (dialogType.value === "add") {
        // 这里应该调用API添加数据
        ElMessage.success("添加成功");
      } else if (dialogType.value === "edit") {
        // 这里应该调用API更新数据
        ElMessage.success("更新成功");
      }
      dialogVisible.value = false;
      getOfferList();
    }
  });
};

// 页面加载时获取数据
onMounted(() => {
  getOfferList();
  getCandidateList();
  getPositionList();
});
</script>

<style scoped>
.offer-list {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h2 {
  margin: 0;
  font-size: 20px;
}

.search-card {
  margin-bottom: 20px;
}

.table-card {
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
