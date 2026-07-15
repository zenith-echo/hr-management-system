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
    console.log("发送请求配置:", config);
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
    console.log("接收响应:", response);
    return response;
  },
  (error) => {
    console.error("响应错误:", error);
    return Promise.reject(error);
  }
);

const api = {
  // 分页查询维护记录
  getMaintenancePage(params) {
    const queryParams = {
      pageNum: params.pageNum || 1,
      pageSize: params.pageSize || 10,
      keyword: params.keyword || "",
      date1: params.startDate || "",
      date2: params.endDate || "",
      assetId: params.assetId || "",
    };

    return instance.get("/asset-maintenance/page", { params: queryParams });
  },

  // 获取单个维护记录
  getMaintenanceById(id) {
    return instance.get(`/asset-maintenance/${id}`);
  },

  // 新增维护记录
  addMaintenance(data) {
    // 数据预处理
    const submitData = {
      maintenanceId: 0, // 新增时设为0，让数据库自增
      assetId: Number(data.assetId),
      maintenanceType: data.maintenanceType,
      maintenanceDate: data.maintenanceDate, // 使用原始日期格式 YYYY-MM-DD
      cost: data.cost, // 直接发送数字
      provider: data.provider?.trim() || "",
      notes: data.notes?.trim() || "",
    };

    console.log("新增维护记录数据:", JSON.stringify(submitData, null, 2));

    // 验证数据
    if (!submitData.assetId) {
      return Promise.reject({ message: "资产ID不能为空" });
    }
    if (!submitData.maintenanceType) {
      return Promise.reject({ message: "维护类型不能为空" });
    }
    if (!submitData.maintenanceDate) {
      return Promise.reject({ message: "维护日期不能为空" });
    }
    if (isNaN(submitData.cost) || submitData.cost < 0) {
      return Promise.reject({ message: "维护费用必须大于等于0" });
    }
    if (!submitData.provider) {
      return Promise.reject({ message: "服务提供商不能为空" });
    }

    return instance.post("/asset-maintenance", submitData);
  },

  // 更新维护记录
  updateMaintenance(data) {
    if (!data.maintenanceId) {
      return Promise.reject({ message: "维护记录ID不能为空" });
    }

    // 数据预处理
    const submitData = {
      maintenanceId: Number(data.maintenanceId),
      assetId: Number(data.assetId),
      maintenanceType: data.maintenanceType,
      maintenanceDate: data.maintenanceDate, // 使用原始日期格式 YYYY-MM-DD
      cost: data.cost, // 直接发送数字
      provider: data.provider?.trim() || "",
      notes: data.notes?.trim() || "",
    };

    console.log("更新维护记录数据:", JSON.stringify(submitData, null, 2));

    // 验证数据
    if (!submitData.assetId) {
      return Promise.reject({ message: "资产ID不能为空" });
    }
    if (!submitData.maintenanceType) {
      return Promise.reject({ message: "维护类型不能为空" });
    }
    if (!submitData.maintenanceDate) {
      return Promise.reject({ message: "维护日期不能为空" });
    }
    if (isNaN(submitData.cost) || submitData.cost < 0) {
      return Promise.reject({ message: "维护费用必须大于等于0" });
    }
    if (!submitData.provider) {
      return Promise.reject({ message: "服务提供商不能为空" });
    }

    return instance.put("/asset-maintenance", submitData);
  },

  // 删除维护记录
  deleteMaintenance(id) {
    return instance.delete(`/asset-maintenance/${id}`);
  },
};

export default api;
