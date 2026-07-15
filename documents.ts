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
  // 分页查询文档
  getDocumentsPage(params) {
    // 确保所有参数都是正确的类型
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    // 只有在有值的情况下才添加参数
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }
    if (params.documentType) {
      queryParams.documentType = params.documentType;
    }
    if (params.uploadDateStart) {
      queryParams.uploadDateStart = params.uploadDateStart;
    }
    if (params.uploadDateEnd) {
      queryParams.uploadDateEnd = params.uploadDateEnd;
    }
    if (params.version) {
      queryParams.version = params.version.trim();
    }
    if (params.uploaderId) {
      queryParams.uploaderId = params.uploaderId;
    }

    console.log("发送查询参数:", queryParams);

    return instance.get("/documents/page", {
      params: queryParams,
      paramsSerializer: (params) => {
        return Object.entries(params)
          .filter(([_, value]) => value !== undefined && value !== "")
          .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
          .join("&");
      },
    });
  },

  // 获取单个文档
  getDocumentById(id) {
    if (!id) {
      return Promise.reject({ message: "文档ID不能为空" });
    }
    console.log("查询文档ID:", id);
    return instance.get(`/documents/${id}`);
  },

  // 新增文档
  addDocument(data) {
    // 数据验证
    if (!data.title) {
      return Promise.reject({ message: "文档标题不能为空" });
    }
    if (!data.documentType) {
      return Promise.reject({ message: "文档类型不能为空" });
    }
    if (!data.description) {
      return Promise.reject({ message: "文档描述不能为空" });
    }

    console.log("新增文档数据:", {
      title: data.title,
      documentType: data.documentType,
      version: data.version,
      description: data.description,
      uploaderId: data.uploaderId,
    });

    return instance.post("/documents", data);
  },

  // 更新文档
  updateDocument(data) {
    if (!data.documentId) {
      return Promise.reject({ message: "文档ID不能为空" });
    }
    if (!data.title) {
      return Promise.reject({ message: "文档标题不能为空" });
    }
    if (!data.documentType) {
      return Promise.reject({ message: "文档类型不能为空" });
    }
    if (!data.description) {
      return Promise.reject({ message: "文档描述不能为空" });
    }

    console.log("更新文档数据:", {
      documentId: data.documentId,
      title: data.title,
      documentType: data.documentType,
      version: data.version,
      description: data.description,
      uploaderId: data.uploaderId,
    });

    return instance.put("/documents", data);
  },

  // 删除文档
  deleteDocument(id) {
    if (!id) {
      return Promise.reject({ message: "文档ID不能为空" });
    }
    console.log("删除文档ID:", id);
    return instance.delete(`/documents/${id}`);
  },
};

export default api;
 