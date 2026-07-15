<template>
  <div class="dashboard-container">
    <!-- 侧边栏 -->
    <div class="sidebar" :class="{ collapsed: isCollapse }">
      <div class="logo">
        <h3 :class="{ 'logo-collapsed': isCollapse }">
          <span class="logo-text">HR</span>
          <span class="logo-full" v-show="!isCollapse">人事管理系统</span>
        </h3>
      </div>
      <el-scrollbar>
        <el-menu
          :default-active="activeMenu"
          class="el-menu-vertical"
          background-color="#304156"
          text-color="#bfcbd9"
          active-text-color="#409EFF"
          :collapse="isCollapse"
          router
        >
          <!-- 首页 -->
          <el-menu-item index="/dashboard" class="menu-item-wrapper">
            <el-icon><HomeFilled /></el-icon>
            <template #title>
              <span class="menu-title">首页</span>
            </template>
          </el-menu-item>

          <!-- 组织架构管理 -->
          <el-sub-menu index="organization" class="menu-item-wrapper">
            <template #title>
              <el-icon><OfficeBuilding /></el-icon>
              <span>组织架构</span>
            </template>
            <el-sub-menu index="org-employee" class="submenu-wrapper">
              <template #title>
                <el-icon><User /></el-icon>
                <span>员工管理</span>
              </template>
              <el-menu-item
                index="/dashboard/employee/list"
                class="submenu-item"
              >
                <el-icon><List /></el-icon>
                <span>员工列表</span>
              </el-menu-item>
              <el-menu-item index="/dashboard/career/path" class="submenu-item">
                <el-icon><TrendCharts /></el-icon>
                <span>职业发展</span>
              </el-menu-item>
              <el-menu-item
                index="/dashboard/performance/list"
                class="submenu-item"
              >
                <el-icon><Histogram /></el-icon>
                <span>绩效考核</span>
              </el-menu-item>
            </el-sub-menu>
            <el-sub-menu index="org-department" class="submenu-wrapper">
              <template #title>
                <el-icon><Briefcase /></el-icon>
                <span>部门管理</span>
              </template>
              <el-menu-item
                index="/dashboard/department/list"
                class="submenu-item"
              >
                <el-icon><Grid /></el-icon>
                <span>部门列表</span>
              </el-menu-item>
              <el-menu-item
                index="/dashboard/position/list"
                class="submenu-item"
              >
                <el-icon><Rank /></el-icon>
                <span>职位管理</span>
              </el-menu-item>
            </el-sub-menu>
          </el-sub-menu>

          <!-- 日常管理 -->
          <el-sub-menu index="daily" class="menu-item-wrapper">
            <template #title>
              <el-icon><Calendar /></el-icon>
              <span>日常管理</span>
            </template>
            <el-sub-menu index="daily-attendance" class="submenu-wrapper">
              <template #title>
                <el-icon><Timer /></el-icon>
                <span>考勤管理</span>
              </template>
              <el-menu-item
                index="/dashboard/attendance/list"
                class="submenu-item"
              >
                <el-icon><Calendar /></el-icon>
                <span>考勤记录</span>
              </el-menu-item>
              <el-menu-item
                index="/dashboard/attendance/leave"
                class="submenu-item"
              >
                <el-icon><Switch /></el-icon>
                <span>请假管理</span>
              </el-menu-item>
              <el-menu-item
                index="/dashboard/attendance/overtime"
                class="submenu-item"
              >
                <el-icon><AlarmClock /></el-icon>
                <span>加班管理</span>
              </el-menu-item>
            </el-sub-menu>
            <el-sub-menu index="daily-asset" class="submenu-wrapper">
              <template #title>
                <el-icon><Box /></el-icon>
                <span>资产管理</span>
              </template>
              <el-menu-item index="/dashboard/asset/list" class="submenu-item">
                <el-icon><Files /></el-icon>
                <span>资产列表</span>
              </el-menu-item>
              <el-menu-item
                index="/dashboard/asset/assignment"
                class="submenu-item"
              >
                <el-icon><Connection /></el-icon>
                <span>资产分配</span>
              </el-menu-item>
            </el-sub-menu>
          </el-sub-menu>

          <!-- 薪酬福利 -->
          <el-sub-menu index="compensation" class="menu-item-wrapper">
            <template #title>
              <el-icon><Money /></el-icon>
              <span>薪酬福利</span>
            </template>
            <el-sub-menu index="comp-salary" class="submenu-wrapper">
              <template #title>
                <el-icon><Wallet /></el-icon>
                <span>薪资管理</span>
              </template>
              <el-menu-item index="/dashboard/salary/list" class="submenu-item">
                <el-icon><Tickets /></el-icon>
                <span>薪资福利</span>
              </el-menu-item>
              <el-menu-item
                index="/dashboard/salary/adjustment"
                class="submenu-item"
              >
                <el-icon><TrendCharts /></el-icon>
                <span>薪资调整</span>
              </el-menu-item>
            </el-sub-menu>
            <el-sub-menu index="comp-benefits" class="submenu-wrapper">
              <template #title>
                <el-icon><Present /></el-icon>
                <span>福利管理</span>
              </template>
              <el-menu-item
                index="/dashboard/benefits/plans"
                class="submenu-item"
              >
                <el-icon><Memo /></el-icon>
                <span>福利计划</span>
              </el-menu-item>
              <el-menu-item
                index="/dashboard/benefits/claims"
                class="submenu-item"
              >
                <el-icon><Postcard /></el-icon>
                <span>福利申请</span>
              </el-menu-item>
            </el-sub-menu>
          </el-sub-menu>

          <!-- 知识管理 -->
          <el-sub-menu index="knowledge" class="menu-item-wrapper">
            <template #title>
              <el-icon><Document /></el-icon>
              <span>知识管理</span>
            </template>
            <el-sub-menu index="knowledge-doc" class="submenu-wrapper">
              <template #title>
                <el-icon><Collection /></el-icon>
                <span>文档中心</span>
              </template>
              <el-menu-item
                index="/dashboard/document/list"
                class="submenu-item"
              >
                <el-icon><Document /></el-icon>
                <span>文档管理</span>
              </el-menu-item>
              <el-menu-item
                index="/dashboard/knowledge/list"
                class="submenu-item"
              >
                <el-icon><Reading /></el-icon>
                <span>知识库</span>
              </el-menu-item>
            </el-sub-menu>
            <el-sub-menu index="knowledge-policy" class="submenu-wrapper">
              <template #title>
                <el-icon><Warning /></el-icon>
                <span>制度管理</span>
              </template>
              <el-menu-item
                index="/dashboard/compliance/policy"
                class="submenu-item"
              >
                <el-icon><Guide /></el-icon>
                <span>合规政策</span>
              </el-menu-item>
              <el-menu-item
                index="/dashboard/compliance/risk"
                class="submenu-item"
              >
                <el-icon><InfoFilled /></el-icon>
                <span>风险评估</span>
              </el-menu-item>
            </el-sub-menu>
          </el-sub-menu>

          <!-- 退出登录按钮 -->
          <div class="menu-spacer"></div>
          <el-menu-item
            index="logout"
            @click="handleLogout"
            class="logout-item menu-item-wrapper"
          >
            <el-icon><SwitchButton /></el-icon>
            <template #title>
              <span class="menu-title">退出登录</span>
            </template>
          </el-menu-item>
        </el-menu>
      </el-scrollbar>
    </div>

    <!-- 主内容区域 -->
    <div class="main-container">
      <!-- 顶部导航栏 -->
      <div class="header">
        <div class="left">
          <el-button type="text" @click="toggleSidebar">
            <el-icon><Fold v-if="!isCollapse" /><Expand v-else /></el-icon>
          </el-button>
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/dashboard' }"
              >首页</el-breadcrumb-item
            >
            <el-breadcrumb-item v-if="$route.meta.title">{{
              $route.meta.title
            }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="right">
          <el-dropdown>
            <span class="el-dropdown-link">
              管理员 <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="handleLogout"
                  >退出登录</el-dropdown-item
                >
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>

      <!-- 内容区域 -->
      <div class="content">
        <!-- 欢迎页面，只在访问 /dashboard 时显示 -->
        <div v-if="$route.path === '/dashboard'" class="welcome-container">
          <!-- 顶部欢迎区域 -->
          <div class="welcome-header animate__animated animate__fadeIn">
            <div class="welcome-info">
              <h2 class="animate__animated animate__slideInLeft">
                欢迎回来，管理员
              </h2>
              <p
                class="welcome-date animate__animated animate__slideInLeft animate__delay-1s"
              >
                {{ currentDate }} {{ currentTime }}
              </p>
            </div>
            <div class="weather-info animate__animated animate__slideInRight">
              <el-icon><Sunny /></el-icon>
              <span>25°C 晴朗</span>
            </div>
          </div>

          <!-- 数据统计卡片 -->
          <el-row :gutter="20" class="stat-cards">
            <el-col
              :span="6"
              v-for="(stat, index) in statsData"
              :key="stat.title"
            >
              <div
                class="animate__animated"
                :class="['animate__fadeInUp', `animate__delay-${index}s`]"
              >
                <el-card shadow="hover" class="stat-card">
                  <div class="stat-item">
                    <div class="icon-bg" :class="stat.colorClass">
                      <el-icon><component :is="stat.icon" /></el-icon>
                    </div>
                    <div class="stat-info">
                      <div class="stat-value">
                        <CountTo
                          :startVal="0"
                          :endVal="stat.value"
                          :duration="2500"
                          :decimals="0"
                          separator=","
                          :autoplay="true"
                          :delay="index * 200"
                        />
                      </div>
                      <div class="stat-title">{{ stat.title }}</div>
                    </div>
                  </div>
                </el-card>
              </div>
            </el-col>
          </el-row>

          <!-- 数据统计卡片后面的部分替换为 -->
          <el-card
            class="notice-section animate__animated animate__fadeInUp animate__delay-4s"
          >
            <template #header>
              <div class="card-header">
                <span>最新动态</span>
              </div>
            </template>
            <div class="notice-container">
              <!-- 左侧标题列表 -->
              <div class="notice-menu">
                <div
                  class="menu-item"
                  :class="{ active: activeNoticeType === 'benefits' }"
                  @click="activeNoticeType = 'benefits'"
                >
                  <el-icon><Present /></el-icon>
                  <span>福利计划</span>
                </div>
                <div
                  class="menu-item"
                  :class="{ active: activeNoticeType === 'knowledge' }"
                  @click="activeNoticeType = 'knowledge'"
                >
                  <el-icon><Reading /></el-icon>
                  <span>知识库</span>
                </div>
              </div>

              <!-- 右侧内容区域 -->
              <div class="notice-content">
                <!-- 福利计划列表 -->
                <div
                  v-show="activeNoticeType === 'benefits'"
                  class="content-list"
                >
                  <el-carousel
                    height="280px"
                    :interval="3000"
                    arrow="hover"
                    indicator-position="outside"
                  >
                    <el-carousel-item
                      v-for="(notice, index) in benefitNotices"
                      :key="index"
                    >
                      <div
                        class="carousel-item"
                        @click="handleBenefitClick(notice)"
                      >
                        <div class="item-icon">
                          <el-icon><Present /></el-icon>
                        </div>
                        <h3 class="item-title">{{ notice.planName }}</h3>
                        <div class="item-time">
                          生效日期：{{ formatDate(notice.startDate) }}
                        </div>
                        <div class="item-desc">{{ notice.description }}</div>
                      </div>
                    </el-carousel-item>
                  </el-carousel>
                  <div v-if="benefitNotices.length === 0" class="empty-notice">
                    暂无福利计划
                  </div>
                  <div class="view-more">
                    <el-button
                      type="primary"
                      link
                      @click="$router.push('/dashboard/benefits/plans')"
                    >
                      查看更多<el-icon><ArrowRight /></el-icon>
                    </el-button>
                  </div>
                </div>

                <!-- 知识库列表 -->
                <div
                  v-show="activeNoticeType === 'knowledge'"
                  class="content-list"
                >
                  <el-carousel
                    height="280px"
                    :interval="3000"
                    arrow="hover"
                    indicator-position="outside"
                  >
                    <el-carousel-item
                      v-for="(notice, index) in knowledgeNotices"
                      :key="index"
                    >
                      <div
                        class="carousel-item"
                        @click="handleKnowledgeClick(notice)"
                      >
                        <div class="item-icon">
                          <el-icon><Reading /></el-icon>
                        </div>
                        <h3 class="item-title">{{ notice.title }}</h3>
                        <div class="item-time">
                          创建时间：{{ formatDate(notice.createdDate) }}
                        </div>
                        <div class="item-desc">{{ notice.content }}</div>
                      </div>
                    </el-carousel-item>
                  </el-carousel>
                  <div
                    v-if="knowledgeNotices.length === 0"
                    class="empty-notice"
                  >
                    暂无知识库条目
                  </div>
                  <div class="view-more">
                    <el-button
                      type="primary"
                      link
                      @click="$router.push('/dashboard/knowledge/list')"
                    >
                      查看更多<el-icon><ArrowRight /></el-icon>
                    </el-button>
                  </div>
                </div>
              </div>
            </div>
          </el-card>

          <!-- 快捷操作区域 -->
          <el-card
            class="quick-actions animate__animated animate__fadeInUp animate__delay-5s"
          >
            <template #header>
              <div class="card-header">
                <span>快捷操作</span>
              </div>
            </template>
            <div class="quick-actions-container">
              <el-row :gutter="20" class="quick-actions-row">
                <el-col
                  :span="4"
                  v-for="action in quickActions"
                  :key="action.title"
                >
                  <div
                    class="quick-action-item"
                    @click="handleQuickAction(action)"
                  >
                    <div class="action-icon" :class="action.colorClass">
                      <el-icon><component :is="action.icon" /></el-icon>
                    </div>
                    <span>{{ action.title }}</span>
                  </div>
                </el-col>
              </el-row>

              <!-- 重要链接区 -->
              <div class="important-links-container">
                <div
                  v-for="link in importantLinks"
                  :key="link.title"
                  class="gov-button"
                  :class="link.title === '中国法院网' ? 'law-button' : ''"
                  @click="handleQuickAction(link)"
                >
                  <div class="action-icon" :class="link.colorClass">
                    <el-icon><component :is="link.icon" /></el-icon>
                  </div>
                  <span>{{ link.title }}</span>
                  <div class="gov-button-decoration"></div>
                </div>
              </div>
            </div>
          </el-card>
        </div>

        <!-- 路由内容 -->
        <router-view v-slot="{ Component, route }">
          <transition name="fade-transform" mode="out-in" appear>
            <keep-alive>
              <component
                :is="Component"
                :key="route.path"
                v-if="$route.path === '/dashboard' || $route.meta.keepAlive"
              />
            </keep-alive>
          </transition>
          <transition name="fade-transform" mode="out-in" appear>
            <component
              :is="Component"
              :key="route.path"
              v-if="$route.path !== '/dashboard' && !$route.meta.keepAlive"
            />
          </transition>
        </router-view>
      </div>
    </div>

    <!-- 福利计划详情对话框 -->
    <el-dialog
      v-model="benefitDialogVisible"
      :title="selectedBenefit?.planName"
      width="600px"
      destroy-on-close
    >
      <div class="dialog-content">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="计划名称">
            {{ selectedBenefit?.planName }}
          </el-descriptions-item>
          <el-descriptions-item label="生效日期">
            {{ formatDate(selectedBenefit?.startDate) }} 至
            {{ formatDate(selectedBenefit?.endDate) }}
          </el-descriptions-item>
          <el-descriptions-item label="计划详情">
            {{ selectedBenefit?.description }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
    </el-dialog>

    <!-- 知识库详情对话框 -->
    <el-dialog
      v-model="knowledgeDialogVisible"
      :title="selectedKnowledge?.title"
      width="600px"
      destroy-on-close
    >
      <div class="dialog-content">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="标题">
            {{ selectedKnowledge?.title }}
          </el-descriptions-item>
          <el-descriptions-item label="创建时间">
            {{ formatDate(selectedKnowledge?.createdDate) }}
          </el-descriptions-item>
          <el-descriptions-item label="内容">
            {{ selectedKnowledge?.content }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import {
  ref,
  computed,
  watch,
  onMounted,
  onBeforeUnmount,
  nextTick,
} from "vue";
import { useRouter, useRoute } from "vue-router";
import { ElMessage, ElMessageBox } from "element-plus";
import employeeApi from "@/api/employee";
import departmentApi from "@/api/department";
import benefitsPlanApi from "@/api/benefitsPlan";
import knowledgeListApi from "@/api/KnowledgeList";
import "animate.css";
import {
  HomeFilled,
  User,
  OfficeBuilding,
  Calendar,
  Money,
  Fold,
  Expand,
  ArrowDown,
  ArrowUp,
  Bell,
  Briefcase,
  Box,
  Document,
  Collection,
  Warning,
  Present,
  Timer,
  Wallet,
  List,
  TrendCharts,
  Histogram,
  Grid,
  Rank,
  Switch,
  AlarmClock,
  Files,
  Connection,
  Tickets,
  Memo,
  Postcard,
  Reading,
  Guide,
  InfoFilled,
  SwitchButton,
  Sunny,
  Plus,
  Edit,
  Delete,
  Search,
  ArrowRight,
  Link,
  Service,
} from "@element-plus/icons-vue";
import { CountTo } from "vue3-count-to";

const router = useRouter();
const route = useRoute();
const isCollapse = ref(false);
const activeMenu = ref("/dashboard");
const activeNoticeType = ref("benefits"); // 当前激活的通知类型
const benefitDialogVisible = ref(false);
const knowledgeDialogVisible = ref(false);
const selectedBenefit = ref(null);
const selectedKnowledge = ref(null);

// 监听路由变化，更新当前激活的菜单
watch(
  () => route.path,
  (path) => {
    activeMenu.value = path;
  },
  { immediate: true }
);

// 获取当前日期
const currentDate = computed(() => {
  const now = new Date();
  return `${now.getFullYear()}年${now.getMonth() + 1}月${now.getDate()}日`;
});

// 获取当前时间
const currentTime = computed(() => {
  const now = new Date();
  const hours = now.getHours().toString().padStart(2, "0");
  const minutes = now.getMinutes().toString().padStart(2, "0");
  return `${hours}:${minutes}`;
});

// 切换侧边栏
const toggleSidebar = () => {
  isCollapse.value = !isCollapse.value;
};

// 退出登录
const handleLogout = () => {
  ElMessageBox.confirm("确认退出系统吗?", "提示", {
    confirmButtonText: "确认",
    cancelButtonText: "取消",
    type: "warning",
    draggable: true,
    closeOnClickModal: false,
    beforeClose: (action, instance, done) => {
      if (action === "confirm") {
        instance.confirmButtonLoading = true;
        localStorage.removeItem("token");
        setTimeout(() => {
          instance.confirmButtonLoading = false;
          done();
          router.push("/login");
          ElMessage.success("已退出登录");
        }, 200);
      } else {
        done();
      }
    },
  }).catch(() => {
    // 点击取消时不做任何操作，自动回到当前页面
  });
};

// 统计数据
const stats = ref({
  totalEmployees: 0,
  totalDepartments: 0,
  totalBenefits: 0,
  totalKnowledge: 0,
});

// 统计数据配置
const statsData = computed(() => [
  {
    icon: "User",
    title: "员工总数",
    value: Number(stats.value.totalEmployees) || 0,
    colorClass: "bg-blue",
  },
  {
    icon: "OfficeBuilding",
    title: "部门数量",
    value: Number(stats.value.totalDepartments) || 0,
    colorClass: "bg-green",
  },
  {
    icon: "Present",
    title: "福利计划",
    value: Number(stats.value.totalBenefits) || 0,
    colorClass: "bg-orange",
  },
  {
    icon: "Reading",
    title: "知识库",
    value: Number(stats.value.totalKnowledge) || 0,
    colorClass: "bg-purple",
  },
]);

// 获取统计数据
const getStats = async () => {
  try {
    // 获取员工总数
    const empRes = await employeeApi.getEmployeesPage({
      pageSize: 1,
      pageNum: 1,
    });
    if (empRes.data && empRes.data.data) {
      stats.value.totalEmployees = empRes.data.data.total || 0;
    }

    // 获取部门总数
    const deptRes = await departmentApi.getDepartmentPage({
      pageSize: 1,
      pageNum: 1,
    });
    if (deptRes.data && deptRes.data.data) {
      stats.value.totalDepartments = deptRes.data.data.total || 0;
    }

    // 获取福利计划总数
    const benefitsRes = await benefitsPlanApi.getBenefitsPlanList({
      pageSize: 1,
      pageNum: 1,
    });
    if (benefitsRes.data && benefitsRes.data.data) {
      stats.value.totalBenefits = benefitsRes.data.data.total || 0;
    }

    // 获取知识库总数
    const knowledgeRes = await knowledgeListApi.getKnowledgeListPage({
      pageSize: 1,
      pageNum: 1,
    });
    if (knowledgeRes.data && knowledgeRes.data.data) {
      stats.value.totalKnowledge = knowledgeRes.data.data.total || 0;
    }
  } catch (error) {
    console.error("获取统计数据失败:", error);
    ElMessage.error("获取统计数据失败");
  }
};

// 通知列表数据
const benefitNotices = ref([]);
const knowledgeNotices = ref([]);

// 获取通知列表
const getNotices = async () => {
  try {
    // 获取所有的福利计划
    const benefitsRes = await benefitsPlanApi.getBenefitsPlanList({
      pageSize: 999,
      pageNum: 1,
    });

    // 获取所有的知识库条目
    const knowledgeRes = await knowledgeListApi.getKnowledgeListPage({
      pageSize: 999, // 设置一个较大的数值以获取所有记录
      pageNum: 1,
      orderBy: "createTime",
      order: "desc",
    });

    // 处理福利计划
    if (
      benefitsRes.data &&
      benefitsRes.data.data &&
      benefitsRes.data.data.list
    ) {
      benefitNotices.value = benefitsRes.data.data.list;
    }

    // 处理知识库条目
    if (
      knowledgeRes.data &&
      knowledgeRes.data.data &&
      knowledgeRes.data.data.list
    ) {
      knowledgeNotices.value = knowledgeRes.data.data.list;
    }
  } catch (error) {
    console.error("获取通知列表失败:", error);
    ElMessage.error("获取通知列表失败");
  }
};

// 添加日期格式化函数
const formatDate = (date) => {
  if (!date) return "";
  const d = new Date(date);
  if (isNaN(d.getTime())) return "";

  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");

  return `${year}-${month}-${day}`;
};

// 添加点击处理函数
const handleBenefitClick = (benefit) => {
  selectedBenefit.value = benefit;
  benefitDialogVisible.value = true;
};

const handleKnowledgeClick = (knowledge) => {
  selectedKnowledge.value = knowledge;
  knowledgeDialogVisible.value = true;
};

// 修改 importantLinks 数组中按钮的顺序
const importantLinks = [
  {
    icon: "Star",
    title: "中国党员网",
    path: "https://www.12371.cn/",
    isExternal: true,
    colorClass: "red-icon",
  },
  {
    icon: "Link",
    title: "中国政府网",
    path: "https://www.gov.cn/",
    isExternal: true,
    colorClass: "red-icon",
  },
  {
    icon: "Service",
    title: "中国法院网",
    path: "https://www.chinacourt.org/index.shtml",
    isExternal: true,
    colorClass: "red-icon", // 将blue-law-icon改为red-icon
  },
];

// 修改快捷操作数组，移除中国政府网按钮
const quickActions = ref([
  {
    icon: "CirclePlus",
    title: "添加员工",
    path: "/dashboard/employee/list",
    colorClass: "blue-icon",
  },
  {
    icon: "Clock",
    title: "考勤管理",
    path: "/dashboard/attendance/list",
    colorClass: "green-icon",
  },
  {
    icon: "AlarmClock",
    title: "加班管理",
    path: "/dashboard/attendance/overtime",
    colorClass: "orange-icon",
  },
  {
    icon: "Position",
    title: "请假管理",
    path: "/dashboard/attendance/leave",
    colorClass: "purple-icon",
  },
  {
    icon: "Wallet",
    title: "薪资管理",
    path: "/dashboard/salary/list",
    colorClass: "cyan-icon",
  },
  {
    icon: "Medal",
    title: "绩效考核",
    path: "/dashboard/performance/list",
    colorClass: "pink-icon",
  },
]);

// 处理快捷操作点击
const handleQuickAction = (action) => {
  // 添加路由切换动画类
  document.body.classList.add("page-transition");

  // 如果是外部链接
  if (action.isExternal) {
    window.open(action.path, "_blank");
    // 打开外部链接后刷新当前页面
    setTimeout(() => {
      window.location.reload();
    }, 100);
    return;
  }

  // 延迟导航以等待动画效果
  setTimeout(() => {
    router.push(action.path);
    // 动画结束后移除类
    setTimeout(() => {
      document.body.classList.remove("page-transition");
    }, 300);
  }, 100);
};

// 页面加载时获取数据
onMounted(() => {
  getStats();
  getNotices();
});

// 创建遮罩元素
const createMask = () => {
  const mask = document.createElement("div");
  mask.className = "page-mask";
  document.body.appendChild(mask);
  return mask;
};

// 页面切换动画处理
const handleRouteChange = () => {
  const mask = createMask();

  // 添加遮罩效果
  setTimeout(() => {
    mask.classList.add("active");
  }, 0);

  // 移除遮罩效果
  setTimeout(() => {
    mask.classList.remove("active");
    setTimeout(() => {
      mask.remove();
    }, 300);
  }, 500);
};

// 监听路由变化
onMounted(() => {
  router.beforeEach((to, from, next) => {
    handleRouteChange();
    next();
  });
});
</script>

<style scoped>
.dashboard-container {
  display: flex;
  height: 100vh;
  overflow: hidden;
  width: 100%;
}

.sidebar {
  background-color: #304156;
  color: #fff;
  height: 100vh;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  width: 210px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  position: relative;
  z-index: 10;
  box-shadow: 2px 0 8px rgba(0, 21, 41, 0.35);
  overflow: hidden;
}

.sidebar.collapsed {
  width: 64px;
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(to right, #304156, #1f2d3d);
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  padding: 0;
}

.logo h3 {
  color: #fff;
  margin: 0;
  font-size: 20px;
  font-weight: 600;
  display: flex;
  align-items: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.logo-text {
  color: #409eff;
  font-weight: 800;
  letter-spacing: 1px;
  padding: 0 4px;
}

.logo-full {
  margin-left: 8px;
  font-weight: 500;
  opacity: 1;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.logo-collapsed {
  justify-content: center;
}

.el-menu-vertical {
  border-right: none;
  transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  height: calc(100vh - 60px);
  display: flex;
  flex-direction: column;
}

.el-menu-vertical:not(.el-menu--collapse) {
  width: 210px;
}

.menu-item-wrapper {
  position: relative;
  margin: 4px 0;
  border-radius: 4px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.menu-item-wrapper::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  width: 4px;
  height: 100%;
  background: #409eff;
  opacity: 0;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 0 2px 2px 0;
}

.menu-item-wrapper:hover::before {
  opacity: 0.5;
}

.el-menu-item.is-active::before,
.el-sub-menu.is-active > .el-sub-menu__title::before {
  opacity: 1;
}

.el-menu-item .el-icon,
.el-sub-menu__title .el-icon {
  font-size: 18px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.menu-title {
  margin-left: 10px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.submenu-wrapper {
  background: rgba(0, 0, 0, 0.1);
  margin: 4px 0;
  border-radius: 4px;
}

.submenu-item {
  margin: 4px 0;
  padding-left: 40px !important;
}

:deep(.el-scrollbar__wrap) {
  overflow-x: hidden !important;
}

:deep(.el-scrollbar__bar.is-vertical) {
  right: 0;
}

:deep(.el-scrollbar) {
  height: calc(100vh - 60px);
}

.menu-spacer {
  flex: 1;
  min-height: 20px;
}

.logout-item {
  margin-top: auto;
  border-top: 1px solid rgba(255, 255, 255, 0.05);
  height: 60px !important;
  background-color: #304156 !important;
  padding: 0 20px !important;
}

.el-menu-item.is-active,
.el-sub-menu.is-active > .el-sub-menu__title {
  background: linear-gradient(
    to right,
    rgba(64, 158, 255, 0.1),
    transparent
  ) !important;
  color: #409eff !important;
}

.el-menu-item:hover,
.el-sub-menu__title:hover {
  background: rgba(255, 255, 255, 0.05) !important;
}

.el-menu--collapse .el-sub-menu__title span,
.el-menu--collapse .el-menu-item span {
  height: 0;
  width: 0;
  overflow: hidden;
  visibility: hidden;
  display: inline-block;
}

.el-sub-menu__title .el-sub-menu__icon-arrow {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.el-sub-menu.is-opened > .el-sub-menu__title .el-sub-menu__icon-arrow {
  transform: rotateZ(180deg);
}

.main-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  min-width: 0;
  background-color: #f0f2f5;
  transition: all 0.3s;
}

.header {
  height: 60px;
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  transition: all 0.3s;
}

.header .left {
  display: flex;
  align-items: center;
}

.header .left .el-button {
  margin-right: 15px;
  transition: transform 0.3s;
}

.header .left .el-button:hover {
  transform: rotate(90deg);
}

.header .right .el-dropdown-link {
  cursor: pointer;
  display: flex;
  align-items: center;
}

.content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background-color: #f0f2f5;
  height: calc(100vh - 60px);
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.welcome-container {
  padding: 20px;
  animation: fadeIn 0.5s ease-out;
  background: linear-gradient(
    135deg,
    rgba(240, 242, 245, 0.8) 0%,
    rgba(255, 255, 255, 0.8) 100%
  );
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.1);
  position: relative;
  overflow: hidden;
}

.welcome-header {
  background: linear-gradient(135deg, #1890ff 0%, #36cfc9 100%);
  padding: 30px;
  border-radius: 12px;
  margin-bottom: 24px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  position: relative;
  overflow: hidden;
}

.welcome-header::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
      45deg,
      rgba(255, 255, 255, 0.1) 25%,
      transparent 25%
    ),
    linear-gradient(-45deg, rgba(255, 255, 255, 0.1) 25%, transparent 25%),
    linear-gradient(45deg, transparent 75%, rgba(255, 255, 255, 0.1) 75%),
    linear-gradient(-45deg, transparent 75%, rgba(255, 255, 255, 0.1) 75%);
  background-size: 20px 20px;
  animation: patternMove 20s linear infinite;
}

.welcome-info h2 {
  font-size: 28px;
  color: white;
  margin: 0;
  position: relative;
}

.welcome-date {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 8px;
  position: relative;
}

.weather-info {
  display: flex;
  align-items: center;
  gap: 8px;
  color: white;
  font-size: 18px;
  position: relative;
}

.stat-cards {
  margin-bottom: 24px;
}

.stat-card {
  height: 100%;
  transition: all 0.3s;
  transform-origin: center;
  background: rgba(255, 255, 255, 0.7) !important;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.3) !important;
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15) !important;
}

.stat-card:hover {
  transform: translateY(-5px) scale(1.02);
  background: rgba(255, 255, 255, 0.8) !important;
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.2) !important;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  position: relative;
  overflow: hidden;
}

.stat-item::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    135deg,
    rgba(255, 255, 255, 0.2) 0%,
    rgba(255, 255, 255, 0.05) 100%
  );
  opacity: 0;
  transition: opacity 0.3s;
}

.stat-card:hover .stat-item::before {
  opacity: 1;
}

.icon-bg {
  width: 64px;
  height: 64px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  backdrop-filter: blur(5px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.bg-blue {
  background: linear-gradient(
    135deg,
    rgba(24, 144, 255, 0.9) 0%,
    rgba(54, 207, 201, 0.9) 100%
  );
}

.bg-green {
  background: linear-gradient(
    135deg,
    rgba(82, 196, 26, 0.9) 0%,
    rgba(115, 209, 61, 0.9) 100%
  );
}

.bg-orange {
  background: linear-gradient(
    135deg,
    rgba(250, 140, 22, 0.9) 0%,
    rgba(255, 213, 145, 0.9) 100%
  );
}

.bg-purple {
  background: linear-gradient(
    135deg,
    rgba(114, 46, 209, 0.9) 0%,
    rgba(179, 127, 235, 0.9) 100%
  );
}

.stat-info {
  flex: 1;
  position: relative;
  z-index: 1;
}

.stat-value {
  font-size: 36px;
  font-weight: bold;
  line-height: 1;
  margin-bottom: 8px;
  color: #303133;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.stat-title {
  font-size: 16px;
  color: #606266;
  position: relative;
}

.data-section {
  margin-bottom: 24px;
}

.chart-card,
.notice-card {
  height: 400px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chart-placeholder {
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.chart-demo {
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
  border-radius: 4px;
}

.notice-section {
  margin-bottom: 24px;
  height: 400px;
}

.notice-container {
  display: flex;
  height: 100%;
}

.notice-menu {
  width: 200px;
  border-right: 1px solid #e4e7ed;
  padding: 16px 0;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.menu-item::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: currentColor;
  opacity: 0;
  transform: translateX(-100%);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.menu-item:hover {
  background-color: #f5f7fa;
  transform: translateX(5px);
}

.menu-item:active {
  transform: scale(0.98);
}

.menu-item.active {
  background-color: #ecf5ff;
  color: #409eff;
  border-right: 2px solid #409eff;
}

.menu-item.active::before {
  opacity: 0.1;
  transform: translateX(0);
}

.menu-item .el-icon {
  margin-right: 12px;
  font-size: 18px;
}

.notice-content {
  flex: 1;
  padding: 16px;
  overflow: hidden;
}

.content-list {
  height: 100%;
  overflow-y: auto;
}

.content-item {
  padding: 16px;
  border-bottom: 1px solid #ebeef5;
  cursor: pointer;
  transition: all 0.3s;
}

.content-item:hover {
  background-color: #f5f7fa;
}

.content-item:last-child {
  border-bottom: none;
}

.item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.item-title {
  font-size: 14px;
  color: #303133;
  flex: 1;
  margin-right: 16px;
}

.item-time {
  font-size: 12px;
  color: #909399;
  flex-shrink: 0;
}

.item-desc {
  font-size: 13px;
  color: #606266;
  margin-top: 8px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

.empty-notice {
  text-align: center;
  color: #909399;
  padding: 40px 0;
}

.view-more {
  text-align: center;
  padding: 16px 0;
  border-top: 1px solid #ebeef5;
}

/* 自定义滚动条样式 */
.content-list::-webkit-scrollbar {
  width: 6px;
}

.content-list::-webkit-scrollbar-thumb {
  background: #909399;
  border-radius: 3px;
}

.content-list::-webkit-scrollbar-track {
  background: #f5f7fa;
}

.quick-actions-container {
  padding: 20px 0;
}

.quick-actions-row {
  margin-bottom: 30px;
  display: flex;
  justify-content: center;
}

.quick-action-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 24px 10px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.8);
  height: 120px;
}

.quick-action-item:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.95);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.action-icon {
  width: 56px;
  height: 56px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.action-icon .el-icon {
  font-size: 28px;
  color: white;
}

.quick-action-item span {
  font-size: 14px;
  color: #303133;
  text-align: center;
}

/* 图标颜色类 */
.blue-icon {
  background: linear-gradient(135deg, #4096ff 0%, #1677ff 100%);
}

.green-icon {
  background: linear-gradient(135deg, #52c41a 0%, #389e0d 100%);
}

.orange-icon {
  background: linear-gradient(135deg, #ffa940 0%, #fa8c16 100%);
}

.purple-icon {
  background: linear-gradient(135deg, #9254de 0%, #722ed1 100%);
}

.cyan-icon {
  background: linear-gradient(135deg, #36cfc9 0%, #13c2c2 100%);
}

.pink-icon {
  background: linear-gradient(135deg, #f759ab 0%, #eb2f96 100%);
}

/* 中国政府网按钮样式 */
.gov-button-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px 0;
}

.gov-button {
  width: 160px;
  height: 160px;
  background: linear-gradient(135deg, #fff 0%, #f5f5f5 100%);
  box-shadow: 0 8px 32px rgba(222, 41, 16, 0.2);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 15px;
  position: relative;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 8px;
  border: 2px solid rgba(222, 41, 16, 0.3);
}

.gov-button::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    45deg,
    transparent,
    rgba(222, 41, 16, 0.1),
    transparent
  );
  animation: shine 3s infinite;
}

.gov-button::after {
  content: "★";
  position: absolute;
  top: 10px;
  left: 10px;
  font-size: 24px;
  color: #de2910;
  text-shadow: 0 0 10px rgba(222, 41, 16, 0.3);
}

.gov-button .action-icon {
  width: 64px;
  height: 64px;
  background: linear-gradient(135deg, #de2910 0%, #c62410 100%);
  box-shadow: 0 4px 15px rgba(222, 41, 16, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  position: relative;
}

.gov-button .action-icon::before {
  content: "★";
  position: absolute;
  font-size: 32px;
  color: rgba(255, 255, 255, 0.9);
  animation: rotate 20s linear infinite;
}

.gov-button span {
  font-size: 16px;
  font-weight: bold;
  color: #de2910;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.gov-button:hover {
  transform: translateY(-10px);
  box-shadow: 0 15px 40px rgba(222, 41, 16, 0.3);
}

.gov-button:active {
  transform: translateY(-5px);
}

/* 统一的红色图标样式 */
.red-icon {
  background: linear-gradient(135deg, #de2910 0%, #c62410 100%);
  box-shadow: 0 4px 15px rgba(222, 41, 16, 0.3);
}

@keyframes shine {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.gov-button-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  border: 2px solid rgba(222, 41, 16, 0.2);
  border-radius: 8px;
}

/* 法院网特殊样式 */
.law-button {
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
  box-shadow: 0 8px 32px rgba(43, 75, 143, 0.2);
}

.law-button::after {
  content: "★";
  color: #2b4b8f;
  text-shadow: 0 0 10px rgba(43, 75, 143, 0.3);
}

.law-button .action-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button span {
  color: #2b4b8f;
}

.law-button:hover {
  box-shadow: 0 15px 40px rgba(43, 75, 143, 0.3);
}

.law-button .gov-button-decoration {
  border-color: rgba(43, 75, 143, 0.2);
}

@keyframes shine {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* 添加五星红旗元素 */
.gov-button::before,
.law-button::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 40px;
  height: 40px;
  background: #de2910;
  clip-path: polygon(
    50% 0%,
    61% 35%,
    98% 35%,
    68% 57%,
    79% 91%,
    50% 70%,
    21% 91%,
    32% 57%,
    2% 35%,
    39% 35%
  );
}

.law-button::before {
  background: #2b4b8f;
}

/* 页面切换动画 */
:global(.page-transition) {
  position: relative;
}

:global(.page-transition::after) {
  content: "";
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(2px);
  z-index: 9999;
  animation: pageTransition 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes pageTransition {
  0% {
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}

/* 路由过渡动画 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

.dialog-content {
  padding: 20px;
}

.dialog-content .el-descriptions {
  margin-bottom: 20px;
}

.dialog-content :deep(.el-descriptions__label) {
  width: 120px;
  font-weight: bold;
}

.dialog-content :deep(.el-descriptions__content) {
  line-height: 1.6;
  white-space: pre-wrap;
}

.carousel-item {
  height: 100%;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.carousel-item::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(
    circle,
    rgba(64, 158, 255, 0.1) 0%,
    rgba(64, 158, 255, 0) 70%
  );
  opacity: 0;
  transform: scale(0.8);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.carousel-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.2);
}

.carousel-item:hover::before {
  opacity: 1;
  transform: scale(1.5);
}

.carousel-item:active {
  transform: translateY(-2px);
  box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.15);
}

.carousel-item .item-icon {
  font-size: 48px;
  color: #409eff;
  margin-bottom: 16px;
}

.carousel-item .item-title {
  font-size: 20px;
  color: #303133;
  margin: 0 0 12px 0;
  text-align: center;
}

.carousel-item .item-time {
  font-size: 14px;
  color: #909399;
  margin-bottom: 12px;
  text-align: center;
}

.carousel-item .item-desc {
  font-size: 14px;
  color: #606266;
  text-align: center;
  line-height: 1.6;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

:deep(.el-carousel__indicators) {
  transform: translateY(16px);
}

:deep(.el-carousel__arrow) {
  background-color: rgba(0, 0, 0, 0.3);
  border-radius: 50%;
}

:deep(.el-carousel__arrow:hover) {
  background-color: rgba(0, 0, 0, 0.5);
}

/* 轮播切换动画 */
:deep(.el-carousel__item) {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-carousel__item--card) {
  transform: scale(0.95);
}

:deep(.el-carousel__item--card.is-active) {
  transform: scale(1);
}

/* 查看更多按钮动画 */
.view-more .el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.view-more .el-button:hover {
  transform: translateX(5px);
}

.view-more .el-button:active {
  transform: translateX(2px);
}

/* 对话框动画 */
:deep(.el-dialog) {
  transform-origin: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-dialog__wrapper) {
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.dialog-fade-enter-active) {
  animation: dialog-fade-in 0.3s;
}

:deep(.dialog-fade-leave-active) {
  animation: dialog-fade-out 0.3s;
}

@keyframes dialog-fade-in {
  0% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
  100% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
}

@keyframes dialog-fade-out {
  0% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
  100% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
}

/* 快捷操作卡片样式 */
.quick-actions {
  background: linear-gradient(135deg, #f5f7fa 0%, #ffffff 100%);
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.quick-actions :deep(.el-card__header) {
  border-bottom: 1px solid #f0f0f0;
  padding: 16px 20px;
}

.quick-actions .card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.quick-actions .card-header span {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

/* 内容区域样式优化 */
.content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background-color: #f0f2f5;
  height: calc(100vh - 60px);
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 路由视图容器 */
.content > :deep(.router-view-container) {
  position: relative;
  min-height: 100%;
}

/* 优化卡片切换动画 */
.el-card {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
    box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化按钮动画 */
.el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.el-button:active {
  transform: scale(0.98);
}

/* 优化图标动画 */
.el-icon {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化输入框动画 */
.el-input__inner {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* 全局过渡动画样式 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

/* 页面切换遮罩动画 */
.page-mask {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(4px);
  z-index: 9999;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.page-mask.active {
  opacity: 1;
}

/* 全局滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: #909399;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #606266;
}

/* 全局平滑滚动 */
html {
  scroll-behavior: smooth;
}

/* 全局过渡效果 */
* {
  transition: background-color 0.3s, border-color 0.3s, color 0.3s;
}

/* 动画关键帧 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes patternMove {
  from {
    background-position: 0 0;
  }
  to {
    background-position: 40px 40px;
  }
}

@keyframes gradientText {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

/* 添加 animate.css 的延迟类 */
.animate__delay-0s {
  animation-delay: 0.2s;
}

.animate__delay-1s {
  animation-delay: 0.4s;
}

.animate__delay-2s {
  animation-delay: 0.6s;
}

.animate__delay-3s {
  animation-delay: 0.8s;
}

.animate__delay-4s {
  animation-delay: 1s;
}

.animate__delay-5s {
  animation-delay: 1.2s;
}

.menu-container {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 60px); /* 减去 logo 的高度 */
  min-height: min-content; /* 确保内容过多时可以撑开 */
}

.logout-wrapper {
  margin-top: auto;
  border-top: 1px solid rgba(255, 255, 255, 0.05);
}

.logout-item {
  height: 60px !important;
  background-color: #304156 !important;
  padding: 0 20px !important;
}

.important-links-container {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 30px;
  padding: 20px 0;
  flex-wrap: wrap;
}

.blue-law-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button {
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
  box-shadow: 0 8px 32px rgba(43, 75, 143, 0.2);
}

.law-button span {
  color: #2b4b8f;
}

.law-button::after {
  content: "★";
  color: #2b4b8f;
  text-shadow: 0 0 10px rgba(43, 75, 143, 0.3);
}

.law-button .action-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button .gov-button-decoration {
  border-color: rgba(43, 75, 143, 0.2);
}

@keyframes shine {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* 添加五星红旗元素 */
.gov-button::before,
.law-button::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 40px;
  height: 40px;
  background: #de2910;
  clip-path: polygon(
    50% 0%,
    61% 35%,
    98% 35%,
    68% 57%,
    79% 91%,
    50% 70%,
    21% 91%,
    32% 57%,
    2% 35%,
    39% 35%
  );
}

.law-button::before {
  background: #2b4b8f;
}

/* 添加党员网特殊样式 */
.red-party-icon {
  background: linear-gradient(135deg, #de2910 0%, #c62410 100%);
  box-shadow: 0 4px 15px rgba(222, 41, 16, 0.3);
}

/* 页面切换动画 */
:global(.page-transition) {
  position: relative;
}

:global(.page-transition::after) {
  content: "";
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(2px);
  z-index: 9999;
  animation: pageTransition 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes pageTransition {
  0% {
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}

/* 路由过渡动画 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

.dialog-content {
  padding: 20px;
}

.dialog-content .el-descriptions {
  margin-bottom: 20px;
}

.dialog-content :deep(.el-descriptions__label) {
  width: 120px;
  font-weight: bold;
}

.dialog-content :deep(.el-descriptions__content) {
  line-height: 1.6;
  white-space: pre-wrap;
}

.carousel-item {
  height: 100%;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.carousel-item::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(
    circle,
    rgba(64, 158, 255, 0.1) 0%,
    rgba(64, 158, 255, 0) 70%
  );
  opacity: 0;
  transform: scale(0.8);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.carousel-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.2);
}

.carousel-item:hover::before {
  opacity: 1;
  transform: scale(1.5);
}

.carousel-item:active {
  transform: translateY(-2px);
  box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.15);
}

.carousel-item .item-icon {
  font-size: 48px;
  color: #409eff;
  margin-bottom: 16px;
}

.carousel-item .item-title {
  font-size: 20px;
  color: #303133;
  margin: 0 0 12px 0;
  text-align: center;
}

.carousel-item .item-time {
  font-size: 14px;
  color: #909399;
  margin-bottom: 12px;
  text-align: center;
}

.carousel-item .item-desc {
  font-size: 14px;
  color: #606266;
  text-align: center;
  line-height: 1.6;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

:deep(.el-carousel__indicators) {
  transform: translateY(16px);
}

:deep(.el-carousel__arrow) {
  background-color: rgba(0, 0, 0, 0.3);
  border-radius: 50%;
}

:deep(.el-carousel__arrow:hover) {
  background-color: rgba(0, 0, 0, 0.5);
}

/* 轮播切换动画 */
:deep(.el-carousel__item) {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-carousel__item--card) {
  transform: scale(0.95);
}

:deep(.el-carousel__item--card.is-active) {
  transform: scale(1);
}

/* 查看更多按钮动画 */
.view-more .el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.view-more .el-button:hover {
  transform: translateX(5px);
}

.view-more .el-button:active {
  transform: translateX(2px);
}

/* 对话框动画 */
:deep(.el-dialog) {
  transform-origin: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-dialog__wrapper) {
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.dialog-fade-enter-active) {
  animation: dialog-fade-in 0.3s;
}

:deep(.dialog-fade-leave-active) {
  animation: dialog-fade-out 0.3s;
}

@keyframes dialog-fade-in {
  0% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
  100% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
}

@keyframes dialog-fade-out {
  0% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
  100% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
}

/* 快捷操作卡片样式 */
.quick-actions {
  background: linear-gradient(135deg, #f5f7fa 0%, #ffffff 100%);
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.quick-actions :deep(.el-card__header) {
  border-bottom: 1px solid #f0f0f0;
  padding: 16px 20px;
}

.quick-actions .card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.quick-actions .card-header span {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

/* 内容区域样式优化 */
.content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background-color: #f0f2f5;
  height: calc(100vh - 60px);
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 路由视图容器 */
.content > :deep(.router-view-container) {
  position: relative;
  min-height: 100%;
}

/* 优化卡片切换动画 */
.el-card {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
    box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化按钮动画 */
.el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.el-button:active {
  transform: scale(0.98);
}

/* 优化图标动画 */
.el-icon {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化输入框动画 */
.el-input__inner {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* 全局过渡动画样式 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

/* 页面切换遮罩动画 */
.page-mask {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(4px);
  z-index: 9999;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.page-mask.active {
  opacity: 1;
}

/* 全局滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: #909399;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #606266;
}

/* 全局平滑滚动 */
html {
  scroll-behavior: smooth;
}

/* 全局过渡效果 */
* {
  transition: background-color 0.3s, border-color 0.3s, color 0.3s;
}

/* 动画关键帧 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes patternMove {
  from {
    background-position: 0 0;
  }
  to {
    background-position: 40px 40px;
  }
}

@keyframes gradientText {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

/* 添加 animate.css 的延迟类 */
.animate__delay-0s {
  animation-delay: 0.2s;
}

.animate__delay-1s {
  animation-delay: 0.4s;
}

.animate__delay-2s {
  animation-delay: 0.6s;
}

.animate__delay-3s {
  animation-delay: 0.8s;
}

.animate__delay-4s {
  animation-delay: 1s;
}

.animate__delay-5s {
  animation-delay: 1.2s;
}

.menu-container {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 60px); /* 减去 logo 的高度 */
  min-height: min-content; /* 确保内容过多时可以撑开 */
}

.logout-wrapper {
  margin-top: auto;
  border-top: 1px solid rgba(255, 255, 255, 0.05);
}

.logout-item {
  height: 60px !important;
  background-color: #304156 !important;
  padding: 0 20px !important;
}

.important-links-container {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 30px;
  padding: 20px 0;
  flex-wrap: wrap;
}

.blue-law-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button {
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
  box-shadow: 0 8px 32px rgba(43, 75, 143, 0.2);
}

.law-button span {
  color: #2b4b8f;
}

.law-button::after {
  content: "★";
  color: #2b4b8f;
  text-shadow: 0 0 10px rgba(43, 75, 143, 0.3);
}

.law-button .action-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button .gov-button-decoration {
  border-color: rgba(43, 75, 143, 0.2);
}

@keyframes shine {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* 添加五星红旗元素 */
.gov-button::before,
.law-button::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 40px;
  height: 40px;
  background: #de2910;
  clip-path: polygon(
    50% 0%,
    61% 35%,
    98% 35%,
    68% 57%,
    79% 91%,
    50% 70%,
    21% 91%,
    32% 57%,
    2% 35%,
    39% 35%
  );
}

.law-button::before {
  background: #2b4b8f;
}

/* 添加党员网特殊样式 */
.red-party-icon {
  background: linear-gradient(135deg, #de2910 0%, #c62410 100%);
  box-shadow: 0 4px 15px rgba(222, 41, 16, 0.3);
}

/* 页面切换动画 */
:global(.page-transition) {
  position: relative;
}

:global(.page-transition::after) {
  content: "";
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(2px);
  z-index: 9999;
  animation: pageTransition 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes pageTransition {
  0% {
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}

/* 路由过渡动画 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

.dialog-content {
  padding: 20px;
}

.dialog-content .el-descriptions {
  margin-bottom: 20px;
}

.dialog-content :deep(.el-descriptions__label) {
  width: 120px;
  font-weight: bold;
}

.dialog-content :deep(.el-descriptions__content) {
  line-height: 1.6;
  white-space: pre-wrap;
}

.carousel-item {
  height: 100%;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.carousel-item::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(
    circle,
    rgba(64, 158, 255, 0.1) 0%,
    rgba(64, 158, 255, 0) 70%
  );
  opacity: 0;
  transform: scale(0.8);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.carousel-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.2);
}

.carousel-item:hover::before {
  opacity: 1;
  transform: scale(1.5);
}

.carousel-item:active {
  transform: translateY(-2px);
  box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.15);
}

.carousel-item .item-icon {
  font-size: 48px;
  color: #409eff;
  margin-bottom: 16px;
}

.carousel-item .item-title {
  font-size: 20px;
  color: #303133;
  margin: 0 0 12px 0;
  text-align: center;
}

.carousel-item .item-time {
  font-size: 14px;
  color: #909399;
  margin-bottom: 12px;
  text-align: center;
}

.carousel-item .item-desc {
  font-size: 14px;
  color: #606266;
  text-align: center;
  line-height: 1.6;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

:deep(.el-carousel__indicators) {
  transform: translateY(16px);
}

:deep(.el-carousel__arrow) {
  background-color: rgba(0, 0, 0, 0.3);
  border-radius: 50%;
}

:deep(.el-carousel__arrow:hover) {
  background-color: rgba(0, 0, 0, 0.5);
}

/* 轮播切换动画 */
:deep(.el-carousel__item) {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-carousel__item--card) {
  transform: scale(0.95);
}

:deep(.el-carousel__item--card.is-active) {
  transform: scale(1);
}

/* 查看更多按钮动画 */
.view-more .el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.view-more .el-button:hover {
  transform: translateX(5px);
}

.view-more .el-button:active {
  transform: translateX(2px);
}

/* 对话框动画 */
:deep(.el-dialog) {
  transform-origin: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-dialog__wrapper) {
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.dialog-fade-enter-active) {
  animation: dialog-fade-in 0.3s;
}

:deep(.dialog-fade-leave-active) {
  animation: dialog-fade-out 0.3s;
}

@keyframes dialog-fade-in {
  0% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
  100% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
}

@keyframes dialog-fade-out {
  0% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
  100% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
}

/* 快捷操作卡片样式 */
.quick-actions {
  background: linear-gradient(135deg, #f5f7fa 0%, #ffffff 100%);
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.quick-actions :deep(.el-card__header) {
  border-bottom: 1px solid #f0f0f0;
  padding: 16px 20px;
}

.quick-actions .card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.quick-actions .card-header span {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

/* 内容区域样式优化 */
.content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background-color: #f0f2f5;
  height: calc(100vh - 60px);
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 路由视图容器 */
.content > :deep(.router-view-container) {
  position: relative;
  min-height: 100%;
}

/* 优化卡片切换动画 */
.el-card {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
    box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化按钮动画 */
.el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.el-button:active {
  transform: scale(0.98);
}

/* 优化图标动画 */
.el-icon {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化输入框动画 */
.el-input__inner {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* 全局过渡动画样式 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

/* 页面切换遮罩动画 */
.page-mask {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(4px);
  z-index: 9999;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.page-mask.active {
  opacity: 1;
}

/* 全局滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: #909399;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #606266;
}

/* 全局平滑滚动 */
html {
  scroll-behavior: smooth;
}

/* 全局过渡效果 */
* {
  transition: background-color 0.3s, border-color 0.3s, color 0.3s;
}

/* 动画关键帧 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes patternMove {
  from {
    background-position: 0 0;
  }
  to {
    background-position: 40px 40px;
  }
}

@keyframes gradientText {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

/* 添加 animate.css 的延迟类 */
.animate__delay-0s {
  animation-delay: 0.2s;
}

.animate__delay-1s {
  animation-delay: 0.4s;
}

.animate__delay-2s {
  animation-delay: 0.6s;
}

.animate__delay-3s {
  animation-delay: 0.8s;
}

.animate__delay-4s {
  animation-delay: 1s;
}

.animate__delay-5s {
  animation-delay: 1.2s;
}

.menu-container {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 60px); /* 减去 logo 的高度 */
  min-height: min-content; /* 确保内容过多时可以撑开 */
}

.logout-wrapper {
  margin-top: auto;
  border-top: 1px solid rgba(255, 255, 255, 0.05);
}

.logout-item {
  height: 60px !important;
  background-color: #304156 !important;
  padding: 0 20px !important;
}

.important-links-container {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 30px;
  padding: 20px 0;
  flex-wrap: wrap;
}

.blue-law-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button {
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
  box-shadow: 0 8px 32px rgba(43, 75, 143, 0.2);
}

.law-button span {
  color: #2b4b8f;
}

.law-button::after {
  content: "★";
  color: #2b4b8f;
  text-shadow: 0 0 10px rgba(43, 75, 143, 0.3);
}

.law-button .action-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button .gov-button-decoration {
  border-color: rgba(43, 75, 143, 0.2);
}

@keyframes shine {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* 添加五星红旗元素 */
.gov-button::before,
.law-button::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 40px;
  height: 40px;
  background: #de2910;
  clip-path: polygon(
    50% 0%,
    61% 35%,
    98% 35%,
    68% 57%,
    79% 91%,
    50% 70%,
    21% 91%,
    32% 57%,
    2% 35%,
    39% 35%
  );
}

.law-button::before {
  background: #2b4b8f;
}

/* 添加党员网特殊样式 */
.red-party-icon {
  background: linear-gradient(135deg, #de2910 0%, #c62410 100%);
  box-shadow: 0 4px 15px rgba(222, 41, 16, 0.3);
}

/* 页面切换动画 */
:global(.page-transition) {
  position: relative;
}

:global(.page-transition::after) {
  content: "";
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(2px);
  z-index: 9999;
  animation: pageTransition 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes pageTransition {
  0% {
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}

/* 路由过渡动画 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

.dialog-content {
  padding: 20px;
}

.dialog-content .el-descriptions {
  margin-bottom: 20px;
}

.dialog-content :deep(.el-descriptions__label) {
  width: 120px;
  font-weight: bold;
}

.dialog-content :deep(.el-descriptions__content) {
  line-height: 1.6;
  white-space: pre-wrap;
}

.carousel-item {
  height: 100%;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.carousel-item::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(
    circle,
    rgba(64, 158, 255, 0.1) 0%,
    rgba(64, 158, 255, 0) 70%
  );
  opacity: 0;
  transform: scale(0.8);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.carousel-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.2);
}

.carousel-item:hover::before {
  opacity: 1;
  transform: scale(1.5);
}

.carousel-item:active {
  transform: translateY(-2px);
  box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.15);
}

.carousel-item .item-icon {
  font-size: 48px;
  color: #409eff;
  margin-bottom: 16px;
}

.carousel-item .item-title {
  font-size: 20px;
  color: #303133;
  margin: 0 0 12px 0;
  text-align: center;
}

.carousel-item .item-time {
  font-size: 14px;
  color: #909399;
  margin-bottom: 12px;
  text-align: center;
}

.carousel-item .item-desc {
  font-size: 14px;
  color: #606266;
  text-align: center;
  line-height: 1.6;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

:deep(.el-carousel__indicators) {
  transform: translateY(16px);
}

:deep(.el-carousel__arrow) {
  background-color: rgba(0, 0, 0, 0.3);
  border-radius: 50%;
}

:deep(.el-carousel__arrow:hover) {
  background-color: rgba(0, 0, 0, 0.5);
}

/* 轮播切换动画 */
:deep(.el-carousel__item) {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-carousel__item--card) {
  transform: scale(0.95);
}

:deep(.el-carousel__item--card.is-active) {
  transform: scale(1);
}

/* 查看更多按钮动画 */
.view-more .el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.view-more .el-button:hover {
  transform: translateX(5px);
}

.view-more .el-button:active {
  transform: translateX(2px);
}

/* 对话框动画 */
:deep(.el-dialog) {
  transform-origin: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-dialog__wrapper) {
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.dialog-fade-enter-active) {
  animation: dialog-fade-in 0.3s;
}

:deep(.dialog-fade-leave-active) {
  animation: dialog-fade-out 0.3s;
}

@keyframes dialog-fade-in {
  0% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
  100% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
}

@keyframes dialog-fade-out {
  0% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
  100% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
}

/* 快捷操作卡片样式 */
.quick-actions {
  background: linear-gradient(135deg, #f5f7fa 0%, #ffffff 100%);
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.quick-actions :deep(.el-card__header) {
  border-bottom: 1px solid #f0f0f0;
  padding: 16px 20px;
}

.quick-actions .card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.quick-actions .card-header span {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

/* 内容区域样式优化 */
.content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background-color: #f0f2f5;
  height: calc(100vh - 60px);
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 路由视图容器 */
.content > :deep(.router-view-container) {
  position: relative;
  min-height: 100%;
}

/* 优化卡片切换动画 */
.el-card {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
    box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化按钮动画 */
.el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.el-button:active {
  transform: scale(0.98);
}

/* 优化图标动画 */
.el-icon {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化输入框动画 */
.el-input__inner {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* 全局过渡动画样式 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

/* 页面切换遮罩动画 */
.page-mask {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(4px);
  z-index: 9999;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.page-mask.active {
  opacity: 1;
}

/* 全局滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: #909399;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #606266;
}

/* 全局平滑滚动 */
html {
  scroll-behavior: smooth;
}

/* 全局过渡效果 */
* {
  transition: background-color 0.3s, border-color 0.3s, color 0.3s;
}

/* 动画关键帧 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes patternMove {
  from {
    background-position: 0 0;
  }
  to {
    background-position: 40px 40px;
  }
}

@keyframes gradientText {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

/* 添加 animate.css 的延迟类 */
.animate__delay-0s {
  animation-delay: 0.2s;
}

.animate__delay-1s {
  animation-delay: 0.4s;
}

.animate__delay-2s {
  animation-delay: 0.6s;
}

.animate__delay-3s {
  animation-delay: 0.8s;
}

.animate__delay-4s {
  animation-delay: 1s;
}

.animate__delay-5s {
  animation-delay: 1.2s;
}

.menu-container {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 60px); /* 减去 logo 的高度 */
  min-height: min-content; /* 确保内容过多时可以撑开 */
}

.logout-wrapper {
  margin-top: auto;
  border-top: 1px solid rgba(255, 255, 255, 0.05);
}

.logout-item {
  height: 60px !important;
  background-color: #304156 !important;
  padding: 0 20px !important;
}

.important-links-container {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 30px;
  padding: 20px 0;
  flex-wrap: wrap;
}

.blue-law-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button {
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
  box-shadow: 0 8px 32px rgba(43, 75, 143, 0.2);
}

.law-button span {
  color: #2b4b8f;
}

.law-button::after {
  content: "★";
  color: #2b4b8f;
  text-shadow: 0 0 10px rgba(43, 75, 143, 0.3);
}

.law-button .action-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button .gov-button-decoration {
  border-color: rgba(43, 75, 143, 0.2);
}

@keyframes shine {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* 添加五星红旗元素 */
.gov-button::before,
.law-button::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 40px;
  height: 40px;
  background: #de2910;
  clip-path: polygon(
    50% 0%,
    61% 35%,
    98% 35%,
    68% 57%,
    79% 91%,
    50% 70%,
    21% 91%,
    32% 57%,
    2% 35%,
    39% 35%
  );
}

.law-button::before {
  background: #2b4b8f;
}

/* 添加党员网特殊样式 */
.red-party-icon {
  background: linear-gradient(135deg, #de2910 0%, #c62410 100%);
  box-shadow: 0 4px 15px rgba(222, 41, 16, 0.3);
}

/* 页面切换动画 */
:global(.page-transition) {
  position: relative;
}

:global(.page-transition::after) {
  content: "";
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(2px);
  z-index: 9999;
  animation: pageTransition 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes pageTransition {
  0% {
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}

/* 路由过渡动画 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

.dialog-content {
  padding: 20px;
}

.dialog-content .el-descriptions {
  margin-bottom: 20px;
}

.dialog-content :deep(.el-descriptions__label) {
  width: 120px;
  font-weight: bold;
}

.dialog-content :deep(.el-descriptions__content) {
  line-height: 1.6;
  white-space: pre-wrap;
}

.carousel-item {
  height: 100%;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.carousel-item::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(
    circle,
    rgba(64, 158, 255, 0.1) 0%,
    rgba(64, 158, 255, 0) 70%
  );
  opacity: 0;
  transform: scale(0.8);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.carousel-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.2);
}

.carousel-item:hover::before {
  opacity: 1;
  transform: scale(1.5);
}

.carousel-item:active {
  transform: translateY(-2px);
  box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.15);
}

.carousel-item .item-icon {
  font-size: 48px;
  color: #409eff;
  margin-bottom: 16px;
}

.carousel-item .item-title {
  font-size: 20px;
  color: #303133;
  margin: 0 0 12px 0;
  text-align: center;
}

.carousel-item .item-time {
  font-size: 14px;
  color: #909399;
  margin-bottom: 12px;
  text-align: center;
}

.carousel-item .item-desc {
  font-size: 14px;
  color: #606266;
  text-align: center;
  line-height: 1.6;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

:deep(.el-carousel__indicators) {
  transform: translateY(16px);
}

:deep(.el-carousel__arrow) {
  background-color: rgba(0, 0, 0, 0.3);
  border-radius: 50%;
}

:deep(.el-carousel__arrow:hover) {
  background-color: rgba(0, 0, 0, 0.5);
}

/* 轮播切换动画 */
:deep(.el-carousel__item) {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-carousel__item--card) {
  transform: scale(0.95);
}

:deep(.el-carousel__item--card.is-active) {
  transform: scale(1);
}

/* 查看更多按钮动画 */
.view-more .el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.view-more .el-button:hover {
  transform: translateX(5px);
}

.view-more .el-button:active {
  transform: translateX(2px);
}

/* 对话框动画 */
:deep(.el-dialog) {
  transform-origin: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-dialog__wrapper) {
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.dialog-fade-enter-active) {
  animation: dialog-fade-in 0.3s;
}

:deep(.dialog-fade-leave-active) {
  animation: dialog-fade-out 0.3s;
}

@keyframes dialog-fade-in {
  0% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
  100% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
}

@keyframes dialog-fade-out {
  0% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
  100% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
}

/* 快捷操作卡片样式 */
.quick-actions {
  background: linear-gradient(135deg, #f5f7fa 0%, #ffffff 100%);
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.quick-actions :deep(.el-card__header) {
  border-bottom: 1px solid #f0f0f0;
  padding: 16px 20px;
}

.quick-actions .card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.quick-actions .card-header span {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

/* 内容区域样式优化 */
.content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background-color: #f0f2f5;
  height: calc(100vh - 60px);
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 路由视图容器 */
.content > :deep(.router-view-container) {
  position: relative;
  min-height: 100%;
}

/* 优化卡片切换动画 */
.el-card {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
    box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化按钮动画 */
.el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.el-button:active {
  transform: scale(0.98);
}

/* 优化图标动画 */
.el-icon {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化输入框动画 */
.el-input__inner {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* 全局过渡动画样式 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

/* 页面切换遮罩动画 */
.page-mask {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(4px);
  z-index: 9999;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.page-mask.active {
  opacity: 1;
}

/* 全局滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: #909399;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #606266;
}

/* 全局平滑滚动 */
html {
  scroll-behavior: smooth;
}

/* 全局过渡效果 */
* {
  transition: background-color 0.3s, border-color 0.3s, color 0.3s;
}

/* 动画关键帧 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes patternMove {
  from {
    background-position: 0 0;
  }
  to {
    background-position: 40px 40px;
  }
}

@keyframes gradientText {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

/* 添加 animate.css 的延迟类 */
.animate__delay-0s {
  animation-delay: 0.2s;
}

.animate__delay-1s {
  animation-delay: 0.4s;
}

.animate__delay-2s {
  animation-delay: 0.6s;
}

.animate__delay-3s {
  animation-delay: 0.8s;
}

.animate__delay-4s {
  animation-delay: 1s;
}

.animate__delay-5s {
  animation-delay: 1.2s;
}

.menu-container {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 60px); /* 减去 logo 的高度 */
  min-height: min-content; /* 确保内容过多时可以撑开 */
}

.logout-wrapper {
  margin-top: auto;
  border-top: 1px solid rgba(255, 255, 255, 0.05);
}

.logout-item {
  height: 60px !important;
  background-color: #304156 !important;
  padding: 0 20px !important;
}

.important-links-container {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 30px;
  padding: 20px 0;
  flex-wrap: wrap;
}

.blue-law-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button {
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
  box-shadow: 0 8px 32px rgba(43, 75, 143, 0.2);
}

.law-button span {
  color: #2b4b8f;
}

.law-button::after {
  content: "★";
  color: #2b4b8f;
  text-shadow: 0 0 10px rgba(43, 75, 143, 0.3);
}

.law-button .action-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button .gov-button-decoration {
  border-color: rgba(43, 75, 143, 0.2);
}

@keyframes shine {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* 添加五星红旗元素 */
.gov-button::before,
.law-button::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 40px;
  height: 40px;
  background: #de2910;
  clip-path: polygon(
    50% 0%,
    61% 35%,
    98% 35%,
    68% 57%,
    79% 91%,
    50% 70%,
    21% 91%,
    32% 57%,
    2% 35%,
    39% 35%
  );
}

.law-button::before {
  background: #2b4b8f;
}

/* 添加党员网特殊样式 */
.red-party-icon {
  background: linear-gradient(135deg, #de2910 0%, #c62410 100%);
  box-shadow: 0 4px 15px rgba(222, 41, 16, 0.3);
}

/* 页面切换动画 */
:global(.page-transition) {
  position: relative;
}

:global(.page-transition::after) {
  content: "";
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(2px);
  z-index: 9999;
  animation: pageTransition 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes pageTransition {
  0% {
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}

/* 路由过渡动画 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

.dialog-content {
  padding: 20px;
}

.dialog-content .el-descriptions {
  margin-bottom: 20px;
}

.dialog-content :deep(.el-descriptions__label) {
  width: 120px;
  font-weight: bold;
}

.dialog-content :deep(.el-descriptions__content) {
  line-height: 1.6;
  white-space: pre-wrap;
}

.carousel-item {
  height: 100%;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.carousel-item::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(
    circle,
    rgba(64, 158, 255, 0.1) 0%,
    rgba(64, 158, 255, 0) 70%
  );
  opacity: 0;
  transform: scale(0.8);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.carousel-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.2);
}

.carousel-item:hover::before {
  opacity: 1;
  transform: scale(1.5);
}

.carousel-item:active {
  transform: translateY(-2px);
  box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.15);
}

.carousel-item .item-icon {
  font-size: 48px;
  color: #409eff;
  margin-bottom: 16px;
}

.carousel-item .item-title {
  font-size: 20px;
  color: #303133;
  margin: 0 0 12px 0;
  text-align: center;
}

.carousel-item .item-time {
  font-size: 14px;
  color: #909399;
  margin-bottom: 12px;
  text-align: center;
}

.carousel-item .item-desc {
  font-size: 14px;
  color: #606266;
  text-align: center;
  line-height: 1.6;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

:deep(.el-carousel__indicators) {
  transform: translateY(16px);
}

:deep(.el-carousel__arrow) {
  background-color: rgba(0, 0, 0, 0.3);
  border-radius: 50%;
}

:deep(.el-carousel__arrow:hover) {
  background-color: rgba(0, 0, 0, 0.5);
}

/* 轮播切换动画 */
:deep(.el-carousel__item) {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-carousel__item--card) {
  transform: scale(0.95);
}

:deep(.el-carousel__item--card.is-active) {
  transform: scale(1);
}

/* 查看更多按钮动画 */
.view-more .el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.view-more .el-button:hover {
  transform: translateX(5px);
}

.view-more .el-button:active {
  transform: translateX(2px);
}

/* 对话框动画 */
:deep(.el-dialog) {
  transform-origin: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-dialog__wrapper) {
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.dialog-fade-enter-active) {
  animation: dialog-fade-in 0.3s;
}

:deep(.dialog-fade-leave-active) {
  animation: dialog-fade-out 0.3s;
}

@keyframes dialog-fade-in {
  0% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
  100% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
}

@keyframes dialog-fade-out {
  0% {
    transform: translate3d(0, 0, 0);
    opacity: 1;
  }
  100% {
    transform: translate3d(0, -20px, 0);
    opacity: 0;
  }
}

/* 快捷操作卡片样式 */
.quick-actions {
  background: linear-gradient(135deg, #f5f7fa 0%, #ffffff 100%);
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.quick-actions :deep(.el-card__header) {
  border-bottom: 1px solid #f0f0f0;
  padding: 16px 20px;
}

.quick-actions .card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.quick-actions .card-header span {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

/* 内容区域样式优化 */
.content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background-color: #f0f2f5;
  height: calc(100vh - 60px);
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 路由视图容器 */
.content > :deep(.router-view-container) {
  position: relative;
  min-height: 100%;
}

/* 优化卡片切换动画 */
.el-card {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
    box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化按钮动画 */
.el-button {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.el-button:active {
  transform: scale(0.98);
}

/* 优化图标动画 */
.el-icon {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化输入框动画 */
.el-input__inner {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* 全局过渡动画样式 */
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

/* 页面切换遮罩动画 */
.page-mask {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(4px);
  z-index: 9999;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.page-mask.active {
  opacity: 1;
}

/* 全局滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: #909399;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #606266;
}

/* 全局平滑滚动 */
html {
  scroll-behavior: smooth;
}

/* 全局过渡效果 */
* {
  transition: background-color 0.3s, border-color 0.3s, color 0.3s;
}

/* 动画关键帧 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes patternMove {
  from {
    background-position: 0 0;
  }
  to {
    background-position: 40px 40px;
  }
}

@keyframes gradientText {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

/* 添加 animate.css 的延迟类 */
.animate__delay-0s {
  animation-delay: 0.2s;
}

.animate__delay-1s {
  animation-delay: 0.4s;
}

.animate__delay-2s {
  animation-delay: 0.6s;
}

.animate__delay-3s {
  animation-delay: 0.8s;
}

.animate__delay-4s {
  animation-delay: 1s;
}

.animate__delay-5s {
  animation-delay: 1.2s;
}

.menu-container {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 60px); /* 减去 logo 的高度 */
  min-height: min-content; /* 确保内容过多时可以撑开 */
}

.logout-wrapper {
  margin-top: auto;
  border-top: 1px solid rgba(255, 255, 255, 0.05);
}

.logout-item {
  height: 60px !important;
  background-color: #304156 !important;
  padding: 0 20px !important;
}

.important-links-container {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 30px;
  padding: 20px 0;
  flex-wrap: wrap;
}

.blue-law-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button {
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
  box-shadow: 0 8px 32px rgba(43, 75, 143, 0.2);
}

.law-button span {
  color: #2b4b8f;
}

.law-button::after {
  content: "★";
  color: #2b4b8f;
  text-shadow: 0 0 10px rgba(43, 75, 143, 0.3);
}

.law-button .action-icon {
  background: linear-gradient(135deg, #2b4b8f 0%, #1e3d7b 100%);
  box-shadow: 0 4px 15px rgba(43, 75, 143, 0.3);
}

.law-button .gov-button-decoration {
  border-color: rgba(43, 75, 143, 0.2);
}

@keyframes shine {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* 添加五星红旗元素 */
.gov-button::before,
.law-button::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 40px;
  height: 40px;
  background: #de2910;
  clip-path: polygon(
    50% 0%,
    61% 35%,
    98% 35%,
    68% 57%,
    79% 91%,
    50% 70%,
    21% 91%,
    32% 57%,
    2% 35%,
    39% 35%
  );
}

.law-button::before {
  background: #2b4b8f;
}

/* 添加党员网特殊样式 */
.red-party-icon {
}
</style>
