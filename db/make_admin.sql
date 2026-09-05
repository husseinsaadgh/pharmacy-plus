-- بعد إنشاء المستخدم من Supabase Authentication > Users
-- استبدل UUID أدناه بمعرّف المستخدم الخاص بك ثم شغّل هذا الاستعلام مرة واحدة.
insert into public.profiles(id, display_name, role)
values ('PUT-YOUR-USER-UUID-HERE', 'حسين سعد قاسم', 'admin')
on conflict (id) do update set
  display_name = excluded.display_name,
  role = 'admin';
