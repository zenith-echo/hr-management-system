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
  // 根据ID获取知识库详情
  getKnowledgeListById(id) {
    return instance.get(`/knowledge-base/${id}`);
  },

  // 分页查询知识库列表
  getKnowledgeListPage(params) {
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    // 处理分类ID
    if (params.categoryId) {
      queryParams.categoryId = Array.isArray(params.categoryId)
        ? params.categoryId[params.categoryId.length - 1]
        : params.categoryId;
    }

    // 处理创建日期范围
    if (params.createdDate && params.createdDate.length === 2) {
      queryParams.createdDateStart = params.createdDate[0];
      queryParams.createdDateEnd = params.createdDate[1];
    }

    // 处理标题关键字
    if (params.title) {
      queryParams.keyword = params.title.trim();
    }

    // 处理状态
    if (params.status) {
      queryParams.status = params.status;
    }

    return instance.get("/knowledge-base/page", { params: queryParams });
  },

  // 新增知识库
  addKnowledgeList(data) {
    const submitData = {
      title: data.title?.trim(),
      categoryId: Array.isArray(data.categoryId)
        ? data.categoryId[data.categoryId.length - 1]
        : data.categoryId,
      content: data.content?.trim(),
      status: data.status || "draft",
      createdBy: data.createdBy,
      createdDate: data.createdDate
        ? new Date(data.createdDate).toISOString()
        : undefined,
      lastUpdated: data.lastUpdated
        ? new Date(data.lastUpdated).toISOString()
        : undefined,
    };

    // 数据验证
    if (!submitData.title) {
      return Promise.reject({ message: "标题不能为空" });
    }
    if (!submitData.categoryId) {
      return Promise.reject({ message: "分类不能为空" });
    }
    if (!submitData.content) {
      return Promise.reject({ message: "内容不能为空" });
    }
    if (!submitData.createdBy) {
      return Promise.reject({ message: "创建者不能为空" });
    }
    if (!submitData.createdDate) {
      return Promise.reject({ message: "创建时间不能为空" });
    }
    if (!submitData.lastUpdated) {
      return Promise.reject({ message: "更新时间不能为空" });
    }

    return instance.post("/knowledge-base", submitData);
  },

  // 更新知识库
  updateKnowledgeList(data) {
    if (!data.kbId) {
      return Promise.reject({ message: "知识库ID不能为空" });
    }

    const submitData = {
      kbId: parseInt(data.kbId),
      title: data.title?.trim(),
      categoryId: Array.isArray(data.categoryId)
        ? data.categoryId[data.categoryId.length - 1]
        : data.categoryId,
      content: data.content?.trim(),
      status: data.status,
    };

    return instance.put("/knowledge-base", submitData);
  },

  // 删除知识库
  deleteKnowledgeList(id) {
    if (!id) {
      return Promise.reject({ message: "知识库ID不能为空" });
    }
    return instance.delete(`/knowledge-base/${id}`);
  },
};

export default api;
