.\mvnw spring-boot:run# 企业人事管理系统（HR Information System）

## 项目简介

本系统为企业级人事信息管理平台，涵盖员工管理、考勤、薪资、培训、招聘、资产、论坛、知识库等多项功能，支持前后端分离架构，便于扩展和维护。

## 技术栈

- **后端**：Spring Boot 3.x、MyBatis、MySQL、PageHelper、Springdoc OpenAPI
- **前端**：Vue 3、Vite、Element Plus、Axios、Vue Router
- **数据库**：MySQL

## 目录结构

```
├── src/
│   └── main/
│       ├── java/com/example/demo/   # 后端Java代码（controller/dao/bean等）
│       └── resources/               # 配置文件、模板、静态资源
├── hr1/hr/                          # 前端Vue3项目
│   ├── src/                         # 前端源码
│   ├── public/                      # 公共资源
│   ├── package.json                 # 前端依赖
│   └── vite.config.js               # 前端开发配置
├── 数据库相关SQL及文档
│   ├── *.sql                        # 数据库表结构及初始化脚本
│   ├── 企业人事管理系统完整数据库表设计.docx
├── pom.xml                          # 后端Maven依赖
```

## 快速启动

### 后端

1. **环境要求**：JDK 21+、Maven、MySQL
2. **数据库准备**：导入`数据库查询表.xlsx`或相关SQL文件，创建`hr`数据库
3. **配置数据库连接**：修改`src/main/resources/application.yml`中的数据库账号密码
4. **启动后端服务**：
   ```bash
   mvn spring-boot:run
   ```
   默认端口：`8080`

### 前端

1. **环境要求**：Node.js 16+
2. **安装依赖**：
   ```bash
   cd hr1/hr
   npm install
   ```
3. **启动前端开发服务器**：
   ```bash
   npm run dev
   ```
   默认端口：`5174`，已配置代理转发API请求到后端`8080`端口

## 主要功能模块

- 员工信息管理
- 部门与职位管理
- 考勤与排班
- 薪资与福利
- 培训与发展
- 招聘与面试
- 资产管理
- 论坛与知识库
- 风险与合规管理

## 相关文档

- 数据库表结构：`*.sql`、`企业人事管理系统完整数据库表设计.docx`
- 资产管理方案：`ASSETS_ID_SOLUTION.md`

## 其他

- 前端采用Vite构建，支持热更新和现代化开发体验
- 后端接口已集成OpenAPI文档（可访问`/swagger-ui.html`或`/v3/api-docs`，具体路径视springdoc配置而定）
