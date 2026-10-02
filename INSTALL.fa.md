# نصب Claude Desktop RTL Runtime + Vazirmatn

[بازگشت به README فارسی](README.fa.md)

## نصب با Setup.exe — روش پیشنهادی

فایل زیر را از Releases دریافت کنید:

```text
Claude-Desktop-RTL-Runtime-Setup-v0.1.0-beta.exe
```

Installer:

- در سطح کاربر نصب می‌شود و UAC لازم ندارد.
- upstream تست‌شده را داخل بسته دارد.
- Vazirmatn pinشده را داخل بسته دارد.
- برای استفاده عادی Git لازم ندارد.
- Shortcutهای اجرا و Disable را در Start Menu ایجاد می‌کند.

مسیر پیش‌فرض:

```text
%LOCALAPPDATA%\Programs\Claude Desktop RTL Runtime
```

بعد از نصب، **Claude RTL** را از Start Menu اجرا کنید. در هر Session تازه Claude باید یک بار:

```text
Developer → Enable Main Process Debugger
```

را فعال کنید.

## نصب Portable از ZIP

در نسخه Portable ابتدا Git for Windows لازم است. سپس:

```text
Setup-Claude-RTL.cmd
```

این Script پروژه upstream را روی commit تست‌شده pin می‌کند و Vazirmatn را آماده می‌کند.

بعد:

```text
Claude-RTL-Run.cmd
```

## Disable / Restore

```text
Disable-Claude-RTL.cmd
```

اگر Debugger فعال باشد، ظاهر Session فعلی بلافاصله Restore می‌شود و Developer Mode نیز برای اجرای بعدی غیرفعال می‌شود.

## Uninstall

در نسخه Installer از **Settings → Apps → Installed apps** استفاده کنید.

Uninstall فقط فایل‌های این ابزار را حذف می‌کند و Claude Desktop اصلی را تغییر نمی‌دهد. بهتر است قبل از Uninstall، `Disable Claude RTL` را اجرا کنید یا Claude را کامل Quit کنید.
