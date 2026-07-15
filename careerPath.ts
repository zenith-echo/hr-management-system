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
  // 分页查询职业路径
  getCareerPathPage(params) {
    // 确保所有参数都是正确的类型
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    // 只有在有值的情况下才添加参数
    if (params.departmentId) {
      queryParams.departmentId = parseInt(params.departmentId);
    }
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }

    console.log("发送查询参数:", queryParams);

    return instance.get("/career-path/page", {
      params: queryParams,
      paramsSerializer: (params) => {
        return Object.entries(params)
          .filter(([_, value]) => value !== undefined && value !== "")
          .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
          .join("&");
      },
    });
  },

  // 新增职业路径
  addCareerPath(data) {
    // 数据预处理
    const submitData = {
      pathId: 0, // 设置默认值为0
      pathName: data.pathName?.trim(),
      departmentId: parseInt(data.departmentId),
      description: data.description?.trim(),
    };

    console.log("新增职业路径数据:", submitData);

    // 验证数据
    if (!submitData.pathName) {
      return Promise.reject({ message: "路径名称不能为空" });
    }
    if (!submitData.departmentId) {
      return Promise.reject({ message: "所属部门不能为空" });
    }
    if (!submitData.description) {
      return Promise.reject({ message: "路径描述不能为空" });
    }

    return instance.post("/career-path", submitData);
  },

  // 修改职业路径
  updateCareerPath(data) {
    if (!data.pathId) {
      return Promise.reject({ message: "路径ID不能为空" });
    }

    const submitData = {
      pathId: parseInt(data.pathId),
      pathName: data.pathName?.trim(),
      departmentId: parseInt(data.departmentId),
      description: data.description?.trim(),
    };

    console.log("更新职业路径数据:", submitData);

    return instance.put("/career-path", submitData);
  },

  // 删除职业路径
  deleteCareerPath(id) {
    if (!id) {
      return Promise.reject({ message: "路径ID不能为空" });
    }
    console.log("删除职业路径ID:", id);
    return instance.delete(`/career-path/${id}`);
  },

  // 查询单个职业路径
  getCareerPathById(id) {
    if (!id) {
      return Promise.reject({ message: "路径ID不能为空" });
    }
    console.log("查询职业路径ID:", id);
    return instance.get(`/career-path/${id}`);
  },
};

export default api;
