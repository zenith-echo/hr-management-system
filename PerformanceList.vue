<template>
  <page-container title="绩效评估">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>新增评估
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="员工">
          <el-select
            v-model="searchForm.employeeId"
            placeholder="请选择员工"
            clearable
            filterable
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="评估日期">
          <el-date-picker
            v-model="searchForm.date"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
            clearable
          />
        </el-form-item>
        <el-form-item label="等级">
          <el-select
            v-model="searchForm.level"
            placeholder="请选择等级"
            clearable
          >
            <template #prefix v-if="searchForm.level">
              <el-tag
                :type="getLevelType(searchForm.level)"
                effect="light"
                round
                size="small"
                style="margin-right: 8px"
              >
                {{ searchForm.level }}
              </el-tag>
            </template>
            <el-option
              v-for="level in levelOptions"
              :key="level.value"
              :label="level.label"
              :value="level.value"
            >
              <el-tag
                :type="getLevelType(level.value)"
                effect="light"
                round
                size="small"
                style="margin-right: 8px"
              >
                {{ level.label }}
              </el-tag>
            </el-option>
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
      <el-table-column prop="employeeName" label="员工姓名" width="120" />
      <el-table-column prop="startDate" label="开始日期" width="120" />
      <el-table-column prop="endDate" label="结束日期" width="120" />
      <el-table-column prop="score" label="评分" width="80" align="center">
        <template #default="scope">
          <span :class="getScoreClass(scope.row.score)">{{
            scope.row.score
          }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="level" label="等级" width="100" align="center">
        <template #default="scope">
          <el-tag
            :type="getLevelType(scope.row.level)"
            effect="light"
            round
            size="small"
          >
            {{ scope.row.level }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="evaluatorName" label="评估人" width="120" />
      <el-table-column
        prop="comments"
        label="评语"
        min-width="200"
        show-overflow-tooltip
      />
      <el-table-column label="操作" width="120" fixed="right" align="center">
        <template #default="scope">
          <el-button-group>
            <el-tooltip content="编辑" placement="top">
              <el-button type="primary" link @click="handleEdit(scope.row)">
                <el-icon><Edit /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="查看" placement="top">
              <el-button type="info" link @click="handleView(scope.row)">
                <el-icon><View /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="删除" placement="top">
              <el-button type="danger" link @click="handleDelete(scope.row)">
                <el-icon><Delete /></el-icon>
              </el-button>
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

    <!-- 评估表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <el-form
        ref="performanceFormRef"
        :model="performanceForm"
        :rules="dialogType !== 'view' ? performanceRules : {}"
        label-width="100px"
      >
        <el-form-item label="员工" prop="employeeId">
          <el-select
            v-model="performanceForm.employeeId"
            placeholder="请选择员工"
            style="width: 100%"
            filterable
            :disabled="dialogType === 'view'"
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="评估期间" prop="period">
          <el-date-picker
            v-model="performanceForm.period"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
            style="width: 100%"
            :disabled="dialogType === 'view'"
            @change="handlePeriodChange"
          />
        </el-form-item>
        <el-form-item label="评分" prop="score">
          <el-input-number
            v-model="performanceForm.score"
            :min="0"
            :max="100"
            :step="1"
            style="width: 100%"
            :disabled="dialogType === 'view'"
            @change="handleScoreChange"
          />
        </el-form-item>
        <el-form-item label="等级" prop="level">
          <el-select
            v-model="performanceForm.level"
            placeholder="请选择等级"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          >
            <el-option
              v-for="level in levelOptions"
              :key="level.value"
              :label="level.label"
              :value="level.value"
            >
              <el-tag
                :type="getLevelType(level.value)"
                effect="light"
                round
                size="small"
                style="margin-right: 8px"
              >
                {{ level.label }}
              </el-tag>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="评估人" prop="evaluatorId">
          <el-select
            v-model="performanceForm.evaluatorId"
            placeholder="请选择评估人"
            style="width: 100%"
            filterable
            :disabled="dialogType === 'view'"
          >
            <el-option
              v-for="item in employeeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="评语" prop="comments">
          <el-input
            v-model="performanceForm.comments"
            type="textarea"
            :rows="4"
            placeholder="请输入评语"
            maxlength="500"
            show-word-limit
            :disabled="dialogType === 'view'"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">
            {{ dialogType === "view" ? "关闭" : "取消" }}
          </el-button>
          <el-button
            v-if="dialogType !== 'view'"
            type="primary"
            @click="submitForm"
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
import { ref, reactive, computed, onMounted, nextTick } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import {
  Plus,
  Edit,
  Delete,
  View,
  Search,
  Refresh,
} from "@element-plus/icons-vue";
import api from "@/api/performance";
import employeeApi from "@/api/employee";
import PageContainer from "@/components/PageContainer.vue";

// 格式化日期
const formatDate = (date) => {
  if (!date) return "";
  // 如果是ISO格式的日期字符串，去掉时间部分
  if (typeof date === "string") {
    if (date.includes("T")) {
      return date.split("T")[0];
    }
    return date;
  }
  // 如果是Date对象，转换为YYYY-MM-DD格式
  if (date instanceof Date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  }
  return "";
};

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
  date: "",
  level: "",
});

