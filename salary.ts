import axios from "axios";
import { ElMessage } from "element-plus";

// 创建axios实例
const instance = axios.create({
  baseURL: "/api",
  timeout: 10000,
  headers: {
    "Content-Type": "application/json",
  },
});

// 添加请求拦截器
instance.interceptors.request.use(
  (config) => {
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
    if (res.code === 0) {
      return Promise.resolve(res);
    }
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
  // 获取薪资记录列表（分页）
  getSalaryPage(params = {}) {
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    if (params.employeeId) {
      queryParams.employeeId = parseInt(params.employeeId);
    }
    if (params.year) {
      queryParams.year = params.year;
    }
    if (params.month) {
      queryParams.month = params.month;
    }
    if (params.paymentStatus) {
      queryParams.paymentStatus = params.paymentStatus;
    }

    return instance.get("/salary-records/page", { params: queryParams });
  },

  // 获取单个薪资记录
  getSalaryById(id) {
    if (!id) {
      return Promise.reject(new Error("记录ID不能为空"));
    }
    return instance.get(`/salary-records/${id}`);
  },

  // 新增薪资记录
  addSalary(data) {
    const submitData = {
      employeeId: parseInt(data.employeeId),
      year: parseInt(data.year),
      month: parseInt(data.month),
      baseSalary: parseFloat(data.baseSalary),
      performanceBonus: parseFloat(data.performanceBonus),
      netSalary: parseFloat(data.netSalary),
      paymentStatus: data.paymentStatus || "未发放",
    };

    return instance.post("/salary-records", submitData);
  },

  // 更新薪资记录
  updateSalary(data) {
    if (!data.recordId) {
      return Promise.reject(new Error("记录ID不能为空"));
    }

    const submitData = {
      recordId: parseInt(data.recordId),
      employeeId: parseInt(data.employeeId),
      year: parseInt(data.year),
      month: parseInt(data.month),
      baseSalary: parseFloat(data.baseSalary),
      performanceBonus: parseFloat(data.performanceBonus),
      netSalary: parseFloat(data.netSalary),
      paymentStatus: data.paymentStatus,
    };

    return instance.put("/salary-records", submitData);
  },

  // 删除薪资记录
  deleteSalary(id) {
    if (!id) {
      return Promise.reject(new Error("记录ID不能为空"));
    }
    return instance.delete(`/salary-records/${id}`);
  },

  // 发放薪资
  paySalary(id) {
    if (!id) {
      return Promise.reject(new Error("记录ID不能为空"));
    }
    return instance.post(`/salary-records/${id}/pay`);
  },
};

export default api;
