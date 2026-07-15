import { createRouter, createWebHistory, RouteRecordRaw } from "vue-router";
import Login from "../views/Login.vue";
import Dashboard from "../views/Dashboard.vue";

// 员工管理
import EmployeeList from "../views/employee/EmployeeList.vue";

// 部门管理
import DepartmentList from "../views/department/DepartmentList.vue";

// 职位管理
import PositionList from "../views/position/PositionList.vue";

// 薪资管理
import SalaryList from "../views/salary/SalaryList.vue";
import SalaryAdjustment from "../views/salary/SalaryAdjustment.vue";

// 绩效评估
import PerformanceList from "../views/performance/PerformanceList.vue";

// 考勤管理
import AttendanceList from "../views/attendance/AttendanceList.vue";
import LeaveList from "../views/attendance/LeaveList.vue";
import OvertimeList from "../views/attendance/OvertimeList.vue";

// 招聘管理
import JobPostingList from "../views/recruitment/JobPostingList.vue";
import CandidateList from "../views/recruitment/CandidateList.vue";
import InterviewList from "../views/recruitment/InterviewList.vue";
import OfferList from "../views/recruitment/OfferList.vue";

// 培训管理
import CourseList from "../views/training/CourseList.vue";
import PlanList from "../views/training/PlanList.vue";
import EnrollmentList from "../views/training/EnrollmentList.vue";

// 项目管理
import ProjectList from "../views/project/ProjectList.vue";
import ProjectMember from "../views/project/ProjectMember.vue";
import ProjectTask from "../views/project/ProjectTask.vue";

// 福利管理
import BenefitsPlan from "../views/benefits/BenefitsPlan.vue";
import BenefitsAssignment from "../views/benefits/BenefitsAssignment.vue";
import BenefitsClaim from "../views/benefits/BenefitsClaim.vue";

// 工作日程管理
import WorkScheduleList from "../views/schedule/WorkScheduleList.vue";
import ShiftPatternList from "../views/schedule/ShiftPatternList.vue";
import ScheduleRequestList from "../views/schedule/ScheduleRequestList.vue";

// 资产管理
import AssetList from "../views/asset/AssetList.vue";
import AssetAssignment from "../views/asset/AssetAssignment.vue";
import AssetMaintenance from "../views/asset/AssetMaintenance.vue";

// 文档管理
import DocumentList from "../views/document/DocumentList.vue";
import DocumentCategory from "../views/document/DocumentCategory.vue";

// 知识库管理
import KnowledgeList from "../views/knowledge/KnowledgeList.vue";
import KnowledgeCategory from "../views/knowledge/KnowledgeCategory.vue";
import KnowledgeFeedback from "../views/knowledge/KnowledgeFeedback.vue";

// 合规与风险管理
import CompliancePolicy from "../views/compliance/CompliancePolicy.vue";
import PolicyAcknowledgement from "../views/compliance/PolicyAcknowledgement.vue";
import RiskAssessment from "../views/compliance/RiskAssessment.vue";

// 员工发展与职业规划
import CareerPath from "../views/career/CareerPath.vue";
import CareerStage from "../views/career/CareerStage.vue";

// 内部沟通与协作
import Announcement from "../views/communication/Announcement.vue";
import DiscussionForum from "../views/communication/DiscussionForum.vue";
import ForumTopic from "../views/communication/ForumTopic.vue";
import ForumReply from "../views/communication/ForumReply.vue";