// 等级选项
const levelOptions = [
  { value: "优秀", label: "优秀", type: "success" },
  { value: "良好", label: "良好", type: "warning" },
  { value: "合格", label: "合格", type: "info" },
];

// 评估表单
const dialogVisible = ref(false);
const dialogType = ref("add"); // add, edit, view
const performanceFormRef = ref(null);
const performanceForm = reactive({
  evaluationId: "",
  employeeId: "",
  startDate: "",
  endDate: "",
  score: 0,
  level: "",
  comments: "",
  approverId: "",
});

// 确认表单
const confirmDialogVisible = ref(false);
const confirmFormRef = ref(null);
const confirmForm = reactive({
  evaluationId: "",
  comment: "",
});

// 表单验证规则
const performanceRules = {
  employeeId: [{ required: true, message: "请选择员工", trigger: "change" }],
  startDate: [{ required: true, message: "请选择开始日期", trigger: "change" }],
  endDate: [{ required: true, message: "请选择结束日期", trigger: "change" }],
  score: [{ required: true, message: "请输入评分", trigger: "blur" }],
  level: [{ required: true, message: "请选择等级", trigger: "change" }],
  comments: [{ required: true, message: "请输入评语", trigger: "blur" }],
  evaluatorId: [{ required: true, message: "请选择评估人", trigger: "change" }],
};

const confirmRules = {
  comment: [{ required: true, message: "请输入确认意见", trigger: "blur" }],
};

// 员工选项
const employeeOptions = ref([]);

// 获取等级对应的标签类型
const getLevelType = (level) => {
  const levelMap = {
    优秀: "success",
    良好: "warning",
    合格: "info",
  };
  return levelMap[level] || "info";
};

// 根据评分自动计算等级
const calculateLevel = (score) => {
  if (score >= 90) {
    performanceForm.level = "优秀";
  } else if (score >= 80) {
    performanceForm.level = "良好";
  } else {
    performanceForm.level = "合格";
  }
};

// 获取员工列表
const getEmployeeList = async () => {
  try {
    const response = await employeeApi.getEmployeesPage({
      pageSize: 1000, // 获取足够多的员工数据用于下拉选择
      select: "employeeId,name", // 只获取需要的字段
    });

    console.log("获取员工列表响应：", response);

    if (
      response.data &&
      response.data.data &&
      Array.isArray(response.data.data.list)
    ) {
      employeeOptions.value = response.data.data.list.map((item) => ({
        value: item.employeeId,
        label: item.name,
      }));
    } else {
      console.error("员工数据格式不正确：", response);
      ElMessage.error("获取员工列表失败");
    }
  } catch (error) {
    console.error("获取员工列表失败", error);
    ElMessage.error(error.message || "获取员工列表失败");
  }
};

