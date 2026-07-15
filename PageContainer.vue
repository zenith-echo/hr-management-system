<template>
  <div class="page-container">
    <el-card class="page-card">
      <!-- 页头 -->
      <template #header>
        <div class="page-header">
          <div class="header-left">
            <slot name="title">
              <span class="page-title">{{ title }}</span>
            </slot>
          </div>
          <div class="header-right">
            <slot name="actions"></slot>
          </div>
        </div>
      </template>

      <!-- 搜索区域 -->
      <div v-if="$slots.search" class="search-section">
        <slot name="search"></slot>
      </div>

      <!-- 主要内容区域 -->
      <div class="main-content">
        <slot></slot>
      </div>

      <!-- 分页区域 -->
      <div v-if="$slots.pagination" class="pagination-section">
        <slot name="pagination"></slot>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
defineProps({
  title: {
    type: String,
    required: true,
  },
});
</script>

<style scoped>
.page-container {
  padding: 20px;
  height: 100%;
  box-sizing: border-box;
}

.page-card {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.page-card :deep(.el-card__body) {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 20px;
  overflow: hidden;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  display: flex;
  align-items: center;
}

.page-title {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}

.header-right {
  display: flex;
  gap: 10px;
}

.search-section {
  margin-bottom: 20px;
  padding: 18px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.main-content {
  flex: 1;
  overflow: auto;
}

.pagination-section {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

:deep(.el-form--inline .el-form-item) {
  margin-right: 18px;
  margin-bottom: 18px;
}

:deep(.el-button) {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

:deep(.el-table) {
  margin-top: 4px;
}
</style>
