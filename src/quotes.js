export const quotes = [
  {
    text: "Whether you think you can, or you think you can't – you're right.",
    author: "Henry Ford"
  },
  {
    text: "A journey of a thousand miles begins with a single step.",
    author: "Laozi"
  },
  {
    text: "Success is not final, failure is not fatal: it is the courage to continue that counts.",
    author: "Winston Churchill"
  },
  {
    text: "Your time is limited, so don't waste it living someone else's life.",
    author: "Steve Jobs"
  },
  {
    text: "Never put off till tomorrow what you can do today.",
    author: "Benjamin Franklin"
  },
  {
    text: "Even the darkest night will end and the sun will rise.",
    author: "Victor Hugo"
  },
  {
    text: "He who conquers himself is the mightiest warrior.",
    author: "Confucius"
  },
  {
    text: "All our dreams can come true, if we have the courage to pursue them.",
    author: "Walt Disney"
  },
  {
    text: "Learning without thought is labor lost; thought without learning is perilous.",
    author: "Confucius"
  },
  {
    text: "Happiness is when what you think, what you say, and what you do are in harmony.",
    author: "Mahatma Gandhi"
  },
  {
    text: "Failure is just part of the process, and it's not just okay, it's better than okay.",
    author: "Albert Einstein"
  },
  {
    text: "The biggest adventure you can take is to live the life of your dreams.",
    author: "Oprah Winfrey"
  },
  {
    text: "No pain, no gain.",
    author: "Benjamin Franklin"
  },
  {
    text: "Life is like riding a bicycle. To keep your balance, you must keep moving.",
    author: "Albert Einstein"
  },
  {
    text: "You are not defeated when you lose. You are defeated when you quit.",
    author: "Elbert Hubbard"
  },
  {
    text: "Do not be afraid of small beginnings. All great things have small starts.",
    author: "Samuel Smiles"
  },
  {
    text: "The best preparation for tomorrow is doing your best today.",
    author: "H. Jackson Brown Jr."
  },
  {
    text: "Don't be afraid of change. Change is the mother of growth.",
    author: "Leo Buscaglia"
  },
  {
    text: "Your attitude determines your altitude.",
    author: "Zig Ziglar"
  },
  {
    text: "Knowledge is power.",
    author: "Francis Bacon"
  },
  {
    text: "A pessimist sees the difficulty in every opportunity; an optimist sees the opportunity in every difficulty.",
    author: "Winston Churchill"
  },
  {
    text: "Courage is the first of human qualities because it is the quality which guarantees all others.",
    author: "Aristotle"
  },
  {
    text: "To accomplish great things, we must not only act, but also dream.",
    author: "Anatole France"
  },
  {
    text: "To love oneself is the beginning of a lifelong romance.",
    author: "Oscar Wilde"
  },
  {
    text: "Not every day is a good day, but there is something good in every day.",
    author: "Alice Morse Earle"
  },
  {
    text: "It does not matter how slowly you go as long as you do not stop.",
    author: "Confucius"
  },
  {
    text: "When you want something, all the universe conspires in helping you to achieve it.",
    author: "Paulo Coelho"
  },
  {
    text: "The meaning of life is to find your gift. The purpose of life is to give it away.",
    author: "Pablo Picasso"
  },
  {
    text: "You can, you should, and if you're brave enough to start, you will.",
    author: "Marie Curie"
  },
  {
    text: "Enjoy today. Yesterday is gone and tomorrow has not yet come.",
    author: "Dale Carnegie"
  },
  {
    text: "Well begun is half done.",
    author: "Aristotle"
  }
]

export function getDailyQuote() {
  const today = new Date()
  const dayOfYear = Math.floor(
    (today - new Date(today.getFullYear(), 0, 0)) / (1000 * 60 * 60 * 24)
  )
  return quotes[dayOfYear % quotes.length]
}
