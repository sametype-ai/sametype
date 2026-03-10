<template>
  <div class="app" :class="bgClass">
    <div class="background-overlay"></div>
    <main class="container">
      <DailyQuote />
    </main>
    <footer class="footer">
      <p>오늘도 좋은 하루 보내세요 ✨</p>
    </footer>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import DailyQuote from './components/DailyQuote.vue'

const hour = new Date().getHours()

const bgClass = computed(() => {
  if (hour >= 5 && hour < 12) return 'bg-morning'
  if (hour >= 12 && hour < 17) return 'bg-afternoon'
  if (hour >= 17 && hour < 21) return 'bg-evening'
  return 'bg-night'
})
</script>

<style scoped>
.app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  transition: background 1s ease;
}

.bg-morning {
  background: linear-gradient(135deg, #f6a04d 0%, #f9c784 30%, #a8c8e8 70%, #7bafd4 100%);
}

.bg-afternoon {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 50%, #43e97b 100%);
}

.bg-evening {
  background: linear-gradient(135deg, #fa709a 0%, #fee140 50%, #f77062 100%);
}

.bg-night {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 40%, #0f3460 70%, #533483 100%);
}

.background-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.15);
  pointer-events: none;
}

.container {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 740px;
  padding: 2rem 1.5rem;
  display: flex;
  justify-content: center;
}

.footer {
  position: relative;
  z-index: 1;
  padding: 1.5rem;
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.85rem;
  font-family: 'Noto Sans KR', sans-serif;
  font-weight: 300;
}
</style>