// 获取评估记录列表
const getPerformanceData = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      employeeId: searchForm.employeeId || undefined,
      evaluatorId: undefined,
      startDate: searchForm.date ? formatDate(searchForm.date[0]) : undefined,
      endDate: searchForm.date ? formatDate(searchForm.date[1]) : undefined,
      level: searchForm.level || undefined,
      keyword: searchForm.comments || undefined,
    };

    const response = await api.getPerformanceList(params);
    console.log("后端返回的完整响应：", response);

    if (response.data) {
      const responseData = response.data;
      console.log("处理后的响应数据：", responseData);

      let performanceList = [];
      if (responseData.list && Array.isArray(responseData.list)) {
        performanceList = responseData.list;
        total.value = responseData.total || responseData.list.length;
      } else if (responseData.data && responseData.data.list) {
        performanceList = responseData.data.list;
        total.value = responseData.data.total;
      } else {
        console.error("未找到预期的数据结构：", responseData);
        ElMessage.error("数据格式不正确");
        return;
      }

      // 格式化日期
      performanceList = performanceList.map((item) => ({
        ...item,
        startDate: formatDate(item.startDate),
        endDate: formatDate(item.endDate),
      }));

      // 获取所有涉及的员工ID（包括审批人）
      const employeeIds = new Set();
      performanceList.forEach((item) => {
        if (item.employeeId) employeeIds.add(item.employeeId);
        if (item.evaluatorId) employeeIds.add(item.evaluatorId);
      });

      // 使用单个查询获取员工信息
      if (employeeIds.size > 0) {
        try {
          const employeeMap = new Map();

          // 并行查询所有员工信息
          await Promise.all(
            Array.from(employeeIds).map(async (id) => {
              try {
                const empResponse = await employeeApi.getEmployeeById(id);
                if (empResponse.data && empResponse.data.data) {
                  const emp = empResponse.data.data;
                  employeeMap.set(emp.employeeId, emp.name);
                } else {
                  console.warn(`员工${id}数据格式不正确:`, empResponse);
                  employeeMap.set(id, "未知");
                }
              } catch (error) {
                console.error(`获取员工${id}信息失败:`, error);
                employeeMap.set(id, "未知");
              }
            })
          );

          // 补充员工、评估人姓名
          tableData.value = performanceList.map((item) => ({
            ...item,
            employeeName:
              employeeMap.get(item.employeeId) || `员工${item.employeeId}`,
            evaluatorName:
              employeeMap.get(item.evaluatorId) || `评估人${item.evaluatorId}`,
          }));
        } catch (error) {
          console.error("获取员工信息失败：", error);
          tableData.value = performanceList;
        }
      } else {
        tableData.value = performanceList;
      }
    } else {
      console.error("响应数据格式不正确：", response);
      ElMessage.error("获取数据失败");
    }
  } catch (error) {
    console.error("获取评估记录列表失败", error);
    ElMessage.error(error.message || "获取数据失败");
  } finally {
    loading.value = false;
  }
};

// 处理查询
const handleSearch = async () => {
  currentPage.value = 1;
  await getPerformanceData();
};

// 重置查询条件
const resetSearch = async () => {
  Object.keys(searchForm).forEach((key) => {
    searchForm[key] = "";
  });
  currentPage.value = 1;
  await getPerformanceData();
};

// 处理分页大小变化
const handleSizeChange = async (val) => {
  pageSize.value = val;
  await getPerformanceData();
};

// 处理页码变化
const handleCurrentChange = async (val) => {
  currentPage.value = val;
  await getPerformanceData();
};

// 处理添加评估
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(performanceForm).forEach((key) => {
    if (key === "score") {
      performanceForm[key] = 0;
    } else if (key === "evaluationId") {
      performanceForm[key] = 0;
    } else {
      performanceForm[key] = "";
    }
  });

  // 下一个事件循环重置表单验证
  nextTick(() => {
    if (performanceFormRef.value) {
      performanceFormRef.value.resetFields();
    }
  });
};

// 查看评估详情
const handleView = (row) => {
  dialogType.value = "view";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(performanceForm).forEach((key) => {
    performanceForm[key] = row[key] || "";
  });

  // 下一个事件循环设置表单为只读
  nextTick(() => {
    if (performanceFormRef.value) {
      const formEl = performanceFormRef.value.$el;
      const inputs = formEl.querySelectorAll("input, textarea");
      inputs.forEach((input) => {
        input.setAttribute("disabled", "disabled");
      });
      const selects = formEl.querySelectorAll(".el-select");
      selects.forEach((select) => {
        select.setAttribute("disabled", "disabled");
      });
    }
  });
};

// 修改对话框标题计算属性
const dialogTitle = computed(() => {
  switch (dialogType.value) {
    case "add":
      return "新增评估";
    case "edit":
      return "编辑评估";
    case "view":
      return "查看评估";
    default:
      return "";
  }
});

// 修改对话框
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(performanceForm).forEach((key) => {
    if (key === "score") {
      performanceForm[key] = Number(row[key] || 0);
    } else {
      performanceForm[key] = row[key] || "";
    }
  });

  // 下一个事件循环启用表单编辑
  nextTick(() => {
    if (performanceFormRef.value) {
      const formEl = performanceFormRef.value.$el;
      const inputs = formEl.querySelectorAll("input, textarea");
      inputs.forEach((input) => {
        input.removeAttribute("disabled");
      });
      const selects = formEl.querySelectorAll(".el-select");
      selects.forEach((select) => {
        select.removeAttribute("disabled");
      });
    }
  });
};

