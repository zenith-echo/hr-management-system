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
  // 分页查询文档分类
  getCategoryPage(params) {
    // 确保所有参数都是正确的类型
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    // 只有在有值的情况下才添加参数
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }
    if (params.parentId) {
      queryParams.parentId = parseInt(params.parentId);
    }

    console.log("发送查询参数:", queryParams);

    return instance.get("/document-category/page", {
      params: queryParams,
      paramsSerializer: (params) => {
        return Object.entries(params)
          .filter(([_, value]) => value !== undefined && value !== "")
          .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
          .join("&");
      },
    });
  },

  // 获取单个分类
  getCategory(categoryId) {
    if (!categoryId) {
      return Promise.reject({ message: "分类ID不能为空" });
    }
    console.log("查询分类ID:", categoryId);
    return instance.get(`/document-category/${categoryId}`);
  },

  // 新增分类
  addCategory(data) {
    // 数据验证
    if (!data.categoryName) {
      return Promise.reject({ message: "分类名称不能为空" });
    }

    const submitData = {
      categoryName: data.categoryName.trim(),
      parentId: data.parentId || null,
      description: data.description?.trim() || "",
    };

    console.log("新增分类数据:", submitData);

    return instance.post("/document-category", submitData);
  },

  // 更新分类
  updateCategory(data) {
    if (!data.categoryId) {
      return Promise.reject({ message: "分类ID不能为空" });
    }
    if (!data.categoryName) {
      return Promise.reject({ message: "分类名称不能为空" });
    }

    const submitData = {
      categoryId: data.categoryId,
      categoryName: data.categoryName.trim(),
      parentId: data.parentId || null,
      description: data.description?.trim() || "",
    };

    console.log("更新分类数据:", submitData);

    return instance.put("/document-category", submitData);
  },

  // 删除分类
  deleteCategory(categoryId) {
    if (!categoryId) {
      return Promise.reject({ message: "分类ID不能为空" });
    }
    console.log("删除分类ID:", categoryId);
    return instance.delete(`/document-category/${categoryId}`);
  },
};

export default api;
