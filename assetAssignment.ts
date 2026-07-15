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
  // 分页查询分配记录
  getAssignmentPage(params) {
    const queryParams = {
      pageNum: params.pageNum || 1,
      pageSize: params.pageSize || 10,
      keyword: params.keyword || "",
      assetId: params.assetId || null,
      employeeId: params.employeeId || null,
      status: params.status || null,
    };

    console.log("查询参数:", queryParams);
    return instance.get("/asset-assignment/page", { params: queryParams });
  },

  // 获取单个分配记录
  getAssignmentById(id) {
    return instance.get(`/asset-assignment/${id}`);
  },

  // 新增分配记录
  addAssignment(data) {
    const submitData = {
      assignmentId: 0, // 新增时设为0
      assetId: Number(data.assetId),
      employeeId: Number(data.employeeId),
      assignDate: data.assignDate,
      returnDate: data.returnDate || null,
      conditionBefore: data.conditionBefore?.trim() || "",
      conditionAfter: data.conditionAfter?.trim() || "",
      notes: data.notes?.trim() || "",
    };

    console.log("新增分配记录数据:", submitData);
    return instance.post("/asset-assignment", submitData);
  },

  // 更新分配记录
  updateAssignment(data) {
    // 确保所有必要字段都存在且类型正确
    const submitData = {
      assignmentId: Number(data.assignmentId),
      assetId: Number(data.assetId),
      employeeId: Number(data.employeeId),
      assignDate: data.assignDate,
      returnDate: data.returnDate,
      notes: data.notes?.trim() || "",
    };

    // 移除所有undefined和null值
    Object.keys(submitData).forEach((key) => {
      if (submitData[key] === undefined || submitData[key] === null) {
        delete submitData[key];
      }
    });

    console.log("API - 更新分配记录数据:", submitData);
    return instance.put("/asset-assignment", submitData);
  },

  // 删除分配记录
  deleteAssignment(id) {
    return instance.delete(`/asset-assignment/${id}`);
  },
};

export default api;
