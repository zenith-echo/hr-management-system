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
  // 分页查询职业阶段
  getCareerStagePage(params) {
    // 确保所有参数都是正确的类型
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    // 只有在有值的情况下才添加参数
    if (params.pathId) {
      queryParams.pathId = parseInt(params.pathId);
    }
    if (params.level) {
      queryParams.level = parseInt(params.level);
    }
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }

    console.log("发送查询参数:", queryParams);

    return instance.get("/career-stage/page", {
      params: queryParams,
      paramsSerializer: (params) => {
        return Object.entries(params)
          .filter(([_, value]) => value !== undefined && value !== "")
          .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
          .join("&");
      },
    });
  },

  // 新增职业阶段
  addCareerStage(data) {
    // 数据预处理
    const submitData = {
      stageId: 0, // 设置默认值为0
      pathId: parseInt(data.pathId),
      stageName: data.stageName?.trim(),
      level: parseInt(data.level),
      requirements: data.requirements?.trim(),
    };

    console.log("新增职业阶段数据:", submitData);

    // 验证数据
    if (!submitData.pathId) {
      return Promise.reject({ message: "请选择职业路径" });
    }
    if (!submitData.stageName) {
      return Promise.reject({ message: "阶段名称不能为空" });
    }
    if (!submitData.level) {
      return Promise.reject({ message: "请选择级别" });
    }
    if (!submitData.requirements) {
      return Promise.reject({ message: "阶段要求不能为空" });
    }

    return instance.post("/career-stage", submitData);
  },

  // 修改职业阶段
  updateCareerStage(data) {
    if (!data.stageId) {
      return Promise.reject({ message: "阶段ID不能为空" });
    }

    const submitData = {
      stageId: parseInt(data.stageId),
      pathId: parseInt(data.pathId),
      stageName: data.stageName?.trim(),
      level: parseInt(data.level),
      requirements: data.requirements?.trim(),
    };

    console.log("更新职业阶段数据:", submitData);

    return instance.put("/career-stage", submitData);
  },

  // 删除职业阶段
  deleteCareerStage(id) {
    if (!id) {
      return Promise.reject({ message: "阶段ID不能为空" });
    }
    console.log("删除职业阶段ID:", id);
    return instance.delete(`/career-stage/${id}`);
  },

  // 查询单个职业阶段
  getCareerStageById(id) {
    if (!id) {
      return Promise.reject({ message: "阶段ID不能为空" });
    }
    console.log("查询职业阶段ID:", id);
    return instance.get(`/career-stage/${id}`);
  },
};

export default api;
