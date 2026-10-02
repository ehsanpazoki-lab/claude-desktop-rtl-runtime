# امنیت — Claude Desktop RTL Runtime

[English](SECURITY.md) | **فارسی**

این پروژه عمداً از تغییر Package نصب‌شده Claude اجتناب می‌کند:

- `app.asar` تغییر نمی‌کند.
- مالکیت/Permission `WindowsApps` تغییر نمی‌کند.
- MSIX دوباره Sign نمی‌شود.
- Certificate نصب نمی‌شود.
- Administrator لازم نیست.

برای تزریق runtime، Developer Mode و **Main Process Debugger** محلی Claude استفاده می‌شود. تا وقتی Debugger فعال است، پردازش دیگری که با همان حساب کاربری ویندوز اجرا می‌شود ممکن است بتواند به endpoint محلی inspector دسترسی پیدا کند.

Debugger را از طریق Firewall، Proxy، Tunnel یا port forwarding روی شبکه منتشر نکنید.

## ارتباط شبکه

نسخه Portable در Setup اولیه upstream pinشده را از GitHub و Vazirmatn را از jsDelivr دریافت می‌کند.

نسخه Installer این فایل‌ها را از قبل داخل بسته دارد و برای RTL/Vazirmatn به دانلود first-run نیاز ندارد.

Wrapper محتوای گفتگو را آپلود نمی‌کند.

## گزارش امنیتی

Credential، Token یا متن خصوصی گفتگو را در Issue عمومی منتشر نکنید. در صورت فعال بودن Private Vulnerability Reporting از آن استفاده کنید.
