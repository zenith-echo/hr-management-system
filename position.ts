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
  // 分页查询职位
  getPositionsPage(params) {
    const queryParams = {
      pageNum: parseInt(params.pageNum) || 1,
      pageSize: parseInt(params.pageSize) || 10,
    };

    if (params.positionName) {
      queryParams.keyword = params.positionName.trim();
    }
    if (params.departmentId) {
      queryParams.departmentId = parseInt(params.departmentId);
    }
    if (params.status) {
      queryParams.status = params.status;
    }

    return instance.get("/positions/page", { params: queryParams });
  },

  // 获取所有职位（用于下拉选择）
  getAllPositions() {
    return instance.get("/positions/page", {
      params: {
        pageSize: 1000, // 获取所有职位
      },
    });
  },

  // 获取单个职位
  getPositionById(id) {
    return instance.get(`/positions/${id}`);
  },

  // 新增职位
  addPosition(data) {
    const submitData = {
      positionName: data.positionName?.trim(),
      departmentId: parseInt(data.departmentId),
      positionLevel: data.positionLevel,
      baseSalary: parseFloat(data.baseSalary),
      responsibilities: data.responsibilities?.trim(),
      status: data.status,
    };

    return instance.post("/positions", submitData);
  },

  // 更新职位
  updatePosition(data) {
    const submitData = {
      positionId: parseInt(data.positionId),
      positionName: data.positionName?.trim(),
      departmentId: parseInt(data.departmentId),
      positionLevel: data.positionLevel,
      baseSalary: parseFloat(data.baseSalary),
      responsibilities: data.responsibilities?.trim(),
      status: data.status,
    };

    return instance.put("/positions", submitData);
  },

  // 删除职位
  deletePosition(id) {
    return instance.delete(`/positions/${id}`);
  },
};

export default api;
