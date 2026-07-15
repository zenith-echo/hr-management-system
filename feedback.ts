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
  // 获取所有知识库反馈
  getAllFeedbacks() {
    return instance.get("/kb-feedback");
  },

  // 根据ID获取知识库反馈
  getFeedbackById(id) {
    return instance.get(`/kb-feedback/${id}`);
  },

  // 分页查询知识库反馈
  getFeedbacksPage(params) {
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    if (params.kbId) {
      queryParams.kbId = parseInt(params.kbId);
    }
    if (params.employeeId) {
      queryParams.employeeId = parseInt(params.employeeId);
    }
    if (params.rating) {
      queryParams.rating = parseInt(params.rating);
    }
    if (params.feedbackDateStart) {
      queryParams.feedbackDateStart = new Date(
        params.feedbackDateStart
      ).toISOString();
    }
    if (params.feedbackDateEnd) {
      queryParams.feedbackDateEnd = new Date(
        params.feedbackDateEnd
      ).toISOString();
    }
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }

    return instance.get("/kb-feedback/page", { params: queryParams });
  },

  // 新增知识库反馈
  addFeedback(data) {
    const submitData = {
      kbId: parseInt(data.kbId),
      employeeId: parseInt(data.employeeId),
      rating: parseInt(data.rating),
      comment: data.comment?.trim(),
      feedbackDate: new Date().toISOString(), // 使用完整的ISO格式
    };

    // 数据验证
    if (!submitData.kbId) {
      return Promise.reject({ message: "知识库ID不能为空" });
    }
    if (!submitData.employeeId) {
      return Promise.reject({ message: "员工ID不能为空" });
    }
    if (!submitData.rating) {
      return Promise.reject({ message: "评分不能为空" });
    }
    if (!submitData.comment) {
      return Promise.reject({ message: "评论不能为空" });
    }

    return instance.post("/kb-feedback", submitData);
  },

  // 更新知识库反馈
  updateFeedback(data) {
    if (!data.feedbackId) {
      return Promise.reject({ message: "反馈ID不能为空" });
    }

    const submitData = {
      feedbackId: parseInt(data.feedbackId),
      kbId: parseInt(data.kbId),
      employeeId: parseInt(data.employeeId),
      rating: parseInt(data.rating),
      comment: data.comment?.trim(),
      feedbackDate: data.feedbackDate
        ? new Date(data.feedbackDate).toISOString().slice(0, 10)
        : undefined,
    };

    return instance.put("/kb-feedback", submitData);
  },

  // 删除知识库反馈
  deleteFeedback(id) {
    if (!id) {
      return Promise.reject({ message: "反馈ID不能为空" });
    }
    return instance.delete(`/kb-feedback/${id}`);
  },
};

export default api;
