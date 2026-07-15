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
  // 获取所有知识库分类
  //getAllCategories() {
  //   return instance.get("/kb-category");
  // },

  // 根据ID获取知识库分类
  getCategoryById(id) {
    return instance.get(`/kb-category/${id}`);
  },

  // 分页查询知识库分类
  getCategoriesPage(params) {
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    if (params.parentId !== undefined && params.parentId !== null) {
      queryParams.parentId = parseInt(params.parentId);
    }
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }

    return instance.get("/kb-category/page", { params: queryParams });
  },

  // 新增知识库分类
  addCategory(data) {
    const submitData = {
      categoryName: data.name?.trim(),
      parentId: data.parentId || null,
      description: data.description?.trim(),
    };

    if (!submitData.categoryName) {
      return Promise.reject({ message: "分类名称不能为空" });
    }

    return instance.post("/kb-category", submitData);
  },

  // 更新知识库分类
  updateCategory(data) {
    if (!data.categoryId) {
      return Promise.reject({ message: "分类ID不能为空" });
    }

    const submitData = {
      categoryId: data.categoryId,
      categoryName: data.name?.trim(),
      parentId: data.parentId || null,
      description: data.description?.trim(),
    };

    return instance.put("/kb-category", submitData);
  },

  // 删除知识库分类
  deleteCategory(id) {
    if (!id) {
      return Promise.reject({ message: "分类ID不能为空" });
    }
    return instance.delete(`/kb-category/${id}`);
  },
};

export default api;
