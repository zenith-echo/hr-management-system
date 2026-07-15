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
    console.log("发送请求配置:", {
      url: config.url,
      method: config.method,
      headers: config.headers,
      params: config.params,
      data: config.data,
    });
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
    console.log("接收响应:", {
      url: response.config.url,
      status: response.status,
      headers: response.headers,
      data: response.data,
    });
    return response;
  },
  (error) => {
    console.error("响应错误详情:", {
      url: error.config?.url,
      method: error.config?.method,
      headers: error.config?.headers,
      data: error.config?.data,
      status: error.response?.status,
      statusText: error.response?.statusText,
      responseData: error.response?.data,
      message: error.message,
    });

    // 尝试获取详细的错误信息
    const errorMessage =
      error.response?.data?.message ||
      error.response?.data?.error ||
      error.response?.data?.msg ||
      error.message ||
      "未知错误";

    return Promise.reject({
      message: errorMessage,
      status: error.response?.status,
      data: error.response?.data,
      originalError: error,
    });
  }
);

const api = {
  // 分页查询部门
  getDepartmentPage(params) {
    // 确保所有参数都是正确的类型
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    // 只有在有值的情况下才添加参数
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }
    if (params.parentId !== undefined && params.parentId !== null) {
      queryParams.parentId = parseInt(params.parentId);
    }
    if (params.managerId !== undefined && params.managerId !== null) {
      queryParams.managerId = parseInt(params.managerId);
    }

    console.log("发送查询参数:", queryParams);

    return instance.get("/departments/page", {
      params: queryParams,
      paramsSerializer: (params) => {
        return Object.entries(params)
          .filter(([_, value]) => value !== undefined && value !== "")
          .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
          .join("&");
      },
    });
  },

  // 新增部门
  addDepartment(data) {
    // 数据预处理
    const submitData = {
      departmentName: data.departmentName?.trim(),
      parentId: data.parentId === null ? null : parseInt(data.parentId),
      managerId: parseInt(data.managerId) || null, // 允许为null
    };

    console.log("新增部门数据:", submitData);

    // 验证数据
    if (!submitData.departmentName) {
      return Promise.reject({ message: "部门名称不能为空" });
    }

    return instance.post("/departments", submitData);
  },

  // 修改部门
  updateDepartment(data) {
    if (!data.departmentId) {
      return Promise.reject({ message: "部门ID不能为空" });
    }

    const submitData = {
      departmentId: parseInt(data.departmentId),
      departmentName: data.departmentName?.trim(),
      parentId: data.parentId === null ? null : parseInt(data.parentId),
      managerId: parseInt(data.managerId) || null, // 允许为null
    };

    console.log("更新部门数据:", submitData);

    return instance.put("/departments", submitData);
  },

  // 删除部门
  deleteDepartment(id) {
    if (!id) {
      return Promise.reject({ message: "部门ID不能为空" });
    }
    console.log("删除部门ID:", id);
    return instance.delete(`/departments/${id}`);
  },

  // 查询单个部门
  getDepartmentById(id) {
    if (!id) {
      return Promise.reject({ message: "部门ID不能为空" });
    }
    console.log("查询部门ID:", id);
    return instance.get(`/departments/${id}`);
  },

  // 获取所有员工列表（用于选择部门负责人）
  getAllEmployees() {
    return instance.get("/employees");
  },
};

export default api;
