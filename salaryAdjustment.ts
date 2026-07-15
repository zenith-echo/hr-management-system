import axios from "axios";
import { ElMessage } from "element-plus";

// 创建axios实例
const instance = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || "/api", // 使用环境变量或默认值
  timeout: 10000,
  headers: {
    "Content-Type": "application/json",
  },
});

// 添加请求拦截器
instance.interceptors.request.use(
  (config) => {
    // 添加token
    const token = localStorage.getItem("token");
    if (token) {
      config.headers["Authorization"] = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    console.error("请求配置错误:", error);
    return Promise.reject(error);
  }
);

// 添加响应拦截器
instance.interceptors.response.use(
  (response) => {
    const res = response.data;
    // 这里假设后端返回的数据格式为 { code: 200, data: xxx, msg: 'success' }
    if (res.code === 200) {
      return Promise.resolve(res);
    }
    // 如果状态码不是200，也返回数据，由具体业务处理
    return Promise.resolve(res);
  },
  (error) => {
    console.error("响应错误:", error);
    const message = error.response?.data?.msg || error.message || "请求失败";
    ElMessage.error(message);
    return Promise.reject(error);
  }
);

const api = {
  // 获取薪资调整列表（分页）
  getAdjustmentPage(params = {}) {
    try {
      // 确保所有参数都是正确的类型
      const queryParams = {
        pageNum: parseInt(params.pageNum) || 1,
        pageSize: parseInt(params.pageSize) || 10,
      };

      // 只有在有值的情况下才添加参数
      if (params.employeeId) {
        queryParams.employeeId = parseInt(params.employeeId);
      }
      if (params.approverId) {
        queryParams.approverId = parseInt(params.approverId);
      }
      if (
        params.previousSalaryMin !== undefined &&
        params.previousSalaryMin !== ""
      ) {
        queryParams.previousSalaryMin = parseFloat(params.previousSalaryMin);
      }
      if (
        params.previousSalaryMax !== undefined &&
        params.previousSalaryMax !== ""
      ) {
        queryParams.previousSalaryMax = parseFloat(params.previousSalaryMax);
      }
      if (params.newSalaryMin !== undefined && params.newSalaryMin !== "") {
        queryParams.newSalaryMin = parseFloat(params.newSalaryMin);
      }
      if (params.newSalaryMax !== undefined && params.newSalaryMax !== "") {
        queryParams.newSalaryMax = parseFloat(params.newSalaryMax);
      }
      if (params.adjustmentDateStart) {
        queryParams.adjustmentDateStart = params.adjustmentDateStart;
      }
      if (params.adjustmentDateEnd) {
        queryParams.adjustmentDateEnd = params.adjustmentDateEnd;
      }
      if (params.keyword) {
        queryParams.keyword = params.keyword.trim();
      }

      return instance.get("/salary-adjustment/page", { params: queryParams });
    } catch (error) {
      console.error("参数处理错误:", error);
      return Promise.reject(error);
    }
  },

  // 获取单个薪资调整详情
  getAdjustmentById(id) {
    if (!id) {
      return Promise.reject(new Error("调整记录ID不能为空"));
    }
    return instance.get(`/salary-adjustment/${id}`);
  },

  // 新增薪资调整
  addAdjustment(data) {
    try {
      // 数据预处理
      const submitData = {
        employeeId: parseInt(data.employeeId),
        previousSalary: parseFloat(data.previousSalary),
        newSalary: parseFloat(data.newSalary),
        adjustmentDate: data.adjustmentDate,
        reason: data.reason?.trim(),
        status: data.status || "待审批",
      };

      // 验证数据
      if (!submitData.employeeId) {
        return Promise.reject(new Error("员工ID不能为空"));
      }
      if (isNaN(submitData.previousSalary) || submitData.previousSalary < 0) {
        return Promise.reject(new Error("调整前薪资必须大于等于0"));
      }
      if (isNaN(submitData.newSalary) || submitData.newSalary < 0) {
        return Promise.reject(new Error("调整后薪资必须大于等于0"));
      }
      if (!submitData.adjustmentDate) {
        return Promise.reject(new Error("调整日期不能为空"));
      }
      if (!submitData.reason) {
        return Promise.reject(new Error("调整原因不能为空"));
      }

      return instance.post("/salary-adjustment", submitData);
    } catch (error) {
      console.error("数据处理错误:", error);
      return Promise.reject(error);
    }
  },

  // 更新薪资调整
  updateAdjustment(data) {
    try {
      if (!data.adjustmentId) {
        return Promise.reject(new Error("调整记录ID不能为空"));
      }

      const submitData = {
        adjustmentId: parseInt(data.adjustmentId),
        status: data.status,
        approverId: parseInt(data.approverId),
        approverComment: data.approverComment?.trim(),
      };

      if (!submitData.status) {
        return Promise.reject(new Error("审批状态不能为空"));
      }
      if (!submitData.approverId) {
        return Promise.reject(new Error("审批人ID不能为空"));
      }
      if (!submitData.approverComment) {
        return Promise.reject(new Error("审批意见不能为空"));
      }

      return instance.put("/salary-adjustment", submitData);
    } catch (error) {
      console.error("数据处理错误:", error);
      return Promise.reject(error);
    }
  },

  // 删除薪资调整
  deleteAdjustment(id) {
    if (!id) {
      return Promise.reject(new Error("调整记录ID不能为空"));
    }
    return instance.delete(`/salary-adjustment/${id}`);
  },
};

export default api;
