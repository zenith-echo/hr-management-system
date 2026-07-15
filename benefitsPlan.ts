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
  // 获取福利计划列表（分页）
  getBenefitsPlanList(params) {
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }
    if (params.startDate) {
      queryParams.startDate = params.startDate;
    }
    if (params.endDate) {
      queryParams.endDate = params.endDate;
    }

    return instance.get("/benefits-plan/page", { params: queryParams });
  },

  // 添加福利计划
  addBenefitsPlan(data) {
    const requestData = {
      planName: data.planName,
      description: data.description,
      startDate: data.startDate,
      endDate: data.endDate,
    };

    console.log("添加请求数据:", requestData);
    return instance.post("/benefits-plan", requestData);
  },

  // 更新福利计划
  updateBenefitsPlan(data) {
    // 确保ID字段存在且为整数类型
    const benefitsplanId = parseInt(data.benefitsplanId);
    if (!benefitsplanId) {
      return Promise.reject(new Error("缺少必要的ID字段"));
    }

    const requestData = {
      benefitsplanId: benefitsplanId,
      planName: data.planName,
      description: data.description,
      startDate: data.startDate,
      endDate: data.endDate,
    };

    console.log("更新请求数据:", requestData);
    return instance.put("/benefits-plan", requestData);
  },

  // 删除福利计划
  deleteBenefitsPlan(id) {
    return instance.delete(`/benefits-plan/${id}`);
  },

  // 获取单个福利计划详情
  getBenefitsPlanById(id) {
    return instance.get(`/benefits-plan/${id}`);
  },
};

export default api;
