# Claude Desktop RTL Runtime + Vazirmatn

[English](README.md) | **فارسی**

> **پروژه غیررسمی جامعه کاربری؛ وابسته به Anthropic نیست و توسط Anthropic تأیید نشده است.**

این پروژه یک Wrapper ویندوز برای ترکیب پروژه MIT-licensed
`Claude RTL Companion` با تزریق runtime فونت Vazirmatn است.

هیچ تغییری در `app.asar`، `WindowsApps` یا امضای MSIX ایجاد نمی‌شود و Administrator لازم نیست.

Upstream برای این Beta روی commit تست‌شده زیر pin شده است:

```text
ab938536096145fb797f2f6cdbc7bb8c1a008b3e
```

## روش پیشنهادی: Installer

برای کاربران عادی، Windows Setup روش پیشنهادی است:

```text
Claude-Desktop-RTL-Runtime-Setup-v0.1.1-beta.exe
```

Installer به‌صورت per-user نصب می‌شود و نسخه pinشده upstream و Vazirmatn را داخل خودش دارد؛ بنابراین برای استفاده معمولی Git لازم نیست.

جزئیات: [INSTALL.fa.md](INSTALL.fa.md)

## روش Portable

نسخه ZIP به Git for Windows برای Setup اولیه نیاز دارد.

ابتدا:

```text
Setup-Claude-RTL.cmd
```

سپس برای استفاده روزمره:

```text
Claude-RTL-Run.cmd
```

در هر Session تازه Claude یک مرحله دستی باقی می‌ماند:

```text
Claude menu → Developer → Enable Main Process Debugger
```

Launcher منتظر فعال شدن Debugger می‌ماند و سپس RTL و Vazirmatn را inject می‌کند.

## Disable / Restore

```text
Disable-Claude-RTL.cmd
```

اگر Main Process Debugger هنوز فعال باشد، RTL و Vazirmatn **فوراً و بدون Restart** از Session فعلی حذف می‌شوند و Developer Mode نیز برای اجرای بعدی خاموش می‌شود.

## امنیت

[SECURITY.fa.md](SECURITY.fa.md)

## محدودیت‌ها

- UI داخلی Claude ممکن است در Updateهای بعدی تغییر کند.
- در هر Session تازه باید Main Process Debugger یک بار دستی فعال شود.
- نسخه Portable برای Setup اولیه به Git نیاز دارد؛ Installer این نیاز را ندارد.

## رفع اشکال

[TROUBLESHOOTING.fa.md](TROUBLESHOOTING.fa.md)

## مجوزها

Wrapper این پروژه: MIT

Claude RTL Companion: MIT

Vazirmatn: OFL-1.1

جزئیات: [THIRD_PARTY_NOTICES.fa.md](THIRD_PARTY_NOTICES.fa.md)


## Shortcut دسکتاپ

- در مرحله نصب می‌توانید با تیک گزینه **Create a desktop shortcut** یک Shortcut برای `Claude RTL` روی Desktop ایجاد کنید؛ این گزینه پیش‌فرض خاموش است.

## کنترل از System Tray

در `v0.2.0-beta` یک Tray Controller سبک اضافه شده است:

```text
Enable RTL
Disable RTL
Status
Exit Tray Controller
```

دابل‌کلیک روی آیکن Tray فرآیند Enable را شروع می‌کند. در هر Session تازه Claude
مرحله دستی زیر همچنان لازم است:

```text
Developer → Enable Main Process Debugger
```

اجرای Tray Controller همراه Windows در Installer اختیاری و پیش‌فرض خاموش است.
Installer فولدر مشخص **Claude Desktop RTL Runtime** را در Start Menu می‌سازد و
Run، Disable، Status، Tray Controller، مستندات و Uninstall همگی داخل همان فولدر
قرار می‌گیرند.
