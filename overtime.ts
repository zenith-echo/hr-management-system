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
  // 分页查询加班记录
  getOvertimePage(params) {
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
    if (params.duration1) {
      queryParams.duration1 = parseFloat(params.duration1);
    }
    if (params.duration2) {
      queryParams.duration2 = parseFloat(params.duration2);
    }
    if (params.startTime) {
      queryParams.startTime = params.startTime;
    }
    if (params.endTime) {
      queryParams.endTime = params.endTime;
    }

    return instance.get("/overtime-record/page", { params: queryParams });
  },

  // 根据ID获取加班记录
  getOvertimeById(id) {
    if (!id) {
      return Promise.reject({ message: "记录ID不能为空" });
    }
    return instance.get(`/overtime-record/${id}`);
  },

  // 新增加班记录
  addOvertime(data) {
    // 数据预处理
    const submitData = {
      recordId: 0, // 新增时ID为0
      employeeId: parseInt(data.employeeId),
      date: data.date,
      startTime: data.startTime,
      endTime: data.endTime,
      duration: parseFloat(data.duration),
      approverId: data.approverId ? parseInt(data.approverId) : null,
      remark: data.remark || "",
    };

    console.log("新增加班记录数据:", submitData);

    // 验证数据
    if (!submitData.employeeId || isNaN(submitData.employeeId)) {
      return Promise.reject({ message: "员工ID不能为空或格式不正确" });
    }
    if (!submitData.date) {
      return Promise.reject({ message: "加班日期不能为空" });
    }
    if (!submitData.startTime) {
      return Promise.reject({ message: "开始时间不能为空" });
    }
    if (!submitData.endTime) {
      return Promise.reject({ message: "结束时间不能为空" });
    }
    if (!submitData.duration || isNaN(submitData.duration)) {
      return Promise.reject({ message: "加班时长不能为空或格式不正确" });
    }
    if (!submitData.approverId || isNaN(submitData.approverId)) {
      return Promise.reject({ message: "审批人不能为空或格式不正确" });
    }

    return instance.post("/overtime-record", submitData);
  },

  // 更新加班记录
  updateOvertime(data) {
    if (!data.recordId) {
      return Promise.reject({ message: "记录ID不能为空" });
    }

    const submitData = {
      recordId: parseInt(data.recordId),
      employeeId: parseInt(data.employeeId),
      date: data.date,
      startTime: data.startTime,
      endTime: data.endTime,
      duration: parseFloat(data.duration),
      approverId: data.approverId ? parseInt(data.approverId) : null,
      remark: data.remark || "",
    };

    // 验证数据
    if (!submitData.employeeId || isNaN(submitData.employeeId)) {
      return Promise.reject({ message: "员工ID不能为空或格式不正确" });
    }
    if (!submitData.date) {
      return Promise.reject({ message: "加班日期不能为空" });
    }
    if (!submitData.startTime) {
      return Promise.reject({ message: "开始时间不能为空" });
    }
    if (!submitData.endTime) {
      return Promise.reject({ message: "结束时间不能为空" });
    }
    if (!submitData.duration || isNaN(submitData.duration)) {
      return Promise.reject({ message: "加班时长不能为空或格式不正确" });
    }
    if (!submitData.approverId || isNaN(submitData.approverId)) {
      return Promise.reject({ message: "审批人不能为空或格式不正确" });
    }

    console.log("更新加班记录数据:", submitData);

    return instance.put("/overtime-record", submitData);
  },

  // 删除加班记录
  deleteOvertime(id) {
    if (!id) {
      return Promise.reject({ message: "记录ID不能为空" });
    }
    return instance.delete(`/overtime-record/${id}`);
  },
};

export default api;
