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
  // 分页查询资产
  getAssetsPage(params) {
    // 确保所有参数都是正确的类型
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    // 只有在有值的情况下才添加参数
    if (params.id) {
      queryParams.id = parseInt(params.id);
    }
    if (params.name) {
      queryParams.name = params.name.trim();
    }
    if (params.price1 !== undefined && params.price1 !== "") {
      queryParams.price1 = parseFloat(params.price1);
    }
    if (params.price2 !== undefined && params.price2 !== "") {
      queryParams.price2 = parseFloat(params.price2);
    }

    console.log("发送查询参数:", queryParams);

    return instance.get("/assets/page", {
      params: queryParams,
      paramsSerializer: (params) => {
        return Object.entries(params)
          .filter(([_, value]) => value !== undefined && value !== "")
          .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
          .join("&");
      },
    });
  },
  // 新增资产
  addAsset(data) {
    // 数据预处理
    const submitData = {
      assetId: 0, // 设置默认值为0
      assetName: data.assetName?.trim(),
      assetType: data.assetType?.trim(),
      purchaseDate: new Date(data.purchaseDate).toISOString(),
      purchasePrice: Number(data.purchasePrice || 0),
      supplier: data.supplier?.trim(),
      warrantyEnd: new Date(data.warrantyEnd).toISOString(),
    };

    console.log("新增资产数据:", submitData);

    // 验证数据
    if (!submitData.assetName) {
      return Promise.reject({ message: "资产名称不能为空" });
    }
    if (!submitData.assetType) {
      return Promise.reject({ message: "资产类型不能为空" });
    }
    if (!submitData.purchaseDate) {
      return Promise.reject({ message: "购买日期不能为空" });
    }
    if (isNaN(submitData.purchasePrice) || submitData.purchasePrice <= 0) {
      return Promise.reject({ message: "购买价格必须大于0" });
    }
    if (!submitData.supplier) {
      return Promise.reject({ message: "供应商不能为空" });
    }
    if (!submitData.warrantyEnd) {
      return Promise.reject({ message: "保修期不能为空" });
    }
    if (new Date(submitData.warrantyEnd) < new Date(submitData.purchaseDate)) {
      return Promise.reject({ message: "保修期不能早于购买日期" });
    }

    return instance.post("/assets", submitData);
  },
  // 修改资产
  updateAsset(data) {
    if (!data.assetId) {
      return Promise.reject({ message: "资产ID不能为空" });
    }

    const submitData = {
      assetId: data.assetId,
      assetName: data.assetName?.trim(),
      assetType: data.assetType?.trim(),
      purchaseDate: data.purchaseDate,
      purchasePrice: parseFloat(data.purchasePrice).toFixed(2),
      supplier: data.supplier?.trim(),
      warrantyEnd: data.warrantyEnd,
    };

    console.log("更新资产数据:", submitData);

    return instance.put("/assets", submitData);
  },
  // 删除资产
  deleteAsset(id) {
    if (!id) {
      return Promise.reject({ message: "资产ID不能为空" });
    }
    console.log("删除资产ID:", id);
    return instance.delete(`/assets/${id}`);
  },
  // 查询单个资产
  getAssetById(id) {
    if (!id) {
      return Promise.reject({ message: "资产ID不能为空" });
    }
    console.log("查询资产ID:", id);
    return instance.get(`/assets/${id}`);
  },
};

export default api;
