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
    console.error("响应错误:", error);
    return Promise.reject(error);
  }
);

const api = {
  // 获取福利申请列表（分页）
  getClaimsList(params) {
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    if (params.employeeId) {
      queryParams.employeeId = params.employeeId;
    }
    if (params.benefitsplanId) {
      queryParams.benefitsplanId = params.benefitsplanId;
    }
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }
    if (params.claimDateStart) {
      queryParams.claimDateStart = params.claimDateStart;
    }
    if (params.claimDateEnd) {
      queryParams.claimDateEnd = params.claimDateEnd;
    }
    if (params.amountMin) {
      queryParams.amountMin = params.amountMin;
    }
    if (params.amountMax) {
      queryParams.amountMax = params.amountMax;
    }
    if (params.approvalDateStart) {
      queryParams.approvalDateStart = params.approvalDateStart;
    }
    if (params.approvalDateEnd) {
      queryParams.approvalDateEnd = params.approvalDateEnd;
    }
    if (params.approverId) {
      queryParams.approverId = params.approverId;
    }

    return instance.get("/benefits-claims/page", { params: queryParams });
  },

  // 添加福利申请
  addClaim(data) {
    return instance.post("/benefits-claims", {
      employeeId: data.employeeId,
      benefitsplanId: data.benefitsplanId,
      amount: data.amount,
      reason: data.reason,
      claimDate: data.claimDate,
      approverId: data.approverId,
      approvalDate: data.approvalDate,
    });
  },

  // 更新福利申请
  updateClaim(data) {
    return instance.put("/benefits-claims", {
      claimId: data.claimId,
      employeeId: data.employeeId,
      benefitsplanId: data.benefitsplanId,
      amount: data.amount,
      reason: data.reason,
      claimDate: data.claimDate,
      status: data.status,
      approverId: data.approverId,
      approvalDate: data.approvalDate,
    });
  },

  // 删除福利申请
  deleteClaim(id) {
    return instance.delete(`/benefits-claims/${id}`);
  },

  // 获取单个福利申请详情
  getClaimById(id) {
    return instance.get(`/benefits-claims/${id}`);
  },
};

export default api;
