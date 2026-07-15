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
  // 分页查询政策确认
  getAcknowledgementPage(params) {
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    if (params.policyId) {
      queryParams.policyId = params.policyId;
    }
    if (params.employeeId) {
      queryParams.employeeId = params.employeeId;
    }
    if (params.ackDateStart) {
      queryParams.ackDateStart = params.ackDateStart;
    }
    if (params.ackDateEnd) {
      queryParams.ackDateEnd = params.ackDateEnd;
    }

    return instance.get("/policy-acknowledgement/page", {
      params: queryParams,
    });
  },

  // 获取单个确认记录
  getAcknowledgementById(id) {
    return instance.get(`/policy-acknowledgement/${id}`);
  },

  // 新增确认记录
  addAcknowledgement(data) {
    return instance.post("/policy-acknowledgement", data);
  },

  // 更新确认记录
  updateAcknowledgement(data) {
    return instance.put("/policy-acknowledgement", data);
  },

  // 删除确认记录
  deleteAcknowledgement(id) {
    return instance.delete(`/policy-acknowledgement/${id}`);
  },
};

export default api;
