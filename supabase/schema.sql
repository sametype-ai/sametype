-- ============================================================
-- Sametype Daily Quote App — Supabase Schema
-- Run this in Supabase SQL Editor
-- ============================================================

-- Categories
create table if not exists categories (
  id uuid primary key default gen_random_uuid(),
  name_en text not null,
  name_ko text not null,
  slug text not null unique,
  created_at timestamptz default now()
);

-- Tags
create table if not exists tags (
  id uuid primary key default gen_random_uuid(),
  name_en text not null,
  name_ko text not null,
  slug text not null unique,
  created_at timestamptz default now()
);

-- Quotes
create table if not exists quotes (
  id uuid primary key default gen_random_uuid(),
  author_en text not null,
  author_ko text,
  category_id uuid references categories(id) on delete set null,
  view_count integer not null default 0,
  like_count integer not null default 0,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz default now()
);

-- Translations (ko / en)
create table if not exists quote_translations (
  id uuid primary key default gen_random_uuid(),
  quote_id uuid not null references quotes(id) on delete cascade,
  language text not null check (language in ('ko', 'en')),
  text text not null,
  unique(quote_id, language)
);

-- Quote ↔ Tag (many-to-many)
create table if not exists quote_tags (
  quote_id uuid references quotes(id) on delete cascade,
  tag_id uuid references tags(id) on delete cascade,
  primary key (quote_id, tag_id)
);

-- Likes (supports both authenticated and anonymous users)
create table if not exists quote_likes (
  id uuid primary key default gen_random_uuid(),
  quote_id uuid not null references quotes(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  session_id text,
  created_at timestamptz default now(),
  constraint unique_user_like unique (quote_id, user_id),
  constraint unique_session_like unique (quote_id, session_id)
);

-- ============================================================
-- RPC Functions
-- ============================================================

create or replace function increment_view_count(quote_id uuid)
returns void as $$
  update quotes set view_count = view_count + 1 where id = quote_id;
$$ language sql security definer;

create or replace function increment_like_count(quote_id uuid)
returns void as $$
  update quotes set like_count = like_count + 1 where id = quote_id;
$$ language sql security definer;

create or replace function decrement_like_count(quote_id uuid)
returns void as $$
  update quotes set like_count = greatest(0, like_count - 1) where id = quote_id;
$$ language sql security definer;

-- ============================================================
-- Row Level Security
-- ============================================================

alter table categories enable row level security;
alter table tags enable row level security;
alter table quotes enable row level security;
alter table quote_translations enable row level security;
alter table quote_tags enable row level security;
alter table quote_likes enable row level security;

-- Public read access
create policy "Public read categories" on categories for select using (true);
create policy "Public read tags" on tags for select using (true);
create policy "Public read quotes" on quotes for select using (true);
create policy "Public read translations" on quote_translations for select using (true);
create policy "Public read quote_tags" on quote_tags for select using (true);
create policy "Public read likes" on quote_likes for select using (true);

-- Likes: anyone can insert/delete their own session likes
create policy "Insert likes" on quote_likes for insert with check (true);
create policy "Delete own likes" on quote_likes for delete using (
  user_id = auth.uid() or session_id is not null
);
