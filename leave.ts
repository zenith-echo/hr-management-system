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

    return Promise.reject({
      message: error.response?.data?.message || error.message || "未知错误",
      status: error.response?.status,
      data: error.response?.data,
      originalError: error,
    });
  }
);

const api = {
  // 分页查询请假记录
  getLeavePage(params) {
    // 确保所有参数都是正确的类型
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    // 只有在有值的情况下才添加参数
    if (params.employeeId) {
      queryParams.employeeId = parseInt(params.employeeId);
    }
    if (params.leaveType) {
      queryParams.leaveType = params.leaveType.trim();
    }
    if (params.startDate) {
      queryParams.startDate = params.startDate;
    }
    if (params.endDate) {
      queryParams.endDate = params.endDate;
    }
    if (params.approverId) {
      queryParams.approverId = parseInt(params.approverId);
    }
    if (params.duration1) {
      queryParams.duration1 = parseFloat(params.duration1);
    }
    if (params.duration2) {
      queryParams.duration2 = parseFloat(params.duration2);
    }
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }

    console.log("发送查询参数:", queryParams);

    return instance.get("/leave-records/page", {
      params: queryParams,
    });
  },

  // 根据ID获取请假记录
  getLeaveById(id) {
    if (!id) {
      return Promise.reject({ message: "记录ID不能为空" });
    }
    return instance.get(`/leave-records/${id}`);
  },

  // 新增请假记录
  addLeave(data) {
    // 数据预处理
    const submitData = {
      recordId: 0, // 新增时ID为0
      employeeId: parseInt(data.employeeId),
      leaveType: data.leaveType?.trim(),
      startDate: data.startDate,
      endDate: data.endDate,
      duration: parseFloat(data.duration),
      reason: data.reason?.trim(),
      approverId: data.approverId ? parseInt(data.approverId) : null,
      approverComment: data.approverComment?.trim(),
      status: data.status || "待审批",
    };

    console.log("新增请假记录数据:", submitData);

    // 验证数据
    if (!submitData.employeeId) {
      return Promise.reject({ message: "员工ID不能为空" });
    }
    if (!submitData.leaveType) {
      return Promise.reject({ message: "请假类型不能为空" });
    }
    if (!submitData.startDate) {
      return Promise.reject({ message: "开始日期不能为空" });
    }
    if (!submitData.endDate) {
      return Promise.reject({ message: "结束日期不能为空" });
    }
    if (!submitData.duration) {
      return Promise.reject({ message: "请假时长不能为空" });
    }
    if (!submitData.reason) {
      return Promise.reject({ message: "请假原因不能为空" });
    }

    return instance.post("/leave-records", submitData);
  },

  // 更新请假记录
  updateLeave(data) {
    if (!data.recordId) {
      return Promise.reject({ message: "记录ID不能为空" });
    }

    const submitData = {
      recordId: parseInt(data.recordId),
      employeeId: parseInt(data.employeeId),
      leaveType: data.leaveType?.trim(),
      startDate: data.startDate,
      endDate: data.endDate,
      duration: parseFloat(data.duration),
      reason: data.reason?.trim(),
      approverId: data.approverId ? parseInt(data.approverId) : null,
      approverComment: data.approverComment?.trim(),
      status: data.status,
    };

    console.log("更新请假记录数据:", submitData);

    return instance.put("/leave-records", submitData);
  },

  // 删除请假记录
  deleteLeave(id) {
    if (!id) {
      return Promise.reject({ message: "记录ID不能为空" });
    }
    console.log("删除请假记录ID:", id);
    return instance.delete(`/leave-records/${id}`);
  },
};

export default api;
