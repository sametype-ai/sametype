<template>
  <div class="daily-quote">
    <div class="greeting-section">
      <p class="time-label">{{ timeOfDay }}</p>
      <h1 class="greeting">{{ greeting }}</h1>
      <p class="date">{{ formattedDate }}</p>
    </div>

    <div class="divider">
      <span class="divider-icon">✦</span>
    </div>

    <div class="quote-section">
      <p class="quote-label">오늘의 명언</p>
      <blockquote class="quote-text">
        <span class="quote-mark open">"</span>
        {{ quote.text }}
        <span class="quote-mark close">"</span>
      </blockquote>
      <p class="quote-author">— {{ quote.author }}</p>
    </div>

    <div class="btn-group">
      <button class="refresh-btn" @click="refreshQuote" :class="{ spinning: isSpinning }">
        <span class="refresh-icon">↻</span>
        다른 명언 보기
      </button>
      <button class="copy-btn" @click="copyQuote">
        <span>{{ copied ? '✓ 복사됨' : '복사' }}</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { quotes, getDailyQuote } from '../quotes.js'

const currentQuote = ref(getDailyQuote())
const isSpinning = ref(false)
const copied = ref(false)

const quote = computed(() => currentQuote.value)

const now = new Date()
const hour = now.getHours()

const timeOfDay = computed(() => {
  if (hour >= 5 && hour < 12) return '🌅 좋은 아침이에요'
  if (hour >= 12 && hour < 17) return '☀️ 좋은 오후예요'
  if (hour >= 17 && hour < 21) return '🌇 좋은 저녁이에요'
  return '🌙 좋은 밤이에요'
})

const greeting = computed(() => {
  if (hour >= 5 && hour < 12) return '오늘 하루도 힘차게 시작해요!'
  if (hour >= 12 && hour < 17) return '오늘 오후도 열심히 보내세요!'
  if (hour >= 17 && hour < 21) return '오늘 하루 수고하셨어요!'
  return '오늘도 하루 잘 마무리하셨나요?'
})

const formattedDate = computed(() => {
  const date = new Date()
  return date.toLocaleDateString('ko-KR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    weekday: 'long'
  })
})

function refreshQuote() {
  isSpinning.value = true
  const current = currentQuote.value
  let next
  do {
    next = quotes[Math.floor(Math.random() * quotes.length)]
  } while (next === current)
  currentQuote.value = next
  setTimeout(() => {
    isSpinning.value = false
  }, 500)
}

async function copyQuote() {
  const text = `"${quote.value.text}" — ${quote.value.author}`
  await navigator.clipboard.writeText(text)
  copied.value = true
  setTimeout(() => { copied.value = false }, 2000)
}
</script>

<style scoped>
.daily-quote {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2rem;
  width: 100%;
  max-width: 680px;
  animation: fadeIn 1s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.greeting-section {
  text-align: center;
}

.time-label {
  font-size: 1rem;
  color: rgba(255, 255, 255, 0.75);
  margin-bottom: 0.5rem;
  font-family: 'Noto Sans KR', sans-serif;
  font-weight: 300;
  letter-spacing: 0.05em;
}

.greeting {
  font-family: 'Noto Serif KR', serif;
  font-size: 2rem;
  font-weight: 600;
  color: #fff;
  margin: 0.25rem 0;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.date {
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.6);
  font-family: 'Noto Sans KR', sans-serif;
  font-weight: 300;
  margin-top: 0.5rem;
}

.divider {
  display: flex;
  align-items: center;
  gap: 1rem;
  width: 100%;
  color: rgba(255, 255, 255, 0.3);
}

.divider::before,
.divider::after {
  content: '';
  flex: 1;
  height: 1px;
  background: rgba(255, 255, 255, 0.2);
}

.divider-icon {
  font-size: 0.7rem;
  color: rgba(255, 255, 255, 0.5);
}

.quote-section {
  text-align: center;
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 20px;
  padding: 2.5rem 2rem;
  width: 100%;
}

.quote-label {
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 1.5rem;
  font-family: 'Noto Sans KR', sans-serif;
  font-weight: 300;
}

.quote-text {
  font-family: 'Noto Serif KR', serif;
  font-size: 1.3rem;
  line-height: 1.9;
  color: rgba(255, 255, 255, 0.92);
  margin: 0 0 1.5rem;
  font-weight: 400;
  word-break: keep-all;
  position: relative;
}

.quote-mark {
  font-size: 2rem;
  color: rgba(255, 255, 255, 0.25);
  font-family: Georgia, serif;
  line-height: 0;
  vertical-align: -0.4em;
}

.quote-mark.open {
  margin-right: 0.1em;
}

.quote-mark.close {
  margin-left: 0.1em;
}

.quote-author {
  font-family: 'Noto Sans KR', sans-serif;
  font-size: 0.95rem;
  color: rgba(255, 255, 255, 0.6);
  font-weight: 300;
  letter-spacing: 0.05em;
  margin: 0;
}

.refresh-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: rgba(255, 255, 255, 0.8);
  padding: 0.75rem 1.75rem;
  border-radius: 50px;
  font-size: 0.9rem;
  font-family: 'Noto Sans KR', sans-serif;
  font-weight: 400;
  cursor: pointer;
  transition: all 0.3s ease;
  letter-spacing: 0.03em;
}

.refresh-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.refresh-icon {
  font-size: 1.1rem;
  transition: transform 0.5s ease;
  display: inline-block;
}

.refresh-btn.spinning .refresh-icon {
  transform: rotate(360deg);
}

.btn-group {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.copy-btn {
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: rgba(255, 255, 255, 0.8);
  padding: 0.75rem 1.25rem;
  border-radius: 50px;
  font-size: 0.9rem;
  font-family: 'Noto Sans KR', sans-serif;
  font-weight: 400;
  cursor: pointer;
  transition: all 0.3s ease;
  letter-spacing: 0.03em;
  white-space: nowrap;
}

.copy-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

@media (max-width: 480px) {
  .greeting {
    font-size: 1.5rem;
  }

  .quote-text {
    font-size: 1.1rem;
  }

  .quote-section {
    padding: 2rem 1.5rem;
  }
}
</style>
