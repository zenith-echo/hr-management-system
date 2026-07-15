<template>
  <div class="course-list">
    <div class="page-header">
      <h2>培训课程管理</h2>
      <div class="actions">
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>添加课程
        </el-button>
      </div>
    </div>

    <!-- 搜索区域 -->
    <el-card class="search-card">
      <el-form :model="searchForm" inline>
        <el-form-item label="课程名称">
          <el-input
            v-model="searchForm.courseName"
            placeholder="请输入课程名称"
            clearable
          ></el-input>
        </el-form-item>
        <el-form-item label="类别">
          <el-select
            v-model="searchForm.category"
            placeholder="请选择类别"
            clearable
          >
            <el-option label="技术培训" value="技术培训"></el-option>
            <el-option label="管理培训" value="管理培训"></el-option>
            <el-option label="职业素养" value="职业素养"></el-option>
            <el-option label="新员工培训" value="新员工培训"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="培训师">
          <el-input
            v-model="searchForm.trainer"
            placeholder="请输入培训师"
            clearable
          ></el-input>
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
          prop="courseName"
          label="课程名称"
          min-width="150"
        ></el-table-column>
        <el-table-column
          prop="category"
          label="类别"
          width="120"
        ></el-table-column>
        <el-table-column
          prop="trainer"
          label="培训师"
          width="120"
        ></el-table-column>
        <el-table-column prop="duration" label="时长" width="100">
          <template #default="scope"> {{ scope.row.duration }}小时 </template>
        </el-table-column>
        <el-table-column prop="cost" label="成本" width="120">
          <template #default="scope">
            {{ formatCost(scope.row.cost) }}
          </template>
        </el-table-column>
        <el-table-column
          prop="createTime"
          label="创建时间"
          width="180"
        ></el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button type="primary" link @click="handleEdit(scope.row)">
              <el-icon><Edit /></el-icon>编辑
            </el-button>
            <el-button type="info" link @click="handleView(scope.row)">
              <el-icon><View /></el-icon>查看
            </el-button>
            <el-button type="danger" link @click="handleDelete(scope.row)">
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
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        ></el-pagination>
      </div>
    </el-card>

    <!-- 课程表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="
        dialogType === 'add'
          ? '添加课程'
          : dialogType === 'edit'
          ? '编辑课程'
          : '查看课程'
      "
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="courseFormRef"
        :model="courseForm"
        :rules="courseRules"
        label-width="100px"
      >
        <el-form-item label="课程名称" prop="courseName">
          <el-input
            v-model="courseForm.courseName"
            placeholder="请输入课程名称"
            :disabled="dialogType === 'view'"
          ></el-input>
        </el-form-item>
        <el-form-item label="类别" prop="category">
          <el-select
            v-model="courseForm.category"
            placeholder="请选择类别"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          >
            <el-option label="技术培训" value="技术培训"></el-option>
            <el-option label="管理培训" value="管理培训"></el-option>
            <el-option label="职业素养" value="职业素养"></el-option>
            <el-option label="新员工培训" value="新员工培训"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="培训师" prop="trainer">
          <el-input
            v-model="courseForm.trainer"
            placeholder="请输入培训师"
            :disabled="dialogType === 'view'"
          ></el-input>
        </el-form-item>
        <el-form-item label="时长(小时)" prop="duration">
          <el-input-number
            v-model="courseForm.duration"
            :min="1"
            :max="100"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          ></el-input-number>
        </el-form-item>
        <el-form-item label="成本" prop="cost">
          <el-input-number
            v-model="courseForm.cost"
            :min="0"
            :step="100"
            style="width: 100%"
            :disabled="dialogType === 'view'"
          ></el-input-number>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="courseForm.description"
            type="textarea"
            rows="3"
            placeholder="请输入课程描述"
            :disabled="dialogType === 'view'"
          ></el-input>
        </el-form-item>
        <el-form-item label="培训材料" prop="materials">
          <el-upload
            v-if="dialogType !== 'view'"
            class="upload-demo"
            action="/api/upload"
            :on-success="handleUploadSuccess"
            :on-error="handleUploadError"
            :disabled="dialogType === 'view'"
          >
            <el-button type="primary">上传文件</el-button>
          </el-upload>
          <div v-if="courseForm.materials">
            <el-link
              type="primary"
              :href="courseForm.materials"
              target="_blank"
            >
              查看培训材料
            </el-link>
          </div>
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
  courseName: "",
  category: "",
  trainer: "",
});

