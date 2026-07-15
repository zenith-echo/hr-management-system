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
  // 分页查询风险评估
  getRiskAssessmentPage(params) {
    // 确保所有参数都是正确的类型
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    // 只有在有值的情况下才添加参数
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }
    if (params.impactLevel) {
      queryParams.impactLevel = params.impactLevel;
    }
    if (params.probability) {
      queryParams.probability = params.probability;
    }
    if (params.responsiblePerson) {
      queryParams.responsiblePerson = parseInt(params.responsiblePerson);
    }
    if (params.assessmentDateStart) {
      queryParams.assessmentDateStart = params.assessmentDateStart;
    }
    if (params.assessmentDateEnd) {
      queryParams.assessmentDateEnd = params.assessmentDateEnd;
    }
    if (params.nextReviewStart) {
      queryParams.nextReviewStart = params.nextReviewStart;
    }
    if (params.nextReviewEnd) {
      queryParams.nextReviewEnd = params.nextReviewEnd;
    }

    console.log("发送查询参数:", queryParams);

    return instance.get("/risk-assessment/page", {
      params: queryParams,
      paramsSerializer: (params) => {
        return Object.entries(params)
          .filter(([_, value]) => value !== undefined && value !== "")
          .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
          .join("&");
      },
    });
  },

  // 根据ID获取风险评估
  getRiskAssessmentById(id) {
    if (!id) {
      return Promise.reject({ message: "风险评估ID不能为空" });
    }
    console.log("查询风险评估ID:", id);
    return instance.get(`/risk-assessment/${id}`);
  },

  // 新增风险评估
  addRiskAssessment(data) {
    // 数据预处理
    const submitData = {
      assessmentId: 0, // 设置默认值为0
      riskArea: data.riskArea?.trim(),
      description: data.description?.trim(),
      impactLevel: data.impactLevel,
      probability: data.probability,
      assessmentDate: data.assessmentDate,
      nextReview: data.nextReview,
    };

    console.log("新增风险评估数据:", submitData);

    // 验证数据
    if (!submitData.riskArea) {
      return Promise.reject({ message: "风险领域不能为空" });
    }
    if (!submitData.description) {
      return Promise.reject({ message: "风险描述不能为空" });
    }
    if (!submitData.impactLevel) {
      return Promise.reject({ message: "影响级别不能为空" });
    }
    if (
      !submitData.probability ||
      !["低", "中", "高"].includes(submitData.probability)
    ) {
      return Promise.reject({ message: "可能性只能是低、中、高" });
    }
    if (!submitData.assessmentDate) {
      return Promise.reject({ message: "评估日期不能为空" });
    }
    if (!submitData.nextReview) {
      return Promise.reject({ message: "下次审核日期不能为空" });
    }
    if (
      new Date(submitData.nextReview) <= new Date(submitData.assessmentDate)
    ) {
      return Promise.reject({ message: "下次审核日期必须晚于评估日期" });
    }

    return instance.post("/risk-assessment", submitData);
  },

  // 更新风险评估
  updateRiskAssessment(data) {
    if (!data.assessmentId) {
      return Promise.reject({ message: "风险评估ID不能为空" });
    }

    const submitData = {
      assessmentId: data.assessmentId,
      riskArea: data.riskArea?.trim(),
      description: data.description?.trim(),
      impactLevel: data.impactLevel,
      probability: data.probability,
      assessmentDate: data.assessmentDate,
      nextReview: data.nextReview,
    };

    console.log("更新风险评估数据:", submitData);

    // 执行与新增相同的数据验证
    if (!submitData.riskArea) {
      return Promise.reject({ message: "风险领域不能为空" });
    }
    if (!submitData.description) {
      return Promise.reject({ message: "风险描述不能为空" });
    }
    if (!submitData.impactLevel) {
      return Promise.reject({ message: "影响级别不能为空" });
    }
    if (
      !submitData.probability ||
      !["低", "中", "高"].includes(submitData.probability)
    ) {
      return Promise.reject({ message: "可能性只能是低、中、高" });
    }
    if (!submitData.assessmentDate) {
      return Promise.reject({ message: "评估日期不能为空" });
    }
    if (!submitData.nextReview) {
      return Promise.reject({ message: "下次审核日期不能为空" });
    }
    if (
      new Date(submitData.nextReview) <= new Date(submitData.assessmentDate)
    ) {
      return Promise.reject({ message: "下次审核日期必须晚于评估日期" });
    }

    return instance.put("/risk-assessment", submitData);
  },

  // 删除风险评估
  deleteRiskAssessment(id) {
    if (!id) {
      return Promise.reject({ message: "风险评估ID不能为空" });
    }
    console.log("删除风险评估ID:", id);
    return instance.delete(`/risk-assessment/${id}`);
  },
};

export default api;
