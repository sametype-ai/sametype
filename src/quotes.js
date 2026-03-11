import { supabase } from './lib/supabase.js'

const QUOTES_QUERY = `
  id,
  author_en,
  author_ko,
  view_count,
  like_count,
  category:categories(name_en, name_ko, slug),
  translations:quote_translations(language, text),
  tags:quote_tags(tag:tags(name_en, name_ko, slug))
`

function mapQuote(q, language = 'en') {
  const translation = q.translations?.find(t => t.language === language)
    ?? q.translations?.[0]
  return {
    id: q.id,
    text: translation?.text ?? '',
    author: language === 'en' ? q.author_en : (q.author_ko ?? q.author_en),
    category: q.category ?? null,
    viewCount: q.view_count,
    likeCount: q.like_count,
    tags: q.tags?.map(t => t.tag) ?? []
  }
}

export async function fetchAllQuotes(language = 'en') {
  if (!supabase) return []
  const { data, error } = await supabase
    .from('quotes')
    .select(QUOTES_QUERY)
    .order('created_at')

  if (error || !data?.length) return []
  return data.map(q => mapQuote(q, language))
}

export async function getDailyQuote(language = 'en') {
  if (!supabase) return null
  const { data, error } = await supabase
    .from('quotes')
    .select(QUOTES_QUERY)
    .order('created_at')

  if (error || !data?.length) return null

  const today = new Date()
  const dayOfYear = Math.floor(
    (today - new Date(today.getFullYear(), 0, 0)) / 86400000
  )
  return mapQuote(data[dayOfYear % data.length], language)
}

export async function incrementViewCount(quoteId) {
  if (!supabase) return
  await supabase.rpc('increment_view_count', { quote_id: quoteId })
}

export async function toggleLike(quoteId, sessionId) {
  if (!supabase) return false
  const { data: existing } = await supabase
    .from('quote_likes')
    .select('id')
    .eq('quote_id', quoteId)
    .eq('session_id', sessionId)
    .maybeSingle()

  if (existing) {
    await supabase.from('quote_likes').delete().eq('id', existing.id)
    await supabase.rpc('decrement_like_count', { quote_id: quoteId })
    return false
  } else {
    await supabase.from('quote_likes').insert({ quote_id: quoteId, session_id: sessionId })
    await supabase.rpc('increment_like_count', { quote_id: quoteId })
    return true
  }
}
