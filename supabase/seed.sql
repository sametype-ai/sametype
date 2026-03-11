-- ============================================================
-- Sametype Daily Quote App — Seed Data
-- Run AFTER schema.sql
-- ============================================================

-- Categories
insert into categories (name_en, name_ko, slug) values
  ('Motivation',  '동기부여', 'motivation'),
  ('Philosophy',  '철학',     'philosophy'),
  ('Life',        '인생',     'life'),
  ('Happiness',   '행복',     'happiness'),
  ('Knowledge',   '지식',     'knowledge'),
  ('Courage',     '용기',     'courage')
on conflict (slug) do nothing;

-- Tags
insert into tags (name_en, name_ko, slug) values
  ('Success',    '성공',   'success'),
  ('Mindset',    '마인드셋', 'mindset'),
  ('Action',     '행동',   'action'),
  ('Wisdom',     '지혜',   'wisdom'),
  ('Growth',     '성장',   'growth'),
  ('Dreams',     '꿈',     'dreams'),
  ('Perseverance','인내',  'perseverance'),
  ('Change',     '변화',   'change'),
  ('Self',       '자아',   'self')
on conflict (slug) do nothing;

-- ============================================================
-- Quotes with translations
-- ============================================================

do $$
declare
  q_id uuid;
  cat_motivation uuid;
  cat_philosophy uuid;
  cat_life uuid;
  cat_happiness uuid;
  cat_knowledge uuid;
  cat_courage uuid;

  tag_success uuid;
  tag_mindset uuid;
  tag_action uuid;
  tag_wisdom uuid;
  tag_growth uuid;
  tag_dreams uuid;
  tag_perseverance uuid;
  tag_change uuid;
  tag_self uuid;
