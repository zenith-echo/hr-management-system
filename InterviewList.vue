<template>
  <div class="interview-list">
    <div class="page-header">
      <h2>面试管理</h2>
      <div class="actions">
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>安排面试
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
            v-model="searchForm.jobId"
            placeholder="请选择职位"
            clearable
          >
            <el-option
              v-for="item in jobOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="面试官">
          <el-select
            v-model="searchForm.interviewerId"
            placeholder="请选择面试官"
            clearable
          >
            <el-option
              v-for="item in interviewerOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="日期">
          <el-date-picker
            v-model="searchForm.date"
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
            <el-option label="待面试" value="待面试"></el-option>
            <el-option label="已完成" value="已完成"></el-option>
            <el-option label="已取消" value="已取消"></el-option>
            <el-option label="爽约" value="爽约"></el-option>
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
          prop="jobTitle"
          label="应聘职位"
          width="120"
        ></el-table-column>
        <el-table-column
          prop="interviewerName"
          label="面试官"
          width="100"
        ></el-table-column>
        <el-table-column
          prop="interviewDate"
          label="面试日期"
          width="100"
        ></el-table-column>
        <el-table-column
          prop="interviewTime"
          label="面试时间"
          width="100"
        ></el-table-column>
        <el-table-column prop="interviewType" label="面试方式" width="100">
          <template #default="scope">
            <el-tag
              :type="scope.row.interviewType === '现场' ? 'success' : 'info'"
              size="small"
            >
              {{ scope.row.interviewType }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)" size="small">
              {{ scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="result" label="面试结果" width="100">
          <template #default="scope">
            <el-tag
              v-if="scope.row.result"
              :type="getResultType(scope.row.result)"
              size="small"
            >
              {{ scope.row.result }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="280" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              link
              @click="handleEdit(scope.row)"
              v-if="scope.row.status === '待面试'"
            >
              <el-icon><Edit /></el-icon>编辑
            </el-button>
            <el-button
              type="success"
              link
              @click="handleRecord(scope.row)"
              v-if="scope.row.status === '待面试'"
            >
              <el-icon><DocumentAdd /></el-icon>记录结果
            </el-button>
            <el-button type="info" link @click="handleView(scope.row)">
              <el-icon><View /></el-icon>查看
            </el-button>
            <el-popconfirm
              title="确定要取消此面试吗？"
              @confirm="handleCancel(scope.row)"
              v-if="scope.row.status === '待面试'"
            >
              <template #reference>
                <el-button type="danger" link>
                  <el-icon><Close /></el-icon>取消
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
        ></el-pagination>
      </div>
    </el-card>

    <!-- 面试表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="
        dialogType === 'add'
          ? '安排面试'
          : dialogType === 'edit'
          ? '编辑面试'
          : '查看面试'
      "
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="interviewFormRef"
        :model="interviewForm"
        :rules="interviewRules"
        label-width="100px"
      >
        <el-form-item label="应聘者" prop="candidateId">
          <el-select
            v-model="interviewForm.candidateId"
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
        <el-form-item label="应聘职位" prop="jobId">
          <el-select
            v-model="interviewForm.jobId"
            placeholder="请选择职位"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          >
            <el-option
              v-for="item in jobOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="面试官" prop="interviewerId">
          <el-select
            v-model="interviewForm.interviewerId"
            placeholder="请选择面试官"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          >
            <el-option
              v-for="item in interviewerOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="面试日期" prop="interviewDate">
          <el-date-picker
            v-model="interviewForm.interviewDate"
            type="date"
            placeholder="请选择面试日期"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="面试时间" prop="interviewTime">
          <el-time-picker
            v-model="interviewForm.interviewTime"
            placeholder="请选择面试时间"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          ></el-time-picker>
        </el-form-item>
        <el-form-item label="面试方式" prop="interviewType">
          <el-radio-group
            v-model="interviewForm.interviewType"
            :disabled="dialogType === 'view'"
          >
            <el-radio label="现场">现场面试</el-radio>
            <el-radio label="视频">视频面试</el-radio>
            <el-radio label="电话">电话面试</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input
            v-model="interviewForm.remark"
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

    <!-- 面试结果记录对话框 -->
    <el-dialog
      v-model="recordDialogVisible"
      title="记录面试结果"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="recordFormRef"
        :model="recordForm"
        :rules="recordRules"
        label-width="100px"
      >
        <el-form-item label="面试结果" prop="result">
          <el-radio-group v-model="recordForm.result">
            <el-radio label="通过">通过</el-radio>
            <el-radio label="待定">待定</el-radio>
            <el-radio label="不通过">不通过</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="评分" prop="score">
          <el-rate
            v-model="recordForm.score"
            :max="5"
            :texts="['不合格', '待提高', '合格', '良好', '优秀']"
            show-text
          ></el-rate>
        </el-form-item>
        <el-form-item label="评价" prop="evaluation">
          <el-input
            v-model="recordForm.evaluation"
            type="textarea"
            rows="3"
            placeholder="请输入面试评价"
          ></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="recordDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitRecord">确定</el-button>
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
  DocumentAdd,
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
  jobId: "",
  interviewerId: "",
  date: "",
  status: "",
});

// 面试表单
const dialogVisible = ref(false);
const dialogType = ref("add");
const interviewFormRef = ref(null);
const interviewForm = reactive({
  interviewId: "",
  candidateId: "",
  jobId: "",
  interviewerId: "",
  interviewDate: "",
  interviewTime: "",
  interviewType: "现场",
  status: "待面试",
  remark: "",
});

// 面试结果表单
const recordDialogVisible = ref(false);
const recordFormRef = ref(null);
const recordForm = reactive({
  interviewId: "",
  result: "",
  score: 0,
  evaluation: "",
});

// 选项数据
const candidateOptions = ref([]);
const jobOptions = ref([]);
const interviewerOptions = ref([]);

// 表单验证规则
const interviewRules = {
  candidateId: [{ required: true, message: "请选择应聘者", trigger: "change" }],
  jobId: [{ required: true, message: "请选择职位", trigger: "change" }],
  interviewerId: [
    { required: true, message: "请选择面试官", trigger: "change" },
  ],
  interviewDate: [
    { required: true, message: "请选择面试日期", trigger: "change" },
  ],
  interviewTime: [
    { required: true, message: "请选择面试时间", trigger: "change" },
  ],
  interviewType: [
    { required: true, message: "请选择面试方式", trigger: "change" },
  ],
};

const recordRules = {
  result: [{ required: true, message: "请选择面试结果", trigger: "change" }],
  score: [{ required: true, message: "请评分", trigger: "change" }],
  evaluation: [{ required: true, message: "请输入面试评价", trigger: "blur" }],
};

// 获取状态对应的标签类型
const getStatusType = (status) => {
  const statusMap = {
    待面试: "warning",
    已完成: "success",
    已取消: "info",
    爽约: "danger",
  };
  return statusMap[status] || "";
};

// 获取结果对应的标签类型
const getResultType = (result) => {
  const resultMap = {
    通过: "success",
    待定: "warning",
    不通过: "danger",
  };
  return resultMap[result] || "";
};

// 获取面试列表
const getInterviewList = async () => {
  loading.value = true;
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      const mockData = Array.from({ length: 10 }, (_, index) => ({
        interviewId: `${index + 1}`,
        candidateId: `${index + 1}`,
        candidateName: `候选人${index + 1}`,
        jobId: `${index + 1}`,
        jobTitle: ["前端工程师", "后端工程师", "产品经理"][index % 3],
        interviewerId: `${index + 1}`,
        interviewerName: `面试官${index + 1}`,
        interviewDate: "2024-03-15",
        interviewTime: "14:00:00",
        interviewType: ["现场", "视频", "电话"][index % 3],
        status: ["待面试", "已完成", "已取消", "爽约"][index % 4],
        result: index % 4 === 1 ? ["通过", "待定", "不通过"][index % 3] : "",
        remark: "无",
      }));

      tableData.value = mockData;
      total.value = 100;
      loading.value = false;
    }, 500);
  } catch (error) {
    console.error("获取面试列表失败", error);
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
const getJobList = async () => {
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      jobOptions.value = [
        { value: "1", label: "前端工程师" },
        { value: "2", label: "后端工程师" },
        { value: "3", label: "产品经理" },
      ];
    }, 300);
  } catch (error) {
    console.error("获取职位列表失败", error);
  }
};

