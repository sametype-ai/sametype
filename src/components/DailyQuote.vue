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

    <div class="quote-section" :class="{ loading: isLoading }">
      <p class="quote-label">
        오늘의 명언
        <span v-if="quote?.category" class="category-badge">{{ quote.category.name_en }}</span>
      </p>

      <template v-if="isLoading">
        <div class="skeleton-text"></div>
        <div class="skeleton-text short"></div>
      </template>
      <template v-else-if="quote">
        <blockquote class="quote-text">
          <span class="quote-mark open">"</span>
          {{ quote.text }}
          <span class="quote-mark close">"</span>
        </blockquote>
        <p class="quote-author">— {{ quote.author }}</p>
        <div v-if="quote.tags?.length" class="tags">
          <span v-for="tag in quote.tags" :key="tag.slug" class="tag">{{ tag.name_en }}</span>
        </div>
      </template>
    </div>

    <div class="btn-group">
      <button class="refresh-btn" @click="refreshQuote" :disabled="isLoading" :class="{ spinning: isSpinning }">
        <span class="refresh-icon">↻</span>
        다른 명언 보기
      </button>
      <button class="like-btn" @click="handleLike" :class="{ liked: isLiked }" :disabled="isLoading">
        <span>{{ isLiked ? '♥' : '♡' }}</span>
        <span v-if="quote?.likeCount" class="like-count">{{ quote.likeCount }}</span>
      </button>
      <button class="copy-btn" @click="copyQuote" :disabled="isLoading">
        <span>{{ copied ? '✓ 복사됨' : '복사' }}</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { fetchAllQuotes, getDailyQuote, incrementViewCount, toggleLike } from '../quotes.js'

const allQuotes = ref([])
const currentQuote = ref(null)
const isLoading = ref(true)
const isSpinning = ref(false)
const copied = ref(false)
const isLiked = ref(false)

const SESSION_KEY = 'dq_session'

function getSessionId() {
  let id = localStorage.getItem(SESSION_KEY)
  if (!id) {
    id = crypto.randomUUID()
    localStorage.setItem(SESSION_KEY, id)
  }
  return id
}

function getLikedKey(quoteId) {
  return `dq_liked_${quoteId}`
}

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
  return new Date().toLocaleDateString('ko-KR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    weekday: 'long'
  })
})

onMounted(async () => {
  try {
    const [daily, all] = await Promise.all([getDailyQuote(), fetchAllQuotes()])
    allQuotes.value = all
    currentQuote.value = daily
    if (daily?.id) {
      isLiked.value = !!localStorage.getItem(getLikedKey(daily.id))
      incrementViewCount(daily.id)
    }
  } catch (e) {
    console.error('Failed to load quotes:', e)
  } finally {
    isLoading.value = false
  }
})

async function refreshQuote() {
  if (!allQuotes.value.length) return
  isSpinning.value = true
  const current = currentQuote.value
  const others = allQuotes.value.filter(q => q.id !== current?.id)
  const next = others[Math.floor(Math.random() * others.length)]
  currentQuote.value = next
  isLiked.value = !!localStorage.getItem(getLikedKey(next.id))
  incrementViewCount(next.id)
  setTimeout(() => { isSpinning.value = false }, 500)
}

async function handleLike() {
  if (!quote.value?.id) return
  const sessionId = getSessionId()
  const nowLiked = await toggleLike(quote.value.id, sessionId)
  isLiked.value = nowLiked
  if (nowLiked) {
    localStorage.setItem(getLikedKey(quote.value.id), '1')
    quote.value.likeCount++
  } else {
    localStorage.removeItem(getLikedKey(quote.value.id))
    quote.value.likeCount = Math.max(0, quote.value.likeCount - 1)
  }
}

async function copyQuote() {
  if (!quote.value) return
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
  min-height: 180px;
}

.quote-label {
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 1.5rem;
  font-family: 'Noto Sans KR', sans-serif;
  font-weight: 300;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
}

.category-badge {
  font-size: 0.7rem;
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 20px;
  padding: 0.15rem 0.6rem;
  text-transform: none;
  letter-spacing: 0.05em;
  color: rgba(255, 255, 255, 0.6);
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

.quote-mark.open { margin-right: 0.1em; }
.quote-mark.close { margin-left: 0.1em; }

.quote-author {
  font-family: 'Noto Sans KR', sans-serif;
  font-size: 0.95rem;
  color: rgba(255, 255, 255, 0.6);
  font-weight: 300;
  letter-spacing: 0.05em;
  margin: 0 0 1rem;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
  justify-content: center;
  margin-top: 1rem;
}

.tag {
  font-size: 0.7rem;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 20px;
  padding: 0.15rem 0.55rem;
  color: rgba(255, 255, 255, 0.45);
  font-family: 'Noto Sans KR', sans-serif;
}

/* Loading skeleton */
.skeleton-text {
  height: 1.3rem;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  margin: 0.5rem auto;
  width: 80%;
  animation: shimmer 1.5s infinite;
}

.skeleton-text.short {
  width: 40%;
  margin-top: 1rem;
}

@keyframes shimmer {
  0%, 100% { opacity: 0.5; }
  50% { opacity: 1; }
}

.btn-group {
  display: flex;
  align-items: center;
  gap: 0.75rem;
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

.refresh-btn:hover:not(:disabled) {
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

.like-btn {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: rgba(255, 255, 255, 0.7);
  padding: 0.75rem 1.1rem;
  border-radius: 50px;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.like-btn:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.like-btn.liked {
  color: #ff6b8a;
  border-color: rgba(255, 107, 138, 0.4);
  background: rgba(255, 107, 138, 0.1);
}

.like-count {
  font-size: 0.8rem;
  font-family: 'Noto Sans KR', sans-serif;
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

.copy-btn:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

@media (max-width: 480px) {
  .greeting { font-size: 1.5rem; }
  .quote-text { font-size: 1.1rem; }
  .quote-section { padding: 2rem 1.5rem; }
}
</style>
