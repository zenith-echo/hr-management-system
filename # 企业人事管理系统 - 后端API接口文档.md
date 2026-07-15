# 企业人事管理系统 - 后端API接口文档

## 概述

本文档列出了企业人事管理系统的所有对外RESTful接口，包含接口地址、HTTP方法、功能描述及参数说明。

---

## 模块总览

| 模块 | 路径前缀 | 功能描述 |
|------|----------|----------|
| 员工管理 | `/employees` | 员工信息的增删改查 |
| 部门管理 | `/departments` | 部门信息的增删改查 |
| 职位管理 | `/positions` | 职位信息的增删改查 |
| 考勤管理 | `/attendance-records` | 考勤记录管理 |
| 请假管理 | `/leave-records` | 请假记录管理 |
| 薪资管理 | `/salary-records` | 薪资记录管理 |
| 资产管理 | `/assets` | 资产信息管理 |
| 培训管理 | `/training-course` | 培训课程管理 |
| 招聘管理 | `/job-posting` | 职位发布管理 |
| 公告管理 | `/announcements` | 公告信息管理 |
| 知识库管理 | `/knowledge-base` | 知识库管理 |
| 项目管理 | `/projects` | 项目信息管理 |

---

## 1. 员工管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/employees/{id}` | 根据ID查询员工 |
| POST | `/employees` | 新增员工 |
| PUT | `/employees` | 修改员工信息 |
| DELETE | `/employees/{id}` | 删除员工 |
| GET | `/employees/page` | 分页查询员工列表 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认20 |
| keyword | String | 否 | 模糊查询（姓名、住址、紧急联系人） |
| status | String | 否 | 员工状态（在职/离职/休假/试用期） |
| departmentId | Integer | 否 | 部门ID |
| positionId | Integer | 否 | 职位ID |
| birthDateStart | String | 否 | 出生日期范围开始 |
| birthDateEnd | String | 否 | 出生日期范围结束 |
| hireDateStart | String | 否 | 入职日期范围开始 |
| hireDateEnd | String | 否 | 入职日期范围结束 |
| gender | String | 否 | 性别 |

---

## 2. 部门管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/departments` | 批量查询部门（未实现） |
| GET | `/departments/{id}` | 根据ID查询部门 |
| POST | `/departments` | 新增部门 |
| PUT | `/departments` | 修改部门信息 |
| DELETE | `/departments/{id}` | 删除部门 |
| GET | `/departments/page` | 分页查询部门列表 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认10 |
| keyword | String | 否 | 部门名称模糊查询 |
| parentId | Integer | 否 | 上级部门ID |
| managerId | Integer | 否 | 部门负责人ID |

---

## 3. 职位管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/positions` | 批量查询职位（未实现） |
| GET | `/positions/{id}` | 根据ID查询职位 |
| POST | `/positions` | 新增职位 |
| PUT | `/positions` | 修改职位信息 |
| DELETE | `/positions/{id}` | 删除职位 |
| GET | `/positions/page` | 分页查询职位列表 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认10 |
| keyword | String | 否 | 职位名称、描述模糊查询 |
| departmentId | Integer | 否 | 部门ID |
| salary1 | Double | 否 | 薪资下限 |
| salary2 | Double | 否 | 薪资上限 |
| level | String | 否 | 职位等级 |

---

## 4. 考勤管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/attendance-records` | 批量查询考勤（未实现） |
| GET | `/attendance-records/{id}` | 根据ID查询考勤记录 |
| POST | `/attendance-records` | 新增考勤记录 |
| PUT | `/attendance-records` | 修改考勤记录 |
| DELETE | `/attendance-records/{id}` | 删除考勤记录 |
| GET | `/attendance-records/page` | 分页查询考勤记录 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认10 |
| employeeId | Integer | 否 | 员工ID |
| dateStart | String | 否 | 考勤日期起始 |
| dateEnd | String | 否 | 考勤日期结束 |
| status | String | 否 | 考勤状态 |
| checkinTime | String | 否 | 签到时间 |
| checkoutTime | String | 否 | 签退时间 |
| keyword | String | 否 | 备注模糊查询 |

---

## 5. 请假管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/leave-records` | 批量查询请假（未实现） |
| GET | `/leave-records/{id}` | 根据ID查询请假记录 |
| POST | `/leave-records` | 新增请假记录 |
| PUT | `/leave-records` | 修改请假记录 |
| DELETE | `/leave-records/{id}` | 删除请假记录 |
| GET | `/leave-records/page` | 分页查询请假记录 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认10 |
| employeeId | Integer | 否 | 员工ID |
| leaveType | String | 否 | 请假类型 |
| startDate | String | 否 | 请假起始日期 |
| endDate | String | 否 | 请假结束日期 |
| approverId | Integer | 否 | 审批人ID |
| duration1 | Double | 否 | 请假时长下限 |
| duration2 | Double | 否 | 请假时长上限 |
| keyword | String | 否 | 请假事由模糊查询 |

---

## 6. 薪资管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/salary-records` | 批量查询薪资（未实现） |
| GET | `/salary-records/{id}` | 根据ID查询薪资记录 |
| POST | `/salary-records` | 新增薪资记录 |
| PUT | `/salary-records` | 修改薪资记录 |
| DELETE | `/salary-records/{id}` | 删除薪资记录 |
| GET | `/salary-records/page` | 分页查询薪资记录 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认10 |
| employeeId | Integer | 否 | 员工ID |
| year | Integer | 否 | 年份 |
| month | Integer | 否 | 月份 |
| paymentStatus | String | 否 | 支付状态 |
| bonusMin | Double | 否 | 奖金下限 |
| bonusMax | Double | 否 | 奖金上限 |
| netSalaryMin | Double | 否 | 实发薪资下限 |
| netSalaryMax | Double | 否 | 实发薪资上限 |
| paymentDateStart | String | 否 | 支付日期起始 |
| paymentDateEnd | String | 否 | 支付日期结束 |

