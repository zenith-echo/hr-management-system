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
  // 分页查询员工
  getEmployeesPage(params) {
    // 过滤掉空值参数
    const queryParams = {};

    if (params.pageNum) queryParams.pageNum = params.pageNum;
    if (params.pageSize) queryParams.pageSize = params.pageSize;
    if (params.keyword) queryParams.keyword = params.keyword;
    if (params.status) queryParams.status = params.status;
    if (params.departmentId) queryParams.departmentId = params.departmentId;
    if (params.positionId) queryParams.positionId = params.positionId;
    if (params.gender) queryParams.gender = params.gender;
    if (params.birthDateStart)
      queryParams.birthDateStart = params.birthDateStart;
    if (params.birthDateEnd) queryParams.birthDateEnd = params.birthDateEnd;
    if (params.hireDateStart) queryParams.hireDateStart = params.hireDateStart;
    if (params.hireDateEnd) queryParams.hireDateEnd = params.hireDateEnd;
    if (params.employeeNo) queryParams.employeeNo = params.employeeNo;
    if (params.name) queryParams.name = params.name;

    // 确保至少有分页参数
    if (!queryParams.pageNum) queryParams.pageNum = 1;
    if (!queryParams.pageSize) queryParams.pageSize = 10;

    // 添加select参数，确保返回需要的字段
    queryParams.select = "employeeId,name,status";

    console.log("查询参数:", queryParams);
    return instance.get("/employees/page", { params: queryParams });
  },

  // 获取单个员工
  getEmployeeById(id) {
    return instance.get(`/employees/${id}`);
  },

  // 新增员工
  addEmployee(data) {
    // 数据预处理
    const submitData = {
      employeeId: 0, // 新增时设为0
      employeeNo: data.employeeNo?.trim(),
      name: data.name?.trim(),
      gender: data.gender,
      birthDate: data.birthDate,
      idCard: data.idCard?.trim(),
      phone: data.phone?.trim(),
      email: data.email?.trim(),
      address: data.address?.trim(),
      emergencyContact: data.emergencyContact?.trim(),
      emergencyPhone: data.emergencyPhone?.trim(),
      hireDate: data.hireDate,
      status: data.status,
      departmentId: Number(data.departmentId),
      positionId: Number(data.positionId),
      photo: data.photo,
    };

    console.log("新增员工数据:", submitData);
    return instance.post("/employees", submitData);
  },

  // 更新员工
  updateEmployee(data) {
    // 数据预处理
    const submitData = {
      employeeId: Number(data.employeeId),
      employeeNo: data.employeeNo?.trim(),
      name: data.name?.trim(),
      gender: data.gender,
      birthDate: data.birthDate,
      idCard: data.idCard?.trim(),
      phone: data.phone?.trim(),
      email: data.email?.trim(),
      address: data.address?.trim(),
      emergencyContact: data.emergencyContact?.trim(),
      emergencyPhone: data.emergencyPhone?.trim(),
      hireDate: data.hireDate,
      status: data.status,
      departmentId: Number(data.departmentId),
      positionId: Number(data.positionId),
      photo: data.photo,
    };

    console.log("更新员工数据:", submitData);
    return instance.put("/employees", submitData);
  },

  // 删除员工
  deleteEmployee(id) {
    return instance.delete(`/employees/${id}`);
  },

  // 导出员工数据
  exportEmployees(params) {
    return instance.get("/employees/export", {
      params,
      responseType: "blob",
    });
  },

  // 根据ID获取员工姓名
  getEmployeeNameById(id) {
    return instance.get(`/employees/${id}`, {
      params: {
        select: "employeeId,name", // 只获取ID和姓名字段
      },
    });
  },

  // 批量获取员工姓名
  getEmployeeNamesByIds(ids) {
    return instance.post("/employees/names", ids);
  },
};

export default api;