const routes: RouteRecordRaw[] = [
  {
    path: "/",
    redirect: "/login",
  },
  {
    path: "/login",
    name: "Login",
    component: Login,
    meta: { requiresAuth: false },
  },
  {
    path: "/dashboard",
    name: "Dashboard",
    component: Dashboard,
    meta: { requiresAuth: true },
    children: [
      // 员工管理
      {
        path: "employee/list",
        name: "EmployeeList",
        component: EmployeeList,
        meta: { title: "员工列表", requiresAuth: true },
      },

      // 部门管理
      {
        path: "department/list",
        name: "DepartmentList",
        component: DepartmentList,
        meta: { title: "部门列表", requiresAuth: true },
      },

      // 职位管理
      {
        path: "position/list",
        name: "PositionList",
        component: PositionList,
        meta: { title: "职位列表", requiresAuth: true },
      },

      // 薪资管理
      {
        path: "salary/list",
        name: "SalaryList",
        component: SalaryList,
        meta: { title: "薪资记录", requiresAuth: true },
      },
      {
        path: "salary/adjustment",
        name: "SalaryAdjustment",
        component: SalaryAdjustment,
        meta: { title: "薪资调整", requiresAuth: true },
      },

      // 绩效评估
      {
        path: "performance/list",
        name: "PerformanceList",
        component: PerformanceList,
        meta: { title: "绩效评估", requiresAuth: true },
      },

      // 考勤管理
      {
        path: "attendance/list",
        name: "AttendanceList",
        component: AttendanceList,
        meta: { title: "考勤记录", requiresAuth: true },
      },
      {
        path: "attendance/leave",
        name: "LeaveList",
        component: LeaveList,
        meta: { title: "请假管理", requiresAuth: true },
      },
      {
        path: "attendance/overtime",
        name: "OvertimeList",
        component: OvertimeList,
        meta: { title: "加班管理", requiresAuth: true },
      },

      // 招聘管理
      {
        path: "recruitment/job-posting",
        name: "JobPostingList",
        component: JobPostingList,
        meta: { title: "职位发布", requiresAuth: true },
      },
      {
        path: "recruitment/candidate",
        name: "CandidateList",
        component: CandidateList,
        meta: { title: "应聘者", requiresAuth: true },
      },
      {
        path: "recruitment/interview",
        name: "InterviewList",
        component: InterviewList,
        meta: { title: "面试管理", requiresAuth: true },
      },
      {
        path: "recruitment/offer",
        name: "OfferList",
        component: OfferList,
        meta: { title: "Offer管理", requiresAuth: true },
      },

      // 培训管理
      {
        path: "training/course",
        name: "training-course",
        component: CourseList,
        meta: { title: "培训课程", requiresAuth: true },
      },
      {
        path: "training/plan",
        name: "training-plan",
        component: PlanList,
        meta: { title: "培训计划", requiresAuth: true },
      },
      {
        path: "training/enrollment",
        name: "training-enrollment",
        component: EnrollmentList,
        meta: { title: "培训参与", requiresAuth: true },
      },

      // 项目管理
      {
        path: "project/list",
        name: "project-list",
        component: ProjectList,
        meta: { title: "项目列表", requiresAuth: true },
      },
      {
        path: "project/:id/members",
        name: "project-members",
        component: ProjectMember,
        meta: { title: "项目成员", requiresAuth: true },
      },
      {
        path: "project/:id/tasks",
        name: "project-tasks",
        component: ProjectTask,
        meta: { title: "项目任务", requiresAuth: true },
      },

      // 福利管理
      {
        path: "benefits/plans",
        name: "benefits-plans",
        component: BenefitsPlan,
        meta: { title: "福利计划", requiresAuth: true },
      },
      {
        path: "benefits/assignments",
        name: "benefits-assignments",
        component: BenefitsAssignment,
        meta: { title: "福利分配", requiresAuth: true },
      },
      {
        path: "benefits/claims",
        name: "benefits-claims",
        component: BenefitsClaim,
        meta: { title: "福利申请", requiresAuth: true },
      },

      // 工作日程管理
      {
        path: "schedule/work-schedule",
        name: "WorkScheduleList",
        component: WorkScheduleList,
        meta: { title: "工作排班", requiresAuth: true },
      },
      {
        path: "schedule/shift-pattern",
        name: "ShiftPatternList",
        component: ShiftPatternList,
        meta: { title: "班次模板", requiresAuth: true },
      },
      {
        path: "schedule/request",
        name: "ScheduleRequestList",
        component: ScheduleRequestList,
        meta: { title: "排班申请", requiresAuth: true },
      },

      // 资产管理
      {
        path: "asset/list",
        name: "AssetList",
        component: AssetList,
        meta: { title: "资产列表", requiresAuth: true },
      },
      {
        path: "asset/assignment",
        name: "AssetAssignment",
        component: AssetAssignment,
        meta: { title: "资产分配", requiresAuth: true },
      },
      {
        path: "asset/maintenance",
        name: "AssetMaintenance",
        component: AssetMaintenance,
        meta: { title: "资产维护", requiresAuth: true },
      },

      // 文档管理
      {
        path: "document/list",
        name: "DocumentList",
        component: DocumentList,
        meta: { title: "文档列表", requiresAuth: true },
      },
      {
        path: "document/category",
        name: "DocumentCategory",
        component: DocumentCategory,
        meta: { title: "文档分类", requiresAuth: true },
      },

      // 知识库管理
      {
        path: "knowledge/list",
        name: "KnowledgeList",
        component: KnowledgeList,
        meta: { title: "知识库列表", requiresAuth: true },
      },
      {
        path: "knowledge/category",
        name: "KnowledgeCategory",
        component: KnowledgeCategory,
        meta: { title: "知识库分类", requiresAuth: true },
      },
      {
        path: "knowledge/feedback",
        name: "KnowledgeFeedback",
        component: KnowledgeFeedback,
        meta: { title: "知识库反馈", requiresAuth: true },
      },

      // 合规与风险管理
      {
        path: "compliance/policy",
        name: "CompliancePolicy",
        component: CompliancePolicy,
        meta: { title: "合规政策", requiresAuth: true },
      },
      {
        path: "compliance/acknowledgement",
        name: "PolicyAcknowledgement",
        component: PolicyAcknowledgement,
        meta: { title: "政策确认", requiresAuth: true },
      },
      {
        path: "compliance/risk",
        name: "RiskAssessment",
        component: RiskAssessment,
        meta: { title: "风险评估", requiresAuth: true },
      },

      // 员工发展与职业规划
      {
        path: "career/path",
        name: "CareerPath",
        component: CareerPath,
        meta: { title: "职业路径", requiresAuth: true },
      },
      {
        path: "career/stage",
        name: "CareerStage",
        component: CareerStage,
        meta: { title: "职业阶段", requiresAuth: true },
      },

      // 内部沟通与协作
      {
        path: "communication/announcement",
        name: "Announcement",
        component: Announcement,
        meta: { title: "公告管理", requiresAuth: true },
      },
      {
        path: "communication/forum",
        name: "DiscussionForum",
        component: DiscussionForum,
        meta: { title: "讨论区", requiresAuth: true },
      },
      {
        path: "communication/forum/:forumId/topics",
        name: "ForumTopic",
        component: ForumTopic,
        meta: { title: "讨论主题", requiresAuth: true },
      },
      {
        path: "communication/forum/topic/:topicId/replies",
        name: "ForumReply",
        component: ForumReply,
        meta: { title: "主题回复", requiresAuth: true },
      },
    ],
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem("token");

  if (to.meta.requiresAuth && !token) {
    // 需要登录但未登录，重定向到登录页
    next("/login");
  } else if (to.path === "/login" && token) {
    // 已登录状态下访问登录页，重定向到首页
    next("/dashboard");
  } else {
    next();
  }
});

export default router;
