<template>
  <div class="login-container">
    <div class="login-box">
      <h2>人事管理系统</h2>
      <el-form :model="loginForm" :rules="loginRules" ref="loginFormRef">
        <el-form-item prop="username">
          <el-input v-model="loginForm.username" placeholder="用户名">
            <template #prefix>
              <el-icon>
                <User />
              </el-icon>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="loginForm.password" type="password" placeholder="密码">
            <template #prefix>
              <el-icon>
                <Lock />
              </el-icon>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" @click="handleLogin" style="width: 100%">登录</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from "vue";
import { User, Lock } from "@element-plus/icons-vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";

const router = useRouter();
const loginFormRef = ref(null);
const loading = ref(false);

const loginForm = reactive({
  username: "",
  password: "",
});

const loginRules = {
  username: [{ required: true, message: "请输入用户名", trigger: "blur" }],
  password: [{ required: true, message: "请输入密码", trigger: "blur" }],
};

const handleLogin = () => {
  loginFormRef.value.validate((valid) => {
    if (valid) {
      loading.value = true;
      // 这里模拟登录请求
      setTimeout(() => {
        loading.value = false;
        if (loginForm.username === "root" && loginForm.password === "1234") {
          ElMessage.success("登录成功");
          // 存储登录状态
          localStorage.setItem("token", "admin-token");
          router.push("/dashboard");
        } else {
          ElMessage.error("用户名或密码错误");
        }
      }, 1000);
    }
  });
};
</script>

<style scoped>
.login-container {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: url("/src/assets/flag.png") center/cover no-repeat fixed;
  position: relative;
}

.login-container::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg,
      rgba(255, 255, 255, 0.05) 0%,
      rgba(255, 255, 255, 0.1) 100%);
}

.login-box {
  width: 400px;
  padding: 40px;
  background: rgba(255, 255, 255, 0.85);
  border-radius: 15px;
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(255, 255, 255, 0.18);
  position: relative;
  z-index: 1;
  animation: fadeInUp 0.6s ease-out;
}

.login-box h2 {
  text-align: center;
  margin-bottom: 40px;
  color: #de2910;
  font-size: 28px;
  font-weight: bold;
  letter-spacing: 2px;
  position: relative;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.login-box h2::after {
  content: "";
  position: absolute;
  bottom: -10px;
  left: 50%;
  transform: translateX(-50%);
  width: 50px;
  height: 3px;
  background: #de2910;
  border-radius: 2px;
}

:deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.9);
  box-shadow: 0 0 0 1px #dcdfe6 inset;
  padding: 1px 15px;
  height: 45px;
  transition: all 0.3s;
  backdrop-filter: blur(4px);
}

:deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #de2910 inset;
}

:deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #de2910 inset;
  background: rgba(255, 255, 255, 0.95);
}

:deep(.el-input__inner) {
  height: 45px;
  font-size: 16px;
}

:deep(.el-button--primary) {
  background-color: #de2910;
  border-color: #de2910;
  height: 45px;
  font-size: 16px;
  font-weight: bold;
  letter-spacing: 2px;
  margin-top: 20px;
  transition: all 0.3s;
}

:deep(.el-button--primary:hover) {
  background-color: #c62410;
  border-color: #c62410;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(222, 41, 16, 0.3);
}

:deep(.el-button--primary:active) {
  transform: translateY(0);
}

:deep(.el-form-item) {
  margin-bottom: 25px;
}

:deep(.el-icon) {
  font-size: 20px;
  color: #606266;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 添加响应式设计 */
@media screen and (max-width: 480px) {
  .login-box {
    width: 90%;
    padding: 30px;
  }
}
</style>
