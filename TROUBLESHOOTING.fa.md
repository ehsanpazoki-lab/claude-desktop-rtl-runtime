# رفع اشکال Claude RTL

## Launcher منتظر Debugger می‌ماند

در Claude:

```text
Developer → Enable Main Process Debugger
```

را فعال کنید. Launcher تا چند دقیقه منتظر این مرحله می‌ماند.

## Vazirmatn در نسخه Portable دانلود نمی‌شود

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Test-Vazirmatn-Download.ps1
```

در انتها باید `PASS` نمایش داده شود.

## Setup Portable می‌گوید Git پیدا نشد

Git for Windows را نصب کنید یا از Windows Installer استفاده کنید؛ Installer upstream را از قبل داخل بسته دارد و به Git نیاز ندارد.

## Disable ظاهر را برنمی‌گرداند

برای Restore زنده، Main Process Debugger باید هنوز فعال باشد. اگر Debugger بسته شده است:

1. `Disable-Claude-RTL.cmd` را اجرا کنید تا Developer Mode غیرفعال شود.
2. Claude را کامل Quit کنید.
3. Claude را به‌صورت عادی باز کنید.

## بعد از Update Claude مشکل ایجاد شد

شماره نسخه Claude و Screenshot بدون داده خصوصی را در Issue ثبت کنید. UI داخلی Claude API عمومی نیست و ممکن است selectorها تغییر کنند.