begin
  select id into cat_motivation  from categories where slug = 'motivation';
  select id into cat_philosophy  from categories where slug = 'philosophy';
  select id into cat_life        from categories where slug = 'life';
  select id into cat_happiness   from categories where slug = 'happiness';
  select id into cat_knowledge   from categories where slug = 'knowledge';
  select id into cat_courage     from categories where slug = 'courage';

  select id into tag_success     from tags where slug = 'success';
  select id into tag_mindset     from tags where slug = 'mindset';
  select id into tag_action      from tags where slug = 'action';
  select id into tag_wisdom      from tags where slug = 'wisdom';
  select id into tag_growth      from tags where slug = 'growth';
  select id into tag_dreams      from tags where slug = 'dreams';
  select id into tag_perseverance from tags where slug = 'perseverance';
  select id into tag_change      from tags where slug = 'change';
  select id into tag_self        from tags where slug = 'self';

  -- 1. Henry Ford
  insert into quotes (author_en, author_ko, category_id) values ('Henry Ford', '헨리 포드', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Whether you think you can, or you think you can''t – you''re right.'),
    (q_id, 'ko', '당신이 할 수 있다고 믿든, 할 수 없다고 믿든, 당신의 믿음이 맞습니다.');
  insert into quote_tags values (q_id, tag_mindset), (q_id, tag_success);

  -- 2. Laozi
  insert into quotes (author_en, author_ko, category_id) values ('Laozi', '노자', cat_philosophy) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'A journey of a thousand miles begins with a single step.'),
    (q_id, 'ko', '천 리 길도 한 걸음부터.');
  insert into quote_tags values (q_id, tag_action), (q_id, tag_wisdom);

  -- 3. Winston Churchill
  insert into quotes (author_en, author_ko, category_id) values ('Winston Churchill', '윈스턴 처칠', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Success is not final, failure is not fatal: it is the courage to continue that counts.'),
    (q_id, 'ko', '성공은 최종이 아니며, 실패는 치명적이지 않습니다. 중요한 것은 계속 나아가는 용기입니다.');
  insert into quote_tags values (q_id, tag_success), (q_id, tag_perseverance);

  -- 4. Steve Jobs
  insert into quotes (author_en, author_ko, category_id) values ('Steve Jobs', '스티브 잡스', cat_life) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Your time is limited, so don''t waste it living someone else''s life.'),
    (q_id, 'ko', '당신의 시간은 한정되어 있습니다. 다른 사람의 삶을 사는 데 낭비하지 마세요.');
  insert into quote_tags values (q_id, tag_self), (q_id, tag_action);

  -- 5. Benjamin Franklin
  insert into quotes (author_en, author_ko, category_id) values ('Benjamin Franklin', '벤저민 프랭클린', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Never put off till tomorrow what you can do today.'),
    (q_id, 'ko', '오늘 할 수 있는 일을 내일로 미루지 말라.');
  insert into quote_tags values (q_id, tag_action);

  -- 6. Victor Hugo
  insert into quotes (author_en, author_ko, category_id) values ('Victor Hugo', '빅토르 위고', cat_life) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Even the darkest night will end and the sun will rise.'),
    (q_id, 'ko', '가장 어두운 밤도 끝나고 태양은 다시 뜰 것입니다.');
  insert into quote_tags values (q_id, tag_perseverance);

  -- 7. Confucius (self-conquest)
  insert into quotes (author_en, author_ko, category_id) values ('Confucius', '공자', cat_philosophy) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'He who conquers himself is the mightiest warrior.'),
    (q_id, 'ko', '자신을 이기는 자가 가장 강한 자이다.');
  insert into quote_tags values (q_id, tag_self), (q_id, tag_wisdom);

  -- 8. Walt Disney
  insert into quotes (author_en, author_ko, category_id) values ('Walt Disney', '월트 디즈니', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'All our dreams can come true, if we have the courage to pursue them.'),
    (q_id, 'ko', '꿈을 꿀 수 있다면, 그 꿈을 이룰 수도 있습니다.');
  insert into quote_tags values (q_id, tag_dreams), (q_id, tag_courage);

  -- 9. Confucius (learning)
  insert into quotes (author_en, author_ko, category_id) values ('Confucius', '공자', cat_knowledge) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Learning without thought is labor lost; thought without learning is perilous.'),
    (q_id, 'ko', '배움에는 끝이 없다. 멈추는 순간 뒤처진다.');
  insert into quote_tags values (q_id, tag_wisdom), (q_id, tag_growth);

  -- 10. Mahatma Gandhi
  insert into quotes (author_en, author_ko, category_id) values ('Mahatma Gandhi', '마하트마 간디', cat_happiness) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Happiness is when what you think, what you say, and what you do are in harmony.'),
    (q_id, 'ko', '행복은 당신이 생각하는 것, 말하는 것, 행동하는 것이 조화를 이룰 때 찾아옵니다.');
  insert into quote_tags values (q_id, tag_self), (q_id, tag_wisdom);

  -- 11. Albert Einstein (failure)
  insert into quotes (author_en, author_ko, category_id) values ('Albert Einstein', '알버트 아인슈타인', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Failure is just part of the process, and it''s not just okay, it''s better than okay.'),
    (q_id, 'ko', '실패는 성공으로 가는 길의 일부일 뿐입니다.');
  insert into quote_tags values (q_id, tag_growth), (q_id, tag_perseverance);

  -- 12. Oprah Winfrey
  insert into quotes (author_en, author_ko, category_id) values ('Oprah Winfrey', '오프라 윈프리', cat_life) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'The biggest adventure you can take is to live the life of your dreams.'),
    (q_id, 'ko', '지금 이 순간이 당신의 인생에서 가장 아름다운 날입니다.');
  insert into quote_tags values (q_id, tag_dreams), (q_id, tag_self);

  -- 13. Benjamin Franklin (no pain)
  insert into quotes (author_en, author_ko, category_id) values ('Benjamin Franklin', '벤저민 프랭클린', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'No pain, no gain.'),
    (q_id, 'ko', '고통이 없으면 얻는 것도 없다.');
  insert into quote_tags values (q_id, tag_perseverance), (q_id, tag_growth);

  -- 14. Albert Einstein (bicycle)
  insert into quotes (author_en, author_ko, category_id) values ('Albert Einstein', '알버트 아인슈타인', cat_life) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Life is like riding a bicycle. To keep your balance, you must keep moving.'),
    (q_id, 'ko', '인생은 자전거 타기와 같습니다. 균형을 유지하려면 계속 움직여야 합니다.');
  insert into quote_tags values (q_id, tag_action), (q_id, tag_perseverance);

  -- 15. Elbert Hubbard
  insert into quotes (author_en, author_ko, category_id) values ('Elbert Hubbard', '엘버트 허버드', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'You are not defeated when you lose. You are defeated when you quit.'),
    (q_id, 'ko', '당신이 포기하지 않는 한, 당신은 실패하지 않습니다.');
  insert into quote_tags values (q_id, tag_perseverance);

  -- 16. Samuel Smiles
  insert into quotes (author_en, author_ko, category_id) values ('Samuel Smiles', '사무엘 스마일스', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Do not be afraid of small beginnings. All great things have small starts.'),
    (q_id, 'ko', '작은 시작을 두려워하지 마세요. 모든 위대한 것도 작게 시작했습니다.');
  insert into quote_tags values (q_id, tag_action), (q_id, tag_growth);

  -- 17. H. Jackson Brown Jr.
  insert into quotes (author_en, author_ko, category_id) values ('H. Jackson Brown Jr.', 'H. 잭슨 브라운 주니어', cat_life) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'The best preparation for tomorrow is doing your best today.'),
    (q_id, 'ko', '오늘 하루를 열심히 사는 것이 내일을 준비하는 가장 좋은 방법입니다.');
  insert into quote_tags values (q_id, tag_action);

  -- 18. Leo Buscaglia
  insert into quotes (author_en, author_ko, category_id) values ('Leo Buscaglia', '리오 버스카글리아', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Don''t be afraid of change. Change is the mother of growth.'),
    (q_id, 'ko', '변화를 두려워하지 마세요. 변화는 성장의 어머니입니다.');
  insert into quote_tags values (q_id, tag_change), (q_id, tag_growth);

  -- 19. Zig Ziglar
  insert into quotes (author_en, author_ko, category_id) values ('Zig Ziglar', '지그 지글러', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Your attitude determines your altitude.'),
    (q_id, 'ko', '당신의 태도가 당신의 고도를 결정합니다.');
  insert into quote_tags values (q_id, tag_mindset);

  -- 20. Francis Bacon
  insert into quotes (author_en, author_ko, category_id) values ('Francis Bacon', '프랜시스 베이컨', cat_knowledge) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Knowledge is power.'),
    (q_id, 'ko', '지식은 힘이다.');
  insert into quote_tags values (q_id, tag_wisdom);

  -- 21. Winston Churchill (optimist)
  insert into quotes (author_en, author_ko, category_id) values ('Winston Churchill', '윈스턴 처칠', cat_philosophy) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'A pessimist sees the difficulty in every opportunity; an optimist sees the opportunity in every difficulty.'),
    (q_id, 'ko', '낙관주의자는 모든 어려움에서 기회를 봅니다.');
  insert into quote_tags values (q_id, tag_mindset), (q_id, tag_wisdom);

  -- 22. Aristotle (courage)
  insert into quotes (author_en, author_ko, category_id) values ('Aristotle', '아리스토텔레스', cat_courage) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Courage is the first of human qualities because it is the quality which guarantees all others.'),
    (q_id, 'ko', '용감한 사람만이 진정한 행복을 얻을 수 있습니다.');
  insert into quote_tags values (q_id, tag_courage);

  -- 23. Anatole France
  insert into quotes (author_en, author_ko, category_id) values ('Anatole France', '아나톨 프랑스', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'To accomplish great things, we must not only act, but also dream.'),
    (q_id, 'ko', '위대한 일을 이루려면, 행동해야 할 뿐 아니라 꿈을 꿔야 합니다.');
  insert into quote_tags values (q_id, tag_dreams), (q_id, tag_action);

  -- 24. Oscar Wilde
  insert into quotes (author_en, author_ko, category_id) values ('Oscar Wilde', '오스카 와일드', cat_happiness) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'To love oneself is the beginning of a lifelong romance.'),
    (q_id, 'ko', '자신을 사랑하는 것이 평생 지속되는 로맨스의 시작입니다.');
  insert into quote_tags values (q_id, tag_self);

  -- 25. Alice Morse Earle
  insert into quotes (author_en, author_ko, category_id) values ('Alice Morse Earle', '앨리스 모스 얼', cat_happiness) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Not every day is a good day, but there is something good in every day.'),
    (q_id, 'ko', '모든 날이 좋은 날은 아닙니다. 하지만 모든 날 안에는 좋은 것이 있습니다.');
  insert into quote_tags values (q_id, tag_mindset);

  -- 26. Confucius (slowly)
  insert into quotes (author_en, author_ko, category_id) values ('Confucius', '공자', cat_philosophy) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'It does not matter how slowly you go as long as you do not stop.'),
    (q_id, 'ko', '멈추지 않는 한, 얼마나 천천히 가더라도 상관없습니다.');
  insert into quote_tags values (q_id, tag_perseverance), (q_id, tag_wisdom);

  -- 27. Paulo Coelho
  insert into quotes (author_en, author_ko, category_id) values ('Paulo Coelho', '파울로 코엘료', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'When you want something, all the universe conspires in helping you to achieve it.'),
    (q_id, 'ko', '당신이 무언가를 진심으로 원한다면, 온 우주가 당신이 그것을 이루도록 도울 것입니다.');
  insert into quote_tags values (q_id, tag_dreams), (q_id, tag_mindset);

  -- 28. Pablo Picasso
  insert into quotes (author_en, author_ko, category_id) values ('Pablo Picasso', '파블로 피카소', cat_life) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'The meaning of life is to find your gift. The purpose of life is to give it away.'),
    (q_id, 'ko', '인생의 의미는 당신의 재능을 발견하는 것입니다. 인생의 목적은 그것을 나누는 것입니다.');
  insert into quote_tags values (q_id, tag_self), (q_id, tag_wisdom);

  -- 29. Marie Curie
  insert into quotes (author_en, author_ko, category_id) values ('Marie Curie', '마리 퀴리', cat_motivation) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'You can, you should, and if you''re brave enough to start, you will.'),
    (q_id, 'ko', '할 수 있다고 생각하면 할 수 있습니다. 못한다고 생각하면 못합니다.');
  insert into quote_tags values (q_id, tag_mindset), (q_id, tag_courage);

  -- 30. Dale Carnegie
  insert into quotes (author_en, author_ko, category_id) values ('Dale Carnegie', '데일 카네기', cat_happiness) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Enjoy today. Yesterday is gone and tomorrow has not yet come.'),
    (q_id, 'ko', '오늘을 즐기세요. 어제는 이미 지나갔고 내일은 아직 오지 않았습니다.');
  insert into quote_tags values (q_id, tag_mindset);

  -- 31. Aristotle (well begun)
  insert into quotes (author_en, author_ko, category_id) values ('Aristotle', '아리스토텔레스', cat_philosophy) returning id into q_id;
  insert into quote_translations (quote_id, language, text) values
    (q_id, 'en', 'Well begun is half done.'),
    (q_id, 'ko', '시작이 반이다.');
  insert into quote_tags values (q_id, tag_action), (q_id, tag_wisdom);

end $$;