---

## 7. 资产管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/assets` | 批量查询资产（未实现） |
| GET | `/assets/{id}` | 根据ID查询资产 |
| POST | `/assets` | 新增资产 |
| PUT | `/assets` | 修改资产信息 |
| DELETE | `/assets/{id}` | 删除资产 |
| GET | `/assets/page` | 分页查询资产列表 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认20 |
| name | String | 否 | 资产名称 |
| price1 | Double | 否 | 价格下限 |
| price2 | Double | 否 | 价格上限 |
| id | Integer | 否 | 资产ID |

---

## 8. 培训管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/training-course` | 批量查询课程（未实现） |
| GET | `/training-course/{id}` | 根据ID查询培训课程 |
| POST | `/training-course` | 新增培训课程 |
| PUT | `/training-course` | 修改培训课程 |
| DELETE | `/training-course/{id}` | 删除培训课程 |
| GET | `/training-course/page` | 分页查询培训课程 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认10 |
| durationMin | Integer | 否 | 最短时长 |
| durationMax | Integer | 否 | 最长时长 |
| costMin | Double | 否 | 最低成本 |
| costMax | Double | 否 | 最高成本 |
| keyword | String | 否 | 课程名称或培训师模糊查询 |

---

## 9. 招聘管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/job-posting` | 批量查询职位（未实现） |
| GET | `/job-posting/{id}` | 根据ID查询职位发布 |
| POST | `/job-posting` | 新增职位发布 |
| PUT | `/job-posting` | 修改职位发布 |
| DELETE | `/job-posting/{id}` | 删除职位发布 |
| GET | `/job-posting/page` | 分页查询职位发布 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认10 |
| departmentId | Integer | 否 | 部门ID |
| publishDateStart | String | 否 | 发布日期起始 |
| publishDateEnd | String | 否 | 发布日期结束 |
| deadlineStart | String | 否 | 截止日期起始 |
| deadlineEnd | String | 否 | 截止日期结束 |
| headcountMin | Integer | 否 | 招聘人数下限 |
| headcountMax | Integer | 否 | 招聘人数上限 |
| keyword | String | 否 | 薪资范围或职位要求模糊查询 |

---

## 10. 公告管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/announcements` | 批量查询公告（未实现） |
| GET | `/announcements/{id}` | 根据ID查询公告 |
| POST | `/announcements` | 新增公告 |
| PUT | `/announcements` | 修改公告 |
| DELETE | `/announcements/{id}` | 删除公告 |
| GET | `/announcements/page` | 分页查询公告 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认10 |
| priority | String | 否 | 优先级 |
| targetAudience | String | 否 | 目标受众 |
| postedBy | Integer | 否 | 发布人ID |
| postDateStart | String | 否 | 发布时间起始 |
| postDateEnd | String | 否 | 发布时间结束 |
| expiryDateStart | String | 否 | 过期时间起始 |
| expiryDateEnd | String | 否 | 过期时间结束 |
| keyword | String | 否 | 标题/内容模糊查询 |

---

## 11. 知识库管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/knowledge-base` | 批量查询（未实现） |
| GET | `/knowledge-base/{id}` | 根据ID查询知识库 |
| POST | `/knowledge-base` | 新增知识库 |
| PUT | `/knowledge-base` | 修改知识库 |
| DELETE | `/knowledge-base/{id}` | 删除知识库 |
| GET | `/knowledge-base/page` | 分页查询知识库 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认10 |
| categoryId | Integer | 否 | 分类ID |
| createdBy | Integer | 否 | 创建人ID |
| createdDateStart | String | 否 | 创建日期起始 |
| createdDateEnd | String | 否 | 创建日期结束 |
| updateStart | String | 否 | 更新日期起始 |
| updateEnd | String | 否 | 更新日期结束 |
| keyword | String | 否 | 标题或内容模糊查询 |

---

## 12. 项目管理模块

| HTTP方法 | 接口路径 | 功能描述 |
|----------|----------|----------|
| GET | `/projects` | 批量查询项目（未实现） |
| GET | `/projects/{id}` | 根据ID查询项目 |
| POST | `/projects` | 新增项目 |
| PUT | `/projects` | 修改项目 |
| DELETE | `/projects/{id}` | 删除项目 |
| GET | `/projects/page` | 分页查询项目 |

**分页查询参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| pageNum | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页大小，默认10 |
| managerId | Integer | 否 | 项目经理ID |
| startDate | String | 否 | 项目起始日期 |
| endDate | String | 否 | 项目结束日期 |
| budgetMin | Double | 否 | 预算下限 |
| budgetMax | Double | 否 | 预算上限 |
| keyword | String | 否 | 项目名称或描述模糊查询 |

---

## 响应格式

所有接口统一返回JSON格式：

```json
{
  "code": 0,
  "msg": "success",
  "data": { ... }
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| code | int | 状态码，0表示成功，非0表示失败 |
| msg | String | 提示信息 |
| data | Object/Array | 返回的数据 |

---

## 技术说明

- **基础路径**：`http://localhost:8080`
- **跨域支持**：所有接口均支持跨域（`@CrossOrigin`）
- **分页插件**：使用 PageHelper 实现分页
- **API文档**：已集成OpenAPI（可访问 `/swagger-ui.html` 或 `/v3/api-docs`）