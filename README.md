# SPEED Car Rental - Flutter App (من الصفر)

## شغال حالياً (Foundation)
- هيكل المشروع + pubspec.yaml
- ثيم أحمر/أسود (SPEED branding)
- اتصال Supabase (لازم تعبي URL + anon key)
- Splash → Fleet (فلتر إيجار/بيع) → Car Detail
  - سيارة إيجار → زر "احجز الآن"
  - سيارة بيع → زرين: اتصال + واتساب
  - سيارة both → الخيارين

## لازم تسويه قبل ما يبني صحيح

1. **`lib/core/supabase_config.dart`**
   عبّي:
   ```
   supabaseUrl = نفس اللي بـ .env.local عند ERP (NEXT_PUBLIC_SUPABASE_URL)
   supabaseAnonKey = نفس NEXT_PUBLIC_SUPABASE_ANON_KEY
   ```

2. **`lib/screens/fleet/car_detail_screen.dart`**
   غيّر:
   ```
   kSalesWhatsappNumber = رقم واتساب المبيعات الحقيقي (973XXXXXXXX بدون +)
   kSalesPhoneNumber   = +973XXXXXXXX
   ```

3. **أسماء أعمدة جدول `cars`** — لازم نتأكد منها بالضبط حتى ما ينكسر شي.
   شغّل بالـ ERP:
   ```bash
   psql $DATABASE_URL -c "\d cars"
   ```
   وأعطني النتيجة، عشان أصحح `lib/models/car_model.dart` و `lib/services/car_service.dart`
   لو أسماء الأعمدة (مثل `daily_rate`, `sale_price`, `listing_type`) مختلفة.

   ⚠️ مهم: لازم يكون فيه عمود `listing_type` بقيم `rent` / `sale` / `both`
   على جدول `cars` بالـ ERP. لو غير موجود لازم نضيفه بمigration بسيطة.

## الخطوات الجاية (بعد التأكد من الـ schema)
- [ ] شاشة Login / Register (مرتبطة بجدول `users` نفسه)
- [ ] شاشة Booking الفعلية (Date picker + إرسال للـ ERP)
- [ ] My Bookings / Profile
- [ ] Favorites + Reviews + Chat (الجداول الثلاثة المذكورة سابقاً لو موجودة)
- [ ] رفع المشروع على ريبو ca2026 (git init / push)
- [ ] ربط codemagic.yaml بنفس مشروعك على codemagic.io

## البناء على Codemagic
الملف `codemagic.yaml` بجذر المشروع جاهز لبناء APK مباشرة.
لازم ترفعه للريبو وتربط مشروع جديد/موجود على Codemagic ويقرأ الملف تلقائياً.
