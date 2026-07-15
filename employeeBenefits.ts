import axios from "axios";

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
    console.log("发送请求配置:", config);
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
    console.log("接收响应:", response);
    return response;
  },
  (error) => {
    console.error("响应错误:", error);
    return Promise.reject(error);
  }
);

const api = {
  // 获取福利分配列表（分页）
  getEmployeeBenefitsPage(params) {
    return instance.get("/employee-benefits/page", { params });
  },

  // 获取单个福利分配
  getEmployeeBenefitsById(id) {
    return instance.get(`/employee-benefits/${id}`);
  },

  // 新增福利分配
  addEmployeeBenefits(data) {
    return instance.post("/employee-benefits", data);
  },

  // 更新福利分配
  updateEmployeeBenefits(data) {
    return instance.put("/employee-benefits", data);
  },

  // 删除福利分配
  deleteEmployeeBenefits(id) {
    return instance.delete(`/employee-benefits/${id}`);
  },

  // 获取员工姓名
  getEmployeeNameById(id) {
    return instance.get(`/employees/${id}`, {
      params: {
        select: "employeeId,name",
      },
    });
  },

  // 获取福利计划信息
  getBenefitsPlanById(id) {
    return instance.get(`/benefits-plan/${id}`);
  },
};

export default api;
