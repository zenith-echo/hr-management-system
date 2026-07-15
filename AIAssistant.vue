<template>
    <!-- 悬浮按钮 -->
    <div class="ai-btn" @click="open = !open">
        🤖
    </div>

    <!-- 智能体窗口 -->
    <div v-if="open" class="ai-panel">
        <div class="ai-header">
            <span>智能体助手</span>
            <span class="close" @click="open = false">✕</span>
        </div>

        <div class="ai-body">
            <div v-for="(msg, index) in messages" :key="index" :class="msg.role">
                {{ msg.text }}
            </div>
        </div>

        <div class="ai-footer">
            <input v-model="input" placeholder="请输入问题..." />
            <button @click="send">发送</button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

// 1. 定义严格的 TypeScript 消息类型接口
interface Message {
    role: 'user' | 'ai';
    text: string;
}

// 2. 声明 template 绑定的三个核心响应式变量（支持 TS 泛型）
const open = ref<boolean>(false); // 控制智能体窗口的显示和隐藏
const input = ref<string>("");     // 绑定输入框的文本
const messages = ref<Message[]>([
    { role: 'ai', text: '你好！我是你的 HR 智能分析助手。你可以问我：“帮我分析一下哪些员工有离职风险？” 或者 “张三的工资是多少？”' }
]);

// 3. 实现发送消息与调用后端 AI 的核心方法
const send = async () => {
    const trimmedInput = input.value.trim();
    if (!trimmedInput) return;

    // 将用户的提问推入对话列表
    messages.value.push({
        role: "user",
        text: trimmedInput
    });

    // 清空输入框
    input.value = "";

    try {
        // 发起网络请求调用后端的 HRAIController
        const res = await fetch("/api/ai/chat", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                question: trimmedInput
            })
        });

        if (!res.ok) {
            throw new Error(`HTTP 错误，状态码: ${res.status}`);
        }

        const data = await res.json();

        // 将后端返回的 AI 深度分析结果推入对话列表
        messages.value.push({
            role: "ai",
            text: data.answer || "AI 助手未返回任何有效回答。"
        });

    } catch (error) {
        console.error("AI 请求失败:", error);
        messages.value.push({
            role: "ai",
            text: "❌ 智能助手暂时不在线，请确保后端 Java 服务正在运行。"
        });
    }
};
</script>

<style scoped>
.ai-btn {
    position: fixed;
    right: 20px;
    bottom: 20px;
    width: 60px;
    height: 60px;
    background: #1677ff;
    color: white;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 28px;
    cursor: pointer;
    z-index: 9999;
}

.ai-panel {
    position: fixed;
    right: 20px;
    bottom: 90px;
    width: 320px;
    height: 420px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    display: flex;
    flex-direction: column;
    z-index: 9999;
}

.ai-header {
    padding: 10px;
    background: #1677ff;
    color: white;
    display: flex;
    justify-content: space-between;
}

.close {
    cursor: pointer;
}

.ai-body {
    flex: 1;
    padding: 10px;
    overflow: auto;
}

.user {
    text-align: right;
    margin: 5px 0;
    color: #333;
}

.ai {
    text-align: left;
    margin: 5px 0;
    color: #1677ff;
}

.ai-footer {
    display: flex;
    border-top: 1px solid #eee;
}

.ai-footer input {
    flex: 1;
    border: none;
    padding: 10px;
    outline: none;
}

.ai-footer button {
    width: 70px;
    background: #1677ff;
    color: white;
    border: none;
    cursor: pointer;
}
</style>