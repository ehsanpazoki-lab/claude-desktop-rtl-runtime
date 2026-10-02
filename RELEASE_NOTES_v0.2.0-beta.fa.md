# v0.2.0-beta

نسخه یکپارچه UX برای Claude Desktop RTL Runtime + Vazirmatn.

قابلیت‌های جدید:

- اضافه شدن System Tray Controller سبک برای ویندوز
- منوی Tray شامل `Enable RTL`، `Disable RTL`، `Status` و `Exit Tray Controller`
- دابل‌کلیک روی آیکن Tray برای شروع فرآیند فعال‌سازی Claude RTL
- اضافه شدن فرمان مستقل `Claude RTL Status`
- ایجاد فولدر صریح در Start Menu شامل:
  - Claude RTL
  - Disable Claude RTL
  - Claude RTL Status
  - RTL Tray Controller
  - مستندات فارسی/انگلیسی
  - Uninstall
- Desktop shortcut همچنان اختیاری و پیش‌فرض خاموش است.
- گزینه اختیاری `Start RTL tray controller with Windows` اضافه شده و پیش‌فرض خاموش است.
- در پایان نصب امکان اجرای Tray Controller وجود دارد.
- هنگام Uninstall، Tray Controller قبل از حذف فایل‌ها متوقف می‌شود.
- مرحله دستی Claude همچنان باقی است: در Session تازه باید
  `Developer → Enable Main Process Debugger`
  فعال شود تا تزریق runtime کامل شود.

Tray Controller در سطح User اجرا می‌شود و Administrator لازم ندارد.
هیچ Patch روی app.asar یا re-sign کردن MSIX انجام نمی‌شود.