// 课程表单
const dialogVisible = ref(false);
const dialogType = ref("add");
const courseFormRef = ref(null);
const courseForm = reactive({
  courseId: "",
  courseName: "",
  description: "",
  category: "",
  trainer: "",
  duration: 1,
  cost: 0,
  materials: "",
});

// 表单验证规则
const courseRules = {
  courseName: [
    { required: true, message: "请输入课程名称", trigger: "blur" },
    { min: 2, max: 50, message: "长度在 2 到 50 个字符", trigger: "blur" },
  ],
  category: [{ required: true, message: "请选择类别", trigger: "change" }],
  trainer: [{ required: true, message: "请输入培训师", trigger: "blur" }],
  duration: [{ required: true, message: "请输入时长", trigger: "blur" }],
  cost: [{ required: true, message: "请输入成本", trigger: "blur" }],
};

// 格式化成本
const formatCost = (cost) => {
  return `￥${cost.toLocaleString()}`;
};

// 获取课程列表
const getCourseList = async () => {
  loading.value = true;
  try {
    // 这里应该调用API获取数据，现在使用模拟数据
    setTimeout(() => {
      const mockData = Array.from({ length: 10 }, (_, index) => ({
        courseId: `${index + 1}`,
        courseName: `课程${index + 1}`,
        description: "这是一个示例课程描述",
        category: ["技术培训", "管理培训", "职业素养", "新员工培训"][index % 4],
        trainer: `培训师${index + 1}`,
        duration: 4 + index,
        cost: 1000 + index * 500,
        materials: "",
        createTime: "2024-03-15 10:00:00",
      }));

      tableData.value = mockData;
      total.value = 100;
      loading.value = false;
    }, 500);
  } catch (error) {
    console.error("获取课程列表失败", error);
    loading.value = false;
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getCourseList();
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
  getCourseList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getCourseList();
};

// 处理添加课程
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(courseForm).forEach((key) => {
    if (key === "duration") {
      courseForm[key] = 1;
    } else if (key === "cost") {
      courseForm[key] = 0;
    } else {
      courseForm[key] = "";
    }
  });

  // 下一个事件循环重置表单验证
  setTimeout(() => {
    courseFormRef.value?.resetFields();
  });
};

// 处理编辑课程
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(courseForm).forEach((key) => {
    courseForm[key] = row[key];
  });
};

// 处理查看课程
const handleView = (row) => {
  dialogType.value = "view";
  dialogVisible.value = true;

  // 填充表单
  Object.keys(courseForm).forEach((key) => {
    courseForm[key] = row[key];
  });
};

// 处理删除课程
const handleDelete = (row) => {
  ElMessageBox.confirm("确定要删除此课程吗？", "警告", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(() => {
      // 这里应该调用API删除数据
      ElMessage.success("删除成功");
      getCourseList();
    })
    .catch(() => {});
};

// 处理文件上传成功
const handleUploadSuccess = (response) => {
  courseForm.materials = response.url;
  ElMessage.success("上传成功");
};

// 处理文件上传失败
const handleUploadError = () => {
  ElMessage.error("上传失败");
};

// 提交表单
const submitForm = () => {
  courseFormRef.value.validate((valid) => {
    if (valid) {
      if (dialogType.value === "add") {
        // 这里应该调用API添加数据
        ElMessage.success("添加成功");
      } else if (dialogType.value === "edit") {
        // 这里应该调用API更新数据
        ElMessage.success("更新成功");
      }
      dialogVisible.value = false;
      getCourseList();
    }
  });
};

// 页面加载时获取数据
onMounted(() => {
  getCourseList();
});
</script>

<style scoped>
.course-list {
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

.upload-demo {
  margin-bottom: 10px;
}
</style>
