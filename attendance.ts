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

    // 如果响应数据直接是success字符串，返回成功状态
    if (response.data === "success") {
      return {
        data: "success",
        status: 200,
      };
    }
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

    // 如果错误信息是success，说明实际上是成功的
    if (errorMessage === "success") {
      return {
        data: "success",
        status: 200,
      };
    }

    return Promise.reject({
      message: errorMessage,
      status: error.response?.status,
      data: error.response?.data,
      originalError: error,
    });
  }
);

const api = {
  // 分页查询考勤记录
  getAttendancePage(params) {
    // 确保所有参数都是正确的类型
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    // 只有在有值的情况下才添加参数
    if (params.employeeId) {
      queryParams.employeeId = parseInt(params.employeeId);
    }
    if (params.dateStart) {
      queryParams.dateStart = params.dateStart;
    }
    if (params.dateEnd) {
      queryParams.dateEnd = params.dateEnd;
    }
    if (params.status) {
      queryParams.status = params.status.trim();
    }
    if (params.keyword) {
      queryParams.keyword = params.keyword.trim();
    }

    console.log("发送查询参数:", queryParams);

    return instance.get("/attendance-records/page", {
      params: queryParams,
      paramsSerializer: (params) => {
        return Object.entries(params)
          .filter(([_, value]) => value !== undefined && value !== "")
          .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
          .join("&");
      },
    });
  },

  // 新增考勤记录
  addAttendance(data) {
    // 数据预处理
    const submitData = {
      recordId: 0,
      employeeId: parseInt(data.employeeId),
      date: new Date(data.date).toISOString(), // 转换为ISO格式
      checkInTime:
        data.status === "缺勤"
          ? null
          : new Date(`${data.date}T${data.checkInTime}`).toISOString(),
      checkOutTime:
        data.status === "缺勤"
          ? null
          : new Date(`${data.date}T${data.checkOutTime}`).toISOString(),
      status: data.status?.trim() || "正常",
      remark: data.remark?.trim() || "",
    };

    console.log("新增考勤记录数据:", submitData);

    // 验证数据
    if (!submitData.employeeId) {
      return Promise.reject({ message: "员工ID不能为空" });
    }
    if (!submitData.date) {
      return Promise.reject({ message: "日期不能为空" });
    }
    if (submitData.status !== "缺勤") {
      if (!data.checkInTime) {
        return Promise.reject({ message: "签到时间不能为空" });
      }
      if (!data.checkOutTime) {
        return Promise.reject({ message: "签退时间不能为空" });
      }
    }
    if (!submitData.status) {
      return Promise.reject({ message: "状态不能为空" });
    }

    return instance.post("/attendance-records", submitData);
  },

  // 修改考勤记录
  updateAttendance(data) {
    if (!data.recordId) {
      return Promise.reject({ message: "记录ID不能为空" });
    }

    const submitData = {
      recordId: parseInt(data.recordId),
      employeeId: parseInt(data.employeeId),
      date: data.date,
      checkInTime: data.checkInTime,
      checkOutTime: data.checkOutTime,
      status: data.status?.trim(),
      remark: data.remark?.trim() || "",
    };

    console.log("更新考勤记录数据:", submitData);

    return instance.put("/attendance-records", submitData);
  },

  // 删除考勤记录
  deleteAttendance(id) {
    if (!id) {
      return Promise.reject({ message: "记录ID不能为空" });
    }
    console.log("删除考勤记录ID:", id);
    return instance.delete(`/attendance-records/${id}`);
  },

  // 查询单个考勤记录
  getAttendanceById(id) {
    if (!id) {
      return Promise.reject({ message: "记录ID不能为空" });
    }
    console.log("查询考勤记录ID:", id);
    return instance.get(`/attendance-records/${id}`);
  },
};

export default api;
