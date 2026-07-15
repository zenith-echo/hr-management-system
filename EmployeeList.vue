<template>
  <page-container title="员工管理">
    <!-- 操作按钮 -->
    <template #actions>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>添加员工
      </el-button>
    </template>

    <!-- 搜索区域 -->
    <template #search>
      <el-form :model="searchForm" inline>
        <el-form-item label="员工编号">
          <el-input
            v-model="searchForm.employeeNo"
            placeholder="请输入员工编号"
            clearable
          />
        </el-form-item>
        <el-form-item label="姓名">
          <el-input
            v-model="searchForm.name"
            placeholder="请输入姓名"
            clearable
          />
        </el-form-item>
        <el-form-item label="部门">
          <el-select
            v-model="searchForm.departmentId"
            placeholder="请选择部门"
            clearable
          >
            <el-option
              v-for="item in departmentOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
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
            />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="searchForm.status"
            placeholder="请选择状态"
            clearable
          >
            <el-option label="在职" value="在职" />
            <el-option label="离职" value="离职" />
            <el-option label="休假" value="休假" />
            <el-option label="试用期" value="试用期" />
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
      <el-table-column prop="employeeId" label="员工ID" min-width="80" />
      <el-table-column prop="name" label="姓名" min-width="100">
        <template #default="scope">
          <span class="employee-name">{{ scope.row.name }}</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="gender"
        label="性别"
        min-width="60"
        align="center"
      />
      <el-table-column prop="phone" label="电话" min-width="120" />
      <el-table-column prop="email" label="邮箱" min-width="180" />
      <el-table-column prop="departmentName" label="部门" min-width="120">
        <template #default="scope">
          <el-tag size="small" effect="plain">
            {{ getDepartmentName(scope.row.departmentId) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="positionName" label="职位" min-width="120">
        <template #default="scope">
          <el-tag size="small" effect="plain" type="info">
            {{ getPositionName(scope.row.positionId) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="hireDate" label="入职日期" min-width="120">
        <template #default="scope">
          <span class="date-text">{{ formatDate(scope.row.hireDate) }}</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="status"
        label="状态"
        min-width="100"
        align="center"
      >
        <template #default="scope">
          <el-tag :type="getStatusType(scope.row.status)" size="small">
            {{ scope.row.status }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="120" fixed="right" align="center">
        <template #default="scope">
          <el-button-group>
            <el-tooltip content="查看" placement="top">
              <el-button type="info" link @click="handleView(scope.row)">
                <el-icon><View /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="编辑" placement="top">
              <el-button type="primary" link @click="handleEdit(scope.row)">
                <el-icon><Edit /></el-icon>
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

    <!-- 员工表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="
        dialogType === 'add'
          ? '添加员工'
          : dialogType === 'edit'
          ? '编辑员工'
          : '员工详情'
      "
      width="70%"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <el-form
        ref="employeeFormRef"
        :model="employeeForm"
        :rules="employeeRules"
        label-width="100px"
        :disabled="dialogType === 'view'"
      >
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="姓名" prop="name">
              <el-input v-model="employeeForm.name" placeholder="请输入姓名" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="性别" prop="gender">
              <el-select
                v-model="employeeForm.gender"
                placeholder="请选择性别"
                style="width: 100%"
              >
                <el-option label="男" value="男" />
                <el-option label="女" value="女" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="出生日期" prop="birthDate">
              <el-date-picker
                v-model="employeeForm.birthDate"
                type="date"
                placeholder="请选择出生日期"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="身份证号" prop="idCard">
              <el-input
                v-model="employeeForm.idCard"
                placeholder="请输入身份证号"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="电话" prop="phone">
              <el-input v-model="employeeForm.phone" placeholder="请输入电话" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="employeeForm.email" placeholder="请输入邮箱" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="部门" prop="departmentId">
              <el-select
                v-model="employeeForm.departmentId"
                placeholder="请选择部门"
                style="width: 100%"
              >
                <el-option
                  v-for="item in departmentOptions"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="职位" prop="positionId">
              <el-select
                v-model="employeeForm.positionId"
                placeholder="请选择职位"
                style="width: 100%"
                :disabled="!employeeForm.departmentId"
              >
                <el-option
                  v-for="item in filteredPositionOptions"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="入职日期" prop="hireDate">
              <el-date-picker
                v-model="employeeForm.hireDate"
                type="date"
                placeholder="请选择入职日期"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="状态" prop="status">
              <el-select
                v-model="employeeForm.status"
                placeholder="请选择状态"
                style="width: 100%"
              >
                <el-option label="在职" value="在职" />
                <el-option label="离职" value="离职" />
                <el-option label="休假" value="休假" />
                <el-option label="试用期" value="试用期" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="紧急联系人" prop="emergencyContact">
              <el-input
                v-model="employeeForm.emergencyContact"
                placeholder="请输入紧急联系人"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="紧急电话" prop="emergencyPhone">
              <el-input
                v-model="employeeForm.emergencyPhone"
                placeholder="请输入紧急联系电话"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="16">
            <el-form-item label="地址" prop="address">
              <el-input
                v-model="employeeForm.address"
                placeholder="请输入地址"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="照片" prop="photo">
              <el-upload
                class="avatar-uploader"
                action="/api/upload"
                :show-file-list="false"
                :on-success="handleAvatarSuccess"
                :before-upload="beforeAvatarUpload"
              >
                <img
                  v-if="employeeForm.photo"
                  :src="employeeForm.photo"
                  class="avatar"
                />
                <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
              </el-upload>
            </el-form-item>
          </el-col>
        </el-row>
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
  </page-container>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, watch } from "vue";
import {
  Plus,
  Edit,
  Delete,
  Search,
  Refresh,
  View,
} from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";
import employeeApi from "../../api/employee";
import departmentApi from "../../api/department";
import positionApi from "../../api/position";
import PageContainer from "../../components/PageContainer.vue";

// 表格数据
const loading = ref(false);
const tableData = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 搜索表单
const searchForm = reactive({
  employeeNo: "",
  name: "",
  departmentId: "",
  positionId: "",
  status: "",
});

// 员工表单
const dialogVisible = ref(false);
const dialogType = ref("add"); // add, edit, view
const employeeFormRef = ref(null);
const employeeForm = reactive({
  employeeId: "",
  name: "",
  gender: "",
  birthDate: "",
  idCard: "",
  phone: "",
  email: "",
  address: "",
  emergencyContact: "",
  emergencyPhone: "",
  hireDate: "",
  status: "在职",
  photo: "",
  departmentId: "",
  positionId: "",
});

// 表单验证规则
const employeeRules = {
  name: [
    { required: true, message: "请输入姓名", trigger: "blur" },
    { min: 2, max: 20, message: "长度在 2 到 20 个字符", trigger: "blur" },
  ],
  gender: [{ required: true, message: "请选择性别", trigger: "change" }],
  birthDate: [{ required: true, message: "请选择出生日期", trigger: "change" }],
  idCard: [
    { required: true, message: "请输入身份证号", trigger: "blur" },
    {
      pattern: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/,
      message: "身份证号格式不正确",
      trigger: "blur",
    },
  ],
  phone: [
    { required: true, message: "请输入电话", trigger: "blur" },
    { pattern: /^1[3-9]\d{9}$/, message: "手机号格式不正确", trigger: "blur" },
  ],
  email: [
    { required: true, message: "请输入邮箱", trigger: "blur" },
    { type: "email", message: "邮箱格式不正确", trigger: "blur" },
  ],
  departmentId: [{ required: true, message: "请选择部门", trigger: "change" }],
  positionId: [{ required: true, message: "请选择职位", trigger: "change" }],
  hireDate: [{ required: true, message: "请选择入职日期", trigger: "change" }],
  status: [{ required: true, message: "请选择状态", trigger: "change" }],
};

// 部门和职位选项
const departmentOptions = ref([]);
const positionOptions = ref([]);

// 获取部门名称
const getDepartmentName = (departmentId) => {
  if (!departmentId) return "未分配";
  const dept = departmentOptions.value.find((d) => d.value === departmentId);
  return dept ? dept.label : "未分配";
};

// 获取职位名称
const getPositionName = (positionId) => {
  if (!positionId) return "未分配";
  const pos = positionOptions.value.find((p) => p.value === positionId);
  return pos ? pos.label : "未分配";
};

// 获取职位列表
const getPositionList = async () => {
  try {
    const res = await positionApi.getAllPositions();
    if (res.data.code === 0) {
      const positions = res.data.data.list || [];
      positionOptions.value = positions.map((pos) => ({
        value: pos.positionId,
        label: pos.positionName,
        departmentId: pos.departmentId,
      }));
    } else {
      throw new Error(res.data.msg || "获取职位列表失败");
    }
  } catch (error) {
    console.error("获取职位列表失败:", error);
    ElMessage.error(error.message || "获取职位列表失败");
    positionOptions.value = [];
  }
};

// 根据选择的部门过滤职位选项
const filteredPositionOptions = computed(() => {
  if (!employeeForm.departmentId) {
    return [];
  }
  return positionOptions.value.filter(
    (item) => item.departmentId === employeeForm.departmentId
  );
});

// 监听部门变化，重置职位
watch(
  () => employeeForm.departmentId,
  (newVal) => {
    if (newVal) {
      employeeForm.positionId = "";
    }
  }
);

// 获取状态对应的标签类型
const getStatusType = (status) => {
  const statusMap = {
    在职: "success",
    离职: "danger",
    休假: "warning",
    试用期: "info",
  };
  return statusMap[status] || "";
};

// 添加日期格式化函数
const formatDate = (date) => {
  if (!date) return "";
  return new Date(date).toLocaleDateString();
};

// 获取员工列表
const getEmployeeList = async () => {
  loading.value = true;
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      keyword: searchForm.name, // 使用name作为关键字
      departmentId: searchForm.departmentId || null,
      positionId: searchForm.positionId || null,
      status: searchForm.status || null,
    };

    const res = await employeeApi.getEmployeesPage(params);
    console.log("获取员工列表响应:", res);

    if (res.data.code === 0) {
      // 处理返回的数据
      tableData.value = res.data.data.list.map((item) => ({
        ...item,
        // 确保日期格式正确
        birthDate: item.birthDate
          ? new Date(item.birthDate).toISOString().split("T")[0]
          : "",
        hireDate: item.hireDate
          ? new Date(item.hireDate).toISOString().split("T")[0]
          : "",
      }));
      total.value = res.data.data.total;
    } else {
      throw new Error(res.data.msg || "获取员工列表失败");
    }
  } catch (error) {
    console.error("获取员工列表失败:", error);
    ElMessage.error(error.message || "获取员工列表失败");
  } finally {
    loading.value = false;
  }
};

// 获取部门列表
const getDepartmentList = async () => {
  try {
    const res = await departmentApi.getDepartmentPage({
      pageNum: 1,
      pageSize: 1000,
    });
    if (res.data.code === 0) {
      // 将部门数据转换为选项格式
      departmentOptions.value = (res.data.data.list || []).map((dept) => ({
        value: dept.departmentId,
        label: dept.departmentName,
      }));
    } else {
      throw new Error(res.data.msg || "获取部门列表失败");
    }
  } catch (error) {
    console.error("获取部门列表失败:", error);
    ElMessage.error(error.message || "获取部门列表失败");
    departmentOptions.value = [];
  }
};

// 处理查询
const handleSearch = () => {
  currentPage.value = 1;
  getEmployeeList();
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
  getEmployeeList();
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getEmployeeList();
};

// 处理添加员工
const handleAdd = () => {
  dialogType.value = "add";
  dialogVisible.value = true;

  // 重置表单
  Object.keys(employeeForm).forEach((key) => {
    employeeForm[key] = "";
  });
  employeeForm.status = "在职";

  // 下一个事件循环重置表单验证
  setTimeout(() => {
    employeeFormRef.value?.resetFields();
  });
};

// 处理查看员工
const handleView = (row) => {
  dialogType.value = "view";
  dialogVisible.value = true;

  // 填充表单，确保所有字段都有值
  Object.keys(employeeForm).forEach((key) => {
    employeeForm[key] = row[key] || "";
  });
};

// 处理编辑员工
const handleEdit = (row) => {
  dialogType.value = "edit";
  dialogVisible.value = true;

  // 填充表单，确保所有字段都有值
  Object.keys(employeeForm).forEach((key) => {
    employeeForm[key] = row[key] || "";
  });
};

// 处理删除员工
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(`确定要删除员工 ${row.name} 吗？`, "警告", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    const res = await employeeApi.deleteEmployee(row.employeeId);
    if (res.data.code === 0) {
      ElMessage.success("删除成功");
      if (tableData.value.length === 1 && currentPage.value > 1) {
        currentPage.value--;
      }
      getEmployeeList();
    } else {
      throw new Error(res.data.msg || "删除失败");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("删除员工失败", error);
      ElMessage.error(error.message || "删除失败");
    }
  }
};

// 头像上传成功
const handleAvatarSuccess = (res) => {
  if (res.code === 0) {
    employeeForm.photo = res.data.url;
    ElMessage.success("上传成功");
  } else {
    ElMessage.error(res.msg || "上传失败");
  }
};

// 头像上传前的验证
const beforeAvatarUpload = (file) => {
  const isJPG = file.type === "image/jpeg";
  const isPNG = file.type === "image/png";
  const isLt2M = file.size / 1024 / 1024 < 2;

  if (!isJPG && !isPNG) {
    ElMessage.error("上传头像图片只能是 JPG 或 PNG 格式!");
    return false;
  }
  if (!isLt2M) {
    ElMessage.error("上传头像图片大小不能超过 2MB!");
    return false;
  }
  return true;
};

// 提交表单
const submitForm = async () => {
  if (!employeeFormRef.value) return;

  try {
    await employeeFormRef.value.validate();

    // 处理日期格式
    const submitData = {
      ...employeeForm,
      birthDate: employeeForm.birthDate
        ? new Date(employeeForm.birthDate).toISOString().split("T")[0]
        : null,
      hireDate: employeeForm.hireDate
        ? new Date(employeeForm.hireDate).toISOString().split("T")[0]
        : null,
    };

    if (dialogType.value === "add") {
      const res = await employeeApi.addEmployee(submitData);
      if (res.data.code === 0) {
        ElMessage.success("添加成功");
        dialogVisible.value = false;
        getEmployeeList();
      } else {
        throw new Error(res.data.msg || "添加失败");
      }
    } else if (dialogType.value === "edit") {
      const res = await employeeApi.updateEmployee(submitData);
      if (res.data.code === 0) {
        ElMessage.success("更新成功");
        dialogVisible.value = false;
        getEmployeeList();
      } else {
        throw new Error(res.data.msg || "更新失败");
      }
    }
  } catch (error) {
    console.error("提交表单失败:", error);
    ElMessage.error(error.message || "操作失败");
  }
};

// 页面加载时获取数据
onMounted(() => {
  getEmployeeList();
  getDepartmentList();
  getPositionList();
});
</script>

<style scoped>
:deep(.el-table) {
  font-size: 14px;
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

.employee-name {
  font-weight: 500;
  color: #303133;
}

.date-text {
  color: #606266;
  font-size: 13px;
}

:deep(.el-tag) {
  font-weight: normal;
}

:deep(.el-form-item__label) {
  font-weight: 500;
  color: #606266;
}

:deep(.el-input),
:deep(.el-select) {
  width: 220px;
}

:deep(.el-dialog__body) {
  padding: 20px 30px;
}

:deep(.el-form--inline .el-form-item) {
  margin-right: 20px;
}

.avatar-uploader {
  display: flex;
  justify-content: center;
}

.avatar-uploader :deep(.el-upload) {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration);
}

.avatar-uploader :deep(.el-upload:hover) {
  border-color: var(--el-color-primary);
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 100px;
  height: 100px;
  text-align: center;
  line-height: 100px;
}

.avatar {
  width: 100px;
  height: 100px;
  display: block;
  object-fit: cover;
}
</style>