// 获取面试官列表
const getInterviewerList = async () => {
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      interviewerOptions.value = Array.from({ length: 5 }, (_, index) => ({
        value: `${index + 1}`,
        label: `面试官${index + 1}`,
      }));
    }, 300);
  } catch (error) {
    console.error("获取面试官列表失败", error);
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getInterviewList();
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
  getInterviewList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getInterviewList();
};

// 处理添加面试
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(interviewForm).forEach((key) => {
    if (key === "interviewType") {
      interviewForm[key] = "现场";
    } else if (key === "status") {
      interviewForm[key] = "待面试";
    } else {
      interviewForm[key] = "";
    }
  });

  // 下一个事件循环重置表单验证
  setTimeout(() => {
    interviewFormRef.value?.resetFields();
  });
};

// 处理编辑面试
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(interviewForm).forEach((key) => {
    interviewForm[key] = row[key];
  });
};

// 处理查看面试
const handleView = (row) => {
  dialogType.value = "view";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(interviewForm).forEach((key) => {
    interviewForm[key] = row[key];
  });
};

// 处理记录结果
const handleRecord = (row) => {
  recordDialogVisible.value = true;
  recordForm.interviewId = row.interviewId;
  recordForm.result = "";
  recordForm.score = 0;
  recordForm.evaluation = "";
};

// 处理取消面试
const handleCancel = (row) => {
  ElMessageBox.confirm("确定要取消此面试吗？", "警告", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(() => {
      // 这里应该调用API取消面试
      ElMessage.success("取消成功");
      getInterviewList();
    })
    .catch(() => {});
};

// 提交面试表单
const submitForm = () => {
  interviewFormRef.value.validate((valid) => {
    if (valid) {
      if (dialogType.value === "add") {
        // 这里应该调用API添加数据
        ElMessage.success("添加成功");
      } else if (dialogType.value === "edit") {
        // 这里应该调用API更新数据
        ElMessage.success("更新成功");
      }
      dialogVisible.value = false;
      getInterviewList();
    }
  });
};

// 提交面试结果
const submitRecord = () => {
  recordFormRef.value.validate((valid) => {
    if (valid) {
      // 这里应该调用API提交面试结果
      ElMessage.success("提交成功");
      recordDialogVisible.value = false;
      getInterviewList();
    }
  });
};

// 页面加载时获取数据
onMounted(() => {
  getInterviewList();
  getCandidateList();
  getJobList();
  getInterviewerList();
});
</script>

<style scoped>
.interview-list {
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

:deep(.el-rate__text) {
  font-size: 12px;
}
</style>