// 处理删除评估
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(`确定要删除此评估记录吗？`, "警告", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    const response = await api.deletePerformance(row.evaluationId);
    console.log("删除操作响应：", response);

    if (response.data) {
      const responseData = response.data;
      if (
        responseData.code === 0 ||
        responseData.code === 200 ||
        responseData.success
      ) {
        ElMessage.success("删除成功");
        // 如果当前页只有一条数据，且不是第一页，则跳转到上一页
        if (tableData.value.length === 1 && currentPage.value > 1) {
          currentPage.value--;
        }
        // 重新获取数据
        await getPerformanceData();
        // 重新获取员工列表
        await getEmployeeList();
      } else {
        ElMessage.error(responseData.message || responseData.msg || "删除失败");
      }
    } else {
      ElMessage.error("删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除失败", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

// 提交表单
const submitForm = () => {
  performanceFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        submitting.value = true;
        const data = {
          ...performanceForm,
          startDate: formatDate(performanceForm.startDate),
          endDate: formatDate(performanceForm.endDate),
          score: Number(performanceForm.score),
          evaluatorId: performanceForm.evaluatorId,
        };

        let response;
        if (dialogType.value === "add") {
          response = await api.addPerformance(data);
        } else if (dialogType.value === "edit") {
          response = await api.updatePerformance(data);
        }

        console.log("提交表单响应：", response);

        if (response.data) {
          const responseData = response.data;
          if (
            responseData.code === 0 ||
            responseData.code === 200 ||
            responseData.success
          ) {
            ElMessage.success(
              dialogType.value === "add" ? "添加成功" : "更新成功"
            );
            dialogVisible.value = false;
            // 重置页码到第一页
            currentPage.value = 1;
            // 重新获取数据
            await getPerformanceData();
            // 重新获取员工列表
            await getEmployeeList();
          } else {
            ElMessage.error(
              responseData.message ||
                responseData.msg ||
                (dialogType.value === "add" ? "添加失败" : "更新失败")
            );
          }
        } else {
          ElMessage.error(dialogType.value === "add" ? "添加失败" : "更新失败");
        }
      } catch (error) {
        console.error(
          dialogType.value === "add" ? "添加失败" : "更新失败",
          error
        );
        ElMessage.error(
          error.message ||
            (dialogType.value === "add" ? "添加失败" : "更新失败")
        );
      } finally {
        submitting.value = false;
      }
    } else {
      console.error("表单验证失败");
      return false;
    }
  });
};

// 提交确认
const submitConfirm = () => {
  confirmFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        // 这里应该调用API提交确认
        ElMessage.success("确认成功");
        confirmDialogVisible.value = false;
        // 重新获取数据
        await getPerformanceData();
        // 重新获取员工列表
        await getEmployeeList();
      } catch (error) {
        console.error("确认失败", error);
        ElMessage.error(error.message || "确认失败");
      }
    }
  });
};

// 页面加载时获取数据
onMounted(() => {
  getPerformanceData();
  getEmployeeList();
});

// 获取评分样式
const getScoreClass = (score) => {
  if (score >= 90) return "score-excellent";
  if (score >= 80) return "score-good";
  if (score >= 60) return "score-pass";
  return "score-fail";
};

// 处理评分变化
const handleScoreChange = (value) => {
  // 根据评分自动设置等级
  if (value >= 90) {
    performanceForm.level = "优秀";
  } else if (value >= 80) {
    performanceForm.level = "良好";
  } else {
    performanceForm.level = "合格";
  }
};

// 处理评估期间变化
const handlePeriodChange = (value) => {
  if (value) {
    performanceForm.startDate = value[0];
    performanceForm.endDate = value[1];
  } else {
    performanceForm.startDate = null;
    performanceForm.endDate = null;
  }
};
</script>

<style scoped>
:deep(.el-table) {
  --el-table-header-bg-color: #f5f7fa;
  --el-table-border-color: #ebeef5;
  --el-table-header-text-color: #606266;
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
  color: #606266;
}

:deep(.el-input),
:deep(.el-select),
:deep(.el-date-picker) {
  width: 220px;
}

:deep(.el-dialog__body) {
  padding: 20px 30px;
}

:deep(.el-form--inline .el-form-item) {
  margin-right: 20px;
}

:deep(.el-button) {
  font-weight: normal;
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

.score-excellent {
  color: #67c23a;
  font-weight: bold;
}

.score-good {
  color: #409eff;
  font-weight: bold;
}

.score-pass {
  color: #e6a23c;
  font-weight: bold;
}

.score-fail {
  color: #f56c6c;
  font-weight: bold;
}

:deep(.el-button-group) {
  display: inline-flex;
  gap: 4px;
}
</style>
