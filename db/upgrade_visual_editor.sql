-- Run this ONCE if you already ran schema.sql before adding the visual editor.
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
