# Pharmacy Plus — Ready Final

**إدارة وتطوير: حسين سعد قاسم**

هذه النسخة هي النسخة التي تعتمدها من الآن. تحتوي حاليًا على 212 دواء، 14 نظامًا، 19 Clinical Guide، 6 حالات سريرية، 10 أسئلة، و6 تداخلات تعليمية.

## تشغيل محلي
افتح `index.html`، أو من داخل المجلد شغّل:

```bash
python -m http.server 8000
```

ثم افتح `http://localhost:8000`.

## إعداد Supabase — بالترتيب
1. افتح Supabase > SQL Editor.
2. شغّل `db/schema.sql` مرة واحدة.
3. شغّل `db/seed.sql`. الملف آمن لإعادة التشغيل لأنه يستخدم upsert ومعرّفات ثابتة للأسئلة.
4. من Authentication > Users أنشئ مستخدم الإدارة.
5. انسخ UUID للمستخدم، افتح `db/make_admin.sql` واستبدل `PUT-YOUR-USER-UUID-HERE` به ثم Run.
6. إعدادات مشروع Supabase الحالية موجودة في `assets/config.js` باستخدام المفتاح العام فقط.

## لوحة الإدارة
افتح الموقع > إدارة الموقع > سجل دخولك بحساب الـAdmin. تستطيع تعديل JSON كاملًا ثم الضغط على "حفظ إلى قاعدة البيانات". النسخة الحالية تتحقق من صحة JSON قبل الحفظ.

## النشر المجاني
ارفع محتويات هذا المجلد إلى GitHub، ثم اربط المستودع بـCloudflare Pages. لا توجد عملية build مطلوبة؛ اجعل مجلد الإخراج هو جذر المشروع.

## ملاحظات مهمة
- لا تضع `service_role` key داخل ملفات الموقع.
- المحتوى تعليمي، وليس بديلًا عن النشرات الرسمية أو البروتوكولات المحلية أو الحكم السريري.
- بعض حقول الجرعات/Clinical pearls غير مكتملة في قاعدة المحتوى المحلية عمدًا بدل اختلاق معلومات؛ يجب مراجعتها علميًا قبل اعتبارها مرجعًا نهائيًا.

## Visual no-code editor
This build includes a protected Admin visual editor. After logging in as an admin:
- **تصميم وواجهة**: edit brand, hero, buttons, colors, feature cards, add/delete/reorder custom blocks, with live preview.
- **إدارة المحتوى**: add, edit, duplicate and delete drugs, systems, guides, cases, quiz questions, interactions and study modes using forms.
- **متقدم**: JSON backup/export only; not needed for normal editing.

If the database was created using an older `schema.sql`, run `db/upgrade_visual_editor.sql` once in Supabase SQL Editor before using the visual design save button.


## دخول المدير
بعد تشغيل الموقع، يوجد زر واضح **🔐 دخول المدير** أعلى الصفحة. اضغطه وسجل دخولك بحساب Supabase الذي تم تعيينه admin. بعد نجاح الدخول يتحول الزر إلى **✏️ لوحة التعديل**.
