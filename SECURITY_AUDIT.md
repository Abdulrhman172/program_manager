# تقرير فحص الأسرار — program_manager

تم فحص **240 ملفاً** (كل الملفات في الـ ZIP). لم يكن مجلد `.git` موجوداً في الـ ZIP، لذلك **لم أستطع فحص تاريخ الـ commits** (الـ 40 commit).

## النتيجة السريعة
| الفحص | النتيجة |
|---|---|
| مفاتيح `service_role` / مفاتيح سرية (AWS, GitHub, Stripe, Google, OpenAI, Slack) | لم أجد أي منها |
| مفاتيح خاصة / keystore / `.env` / `google-services.json` / ملفات `.sql` أو قاعدة بيانات | لم أجد |
| كلمات مرور حقيقية مكتوبة في الكود | لم أجد (فقط أسماء حقول وأمثلة) |
| بيانات شخصية حقيقية (إيميلات/هواتف) | لا، كلها بيانات وهمية (`ahmed@university.edu`, `+966501234567`) |
| **مفتاح Supabase `anon` + رابط المشروع** | **موجود في 9 ملفات** |
| مسارات شخصية للجهاز (`C:\Users\omar7\...`) | موجودة في ملفين |

## 1) مفتاح Supabase (anon)
- المفتاح في `lib/main.dart` وفي 7 ملفات `test_*.dart` / `fetch_schema.dart`، ورابط المشروع `quakwoghhxoobcgcknsj.supabase.co`.
- فككت الـ JWT: `role = anon` (وليس `service_role`). هذا مفتاح مصمم ليكون عاماً داخل التطبيق، فوجوده في الكود **ليس تسريباً بحد ذاته**.
- لكنه يعني أن **أمان بياناتك يعتمد 100% على إعدادات RLS** في Supabase. بعد نشر الكود سيعرف الجميع رابط قاعدة بياناتك ومفتاحها.

## 2) المشكلة الأخطر (في تصميم قاعدة البيانات، وليست في الملفات)
التطبيق يسجل الدخول هكذا (`auth_controller.dart`):
```dart
.from('ProgramManager').select()
  .eq('prma_username', ...).eq('prma_pass', passwordController.text)
```
أي أن **كلمات المرور مخزنة نصاً عادياً (plain text)** في أعمدة: `prma_pass`, `stud_pass`, `sprvsr_password`, `head_pass`, `pass_user_manager`، والتحقق يتم من التطبيق بمفتاح anon.
لكي يعمل هذا، يجب أن تسمح RLS بقراءة هذه الجداول بمفتاح anon (أو أن RLS معطلة). **إذا كان الأمر كذلك، فأي شخص يملك المفتاح يستطيع تحميل كل كلمات مرور الطلاب والمشرفين.** المفتاح سيصبح علنياً، فهذه أولوية قبل النشر.

### ما يجب فعله قبل النشر
1. افتح Supabase → **Table Editor** وتأكد أن **RLS مفعّلة** على كل الجداول.
2. جرّب من متصفح بدون تسجيل دخول: `GET https://quakwoghhxoobcgcknsj.supabase.co/rest/v1/ProgramManager?select=*` مع header `apikey: <anon key>`. إذا رجعت بيانات فيها كلمات مرور فالتسريب فعلي.
3. غيّر كلمات المرور الحالية لكل المستخدمين (يجب اعتبارها مكشوفة إذا كانت RLS مفتوحة).
4. انتقل إلى **Supabase Auth** (كلمات المرور مشفّرة وتُدار لك) بدل أعمدة `*_pass`، وأضف سياسات RLS حسب `auth.uid()`.
5. إن أردت، دوّر مفتاح anon من Project Settings → API (Rotate) بعد الإصلاح.

## 3) نقل المفتاح خارج الكود (تعديل `lib/main.dart`)
```dart
await Supabase.initialize(
  url: const String.fromEnvironment('SUPABASE_URL'),
  publishableKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
);
```
التشغيل: `flutter run --dart-define-from-file=dart_defines.json` (وملف `dart_defines.json` موجود في `.gitignore`).

## 4) ملفات يجب حذفها/تجاهلها قبل النشر
- `test_acye.dart, test_academy.dart, test_db.dart, test_groups.dart, test_join.dart, test_supervisor.dart, fetch_schema.dart` — تحوي المفتاح والرابط.
- `generate_doc.dart` و `rename_project.ps1` — فيهما مسار جهازك واسم المستخدم `omar7`.
- `swagger.json` — مجرد رسالة خطأ "Invalid API key" (208 بايت)، بلا فائدة.
- `android/build/` — مجلد بناء لا يجب رفعه.
- `web_coordinator/public/__manus__/` — أداة debug مولّدة تلقائياً.
- `COORDINATOR_SYSTEM_README.md` يشير إلى مستودع قديم `headdepartment` — راجعه.
- ملف `قاموس_البيانات.doc` يكشف بنية قاعدة البيانات كاملة (أسماء الجداول والأعمدة). ليس سراً، لكن قرر إن كنت تريد نشره.
- `android/app/build.gradle.kts` يوقّع الإصدار بمفتاح debug، ومعرّف الحزمة `com.example.*` — غيّرهما قبل النشر على المتجر.

## 5) تاريخ الـ commits (مهم)
حتى بعد حذف الملفات، يبقى المحتوى القديم في تاريخ git. المستودع عام أصلاً (Public) حسب لقطتك، فالمفتاح ظاهر منذ الآن. افحص التاريخ على جهازك:
```bash
git clone https://github.com/Abdulrhman172/program_manager
cd program_manager
gitleaks detect --source . -v        # أو: trufflehog git file://. 
git log -p -S"service_role" --all    # بحث يدوي
git log --all --diff-filter=D --name-only | grep -Ei "\.env|key|secret|\.jks"
```
إذا وجدت `service_role` أو مفتاحاً سرياً في التاريخ: **دوّر المفتاح فوراً** (هذا هو الحل الحقيقي)، ثم نظّف التاريخ بـ `git filter-repo` إن أردت.

## خطوات النشر المقترحة
1. أصلح RLS وكلمات المرور (القسم 2).
2. انسخ الملفات الجاهزة إلى جذر المشروع، ثم شغّل `./cleanup_before_publish.sh`.
3. عدّل `main.dart` (القسم 3).
4. افحص التاريخ (القسم 5).
5. أضف README بالإنجليزية فيه خطوات إعداد Supabase.
