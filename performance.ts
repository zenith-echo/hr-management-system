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
  // 分页查询绩效评估
  getPerformanceList(params) {
    // 确保所有参数都是正确的类型
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    // 只有在有值的情况下才添加参数
    if (params.employeeId) {
      queryParams.employeeId = parseInt(params.employeeId);
    }
    if (params.evaluatorId) {
      queryParams.evaluatorId = parseInt(params.evaluatorId);
    }
    if (params.startDate) {
      queryParams.startDate = params.startDate;
    }
    if (params.endDate) {
      queryParams.endDate = params.endDate;
    }
    if (params.score1 !== undefined && params.score1 !== "") {
      queryParams.score1 = parseFloat(params.score1);
    }
    if (params.score2 !== undefined && params.score2 !== "") {
      queryParams.score2 = parseFloat(params.score2);
    }
    if (params.level) {
      queryParams.level = params.level.trim();
    }
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }

    console.log("发送查询参数:", queryParams);

    return instance.get("/performance-evaluation/page", {
      params: queryParams,
      paramsSerializer: (params) => {
        return Object.entries(params)
          .filter(([_, value]) => value !== undefined && value !== "")
          .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
          .join("&");
      },
    });
  },

  // 根据ID获取绩效评估详情
  getPerformanceById(id) {
    if (!id) {
      return Promise.reject({ message: "评估ID不能为空" });
    }
    console.log("查询评估ID:", id);
    return instance.get(`/performance-evaluation/${id}`);
  },

  // 新增绩效评估
  addPerformance(data) {
    // 数据预处理
    const submitData = {
      evaluationId: 0, // 设置默认值为0
      employeeId: parseInt(data.employeeId),
      evaluatorId: parseInt(data.evaluatorId),
      startDate: new Date(data.startDate).toISOString(),
      endDate: new Date(data.endDate).toISOString(),
      score: parseFloat(data.score || 0),
      level: data.level?.trim(),
      comments: data.comments?.trim(),
    };

    console.log("新增评估数据:", submitData);

    // 验证数据
    if (!submitData.employeeId) {
      return Promise.reject({ message: "员工ID不能为空" });
    }
    if (!submitData.evaluatorId) {
      return Promise.reject({ message: "评估人ID不能为空" });
    }
    if (!submitData.startDate) {
      return Promise.reject({ message: "开始日期不能为空" });
    }
    if (!submitData.endDate) {
      return Promise.reject({ message: "结束日期不能为空" });
    }
    if (new Date(submitData.endDate) < new Date(submitData.startDate)) {
      return Promise.reject({ message: "结束日期不能早于开始日期" });
    }
    if (
      isNaN(submitData.score) ||
      submitData.score < 0 ||
      submitData.score > 100
    ) {
      return Promise.reject({ message: "评分必须在0-100之间" });
    }
    if (!submitData.level) {
      return Promise.reject({ message: "等级不能为空" });
    }
    if (!submitData.comments) {
      return Promise.reject({ message: "评语不能为空" });
    }

    return instance.post("/performance-evaluation", submitData);
  },

  // 更新绩效评估
  updatePerformance(data) {
    if (!data.evaluationId) {
      return Promise.reject({ message: "评估ID不能为空" });
    }

    const submitData = {
      evaluationId: parseInt(data.evaluationId),
      employeeId: parseInt(data.employeeId),
      evaluatorId: parseInt(data.evaluatorId),
      startDate: new Date(data.startDate).toISOString(),
      endDate: new Date(data.endDate).toISOString(),
      score: parseFloat(data.score).toFixed(2),
      level: data.level?.trim(),
      comments: data.comments?.trim(),
    };

    console.log("更新评估数据:", submitData);

    return instance.put("/performance-evaluation", submitData);
  },

  // 删除绩效评估
  deletePerformance(id) {
    if (!id) {
      return Promise.reject({ message: "评估ID不能为空" });
    }
    console.log("删除评估ID:", id);
    return instance.delete(`/performance-evaluation/${id}`);
  },
};

export default api;
