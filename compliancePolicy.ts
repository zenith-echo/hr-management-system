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
  // 分页查询合规政策
  getPolicyPage(params) {
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }
    if (params.effectiveDateStart) {
      queryParams.effectiveDateStart = params.effectiveDateStart;
    }
    if (params.effectiveDateEnd) {
      queryParams.effectiveDateEnd = params.effectiveDateEnd;
    }
    if (params.reviewDateStart) {
      queryParams.reviewDateStart = params.reviewDateStart;
    }
    if (params.reviewDateEnd) {
      queryParams.reviewDateEnd = params.reviewDateEnd;
    }

    return instance.get("/compliance-policy/page", { params: queryParams });
  },

  // 获取单个政策
  getPolicyById(id) {
    return instance.get(`/compliance-policy/${id}`);
  },

  // 新增政策
  addPolicy(data) {
    return instance.post("/compliance-policy", data);
  },

  // 更新政策
  updatePolicy(data) {
    return instance.put("/compliance-policy", data);
  },

  // 删除政策
  deletePolicy(id) {
    return instance.delete(`/compliance-policy/${id}`);
  },
};

export default api;
