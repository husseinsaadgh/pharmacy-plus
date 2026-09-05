-- Pharmacy Plus production schema for Supabase/Postgres
create extension if not exists pgcrypto;

create table if not exists public.systems (
  id text primary key,
  name text not null,
  en text,
  icon text,
  color text,
  description text,
  topics jsonb default '[]'::jsonb,
  sort_order int generated always as (
    case id
      when 'A' then 1 when 'B' then 2 when 'C' then 3 when 'D' then 4
      when 'G' then 5 when 'H' then 6 when 'J' then 7 when 'L' then 8
      when 'M' then 9 when 'N' then 10 when 'P' then 11 when 'R' then 12
      when 'S' then 13 when 'V' then 14 else 99
    end
  ) stored
);

create table if not exists public.drugs (
  id text primary key,
  name text not null,
  ar text,
  system text not null references public.systems(id) on update cascade,
  class text,
  route text,
  atc text,
  level text,
  uses text,
  moa text,
  adr text,
  contra text,
  counsel text,
  monitor text,
  pearls text,
  dose text,
  tags jsonb default '[]'::jsonb,
  updated_at timestamptz default now()
);

create index if not exists drugs_system_idx on public.drugs(system);
create index if not exists drugs_name_idx on public.drugs using gin (
  to_tsvector('simple', coalesce(name,'') || ' ' || coalesce(ar,''))
);

create table if not exists public.interactions (
  id text primary key,
  a text not null references public.drugs(id) on delete cascade,
  b text not null references public.drugs(id) on delete cascade,
  severity text not null,
  title text not null,
  summary text not null,
  updated_at timestamptz default now()
);

create table if not exists public.cases (
  id text primary key,
  title text not null,
  system text references public.systems(id),
  difficulty text,
  stem text,
  options jsonb default '[]'::jsonb,
  answer int,
  why text,
  tags jsonb default '[]'::jsonb
);

create table if not exists public.quiz_questions (
  id uuid primary key default gen_random_uuid(),
  question text not null,
  answers jsonb not null default '[]'::jsonb,
  correct_index int not null,
  explanation text,
  created_at timestamptz default now()
);

create table if not exists public.guides (
  id text primary key,
  title text not null,
  system text references public.systems(id),
  summary text,
  first_line text,
  alternatives text,
  avoid_text text,
  monitor text,
  source_note text,
  updated_at timestamptz default now()
);

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  role text not null default 'student' check (role in ('student','admin')),
  created_at timestamptz default now()
);

create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path = public
as $$
  select exists(
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin'
  );
$$;

alter table public.systems enable row level security;
alter table public.drugs enable row level security;
alter table public.interactions enable row level security;
alter table public.cases enable row level security;
alter table public.quiz_questions enable row level security;
alter table public.guides enable row level security;
alter table public.profiles enable row level security;

drop policy if exists "public read systems" on public.systems;
create policy "public read systems" on public.systems for select to anon, authenticated using (true);
drop policy if exists "admin write systems" on public.systems;
create policy "admin write systems" on public.systems for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "public read drugs" on public.drugs;
create policy "public read drugs" on public.drugs for select to anon, authenticated using (true);
drop policy if exists "admin write drugs" on public.drugs;
create policy "admin write drugs" on public.drugs for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "public read interactions" on public.interactions;
create policy "public read interactions" on public.interactions for select to anon, authenticated using (true);
drop policy if exists "admin write interactions" on public.interactions;
create policy "admin write interactions" on public.interactions for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "public read cases" on public.cases;
create policy "public read cases" on public.cases for select to anon, authenticated using (true);
drop policy if exists "admin write cases" on public.cases;
create policy "admin write cases" on public.cases for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "public read guides" on public.guides;
create policy "public read guides" on public.guides for select to anon, authenticated using (true);
drop policy if exists "admin write guides" on public.guides;
create policy "admin write guides" on public.guides for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "public read quiz" on public.quiz_questions;
create policy "public read quiz" on public.quiz_questions for select to anon, authenticated using (true);
drop policy if exists "admin write quiz" on public.quiz_questions;
create policy "admin write quiz" on public.quiz_questions for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "users read own profile" on public.profiles;
create policy "users read own profile" on public.profiles for select to authenticated using (id = auth.uid());
drop policy if exists "admin read profiles" on public.profiles;
create policy "admin read profiles" on public.profiles for select to authenticated using (public.is_admin());

revoke all on public.systems, public.drugs, public.interactions, public.cases,
  public.quiz_questions, public.guides, public.profiles from anon, authenticated;

grant select on public.systems, public.drugs, public.interactions, public.cases,
  public.quiz_questions, public.guides to anon, authenticated;
grant select on public.profiles to authenticated;
grant insert, update, delete on public.systems, public.drugs, public.interactions,
  public.cases, public.quiz_questions, public.guides to authenticated;

-- Never put a service_role key in browser-side code.

-- Visual no-code site builder content
create table if not exists public.site_content (
  id text primary key default 'global',
  config jsonb not null default '{}'::jsonb,
  updated_at timestamptz default now()
);
alter table public.site_content enable row level security;
drop policy if exists "public read site content" on public.site_content;
create policy "public read site content" on public.site_content for select to anon, authenticated using (true);
drop policy if exists "admin write site content" on public.site_content;
create policy "admin write site content" on public.site_content for all to authenticated using (public.is_admin()) with check (public.is_admin());
revoke all on public.site_content from anon, authenticated;
grant select on public.site_content to anon, authenticated;
grant insert, update, delete on public.site_content to authenticated;
