@echo off
setlocal EnableDelayedExpansion
title YHK Produksi - Installer Otomatis
color 0A

echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║     Young Harmonis Konveksi - Installer Otomatis     ║
echo  ║                    Versi 1.0                         ║
echo  ╚══════════════════════════════════════════════════════╝
echo.

:: ── STEP 1: Cek Python ──────────────────────────────────────────────────────
echo [1/5] Mengecek Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo  ❌ Python belum terinstall!
    echo.
    echo  Silakan download dan install Python dulu dari:
    echo  https://python.org/downloads
    echo.
    echo  ⚠️  PENTING: Centang "Add Python to PATH" saat install!
    echo.
    echo  Setelah install Python, jalankan file ini lagi.
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('python --version') do set PYVER=%%i
echo  ✓ %PYVER% ditemukan

:: ── STEP 2: Cari folder app ─────────────────────────────────────────────────
echo.
echo [2/5] Menemukan lokasi aplikasi...
set APP_DIR=%~dp0
:: Hapus backslash terakhir
if "%APP_DIR:~-1%"=="\" set APP_DIR=%APP_DIR:~0,-1%
echo  ✓ Aplikasi di: %APP_DIR%

:: ── STEP 3: Install library Python ──────────────────────────────────────────
echo.
echo [3/5] Menginstall library yang dibutuhkan...
echo  (Proses ini 1-3 menit, hanya perlu sekali)
echo.
pip install flask openpyxl reportlab --quiet --disable-pip-version-check
if %errorlevel% neq 0 (
    echo  ❌ Gagal install library. Cek koneksi internet dan coba lagi.
    pause
    exit /b 1
)
echo  ✓ Semua library berhasil diinstall

:: ── STEP 4: Setup OneDrive ───────────────────────────────────────────────────
echo.
echo [4/5] Setup folder data (OneDrive)...
echo.
echo  Pilih lokasi penyimpanan data:
echo.
echo  [1] OneDrive for Business (direkomendasikan untuk tim)
echo  [2] OneDrive Personal
echo  [3] Simpan lokal saja (di komputer ini)
echo.
set /p PILIHAN="  Masukkan pilihan (1/2/3): "

if "%PILIHAN%"=="1" goto onedrive_bisnis
if "%PILIHAN%"=="2" goto onedrive_personal
if "%PILIHAN%"=="3" goto lokal
goto lokal

:onedrive_bisnis
:: Cari folder OneDrive for Business otomatis
set OD_PATH=
for /d %%d in ("%USERPROFILE%\OneDrive - *") do (
    if exist "%%d" set OD_PATH=%%d
)
if defined OD_PATH (
    echo  ✓ OneDrive Business ditemukan: %OD_PATH%
) else (
    echo  ⚠️  OneDrive Business tidak ditemukan otomatis.
    echo  Masukkan path OneDrive Business kamu:
    echo  Contoh: C:\Users\Nama\OneDrive - PT Young Harmonis
    set /p OD_PATH="  Path: "
)
set DATA_DIR=%OD_PATH%\YHK-Produksi-Data
goto setup_data

:onedrive_personal
:: Cari folder OneDrive Personal otomatis
set OD_PATH=
if exist "%USERPROFILE%\OneDrive" set OD_PATH=%USERPROFILE%\OneDrive
if defined OD_PATH (
    echo  ✓ OneDrive Personal ditemukan: %OD_PATH%
) else (
    echo  ⚠️  OneDrive Personal tidak ditemukan.
    set /p OD_PATH="  Masukkan path OneDrive: "
)
set DATA_DIR=%OD_PATH%\YHK-Produksi-Data
goto setup_data

:lokal
set DATA_DIR=%APP_DIR%\data
goto setup_data

:setup_data
echo.
echo  📁 Data akan disimpan di:
echo     %DATA_DIR%
echo.
if not exist "%DATA_DIR%" (
    mkdir "%DATA_DIR%"
    mkdir "%DATA_DIR%\foto"
    echo  ✓ Folder data dibuat
) else (
    echo  ✓ Folder data sudah ada (data lama tetap aman)
)

:: Simpan path data ke file config
echo %DATA_DIR%> "%APP_DIR%\data_path.txt"
echo  ✓ Konfigurasi disimpan

:: ── STEP 5: Buat shortcut di Desktop ────────────────────────────────────────
echo.
echo [5/5] Membuat shortcut di Desktop...

:: Buat launcher .bat yang sudah tahu path OneDrive
set LAUNCHER=%APP_DIR%\BUKA-YHK.bat
(
echo @echo off
echo title YHK Produksi
echo set YHK_DATA_DIR=%DATA_DIR%
echo cd /d "%APP_DIR%"
echo echo.
echo echo  ╔═══════════════════════════════════════╗
echo echo  ║   Young Harmonis Konveksi             ║
echo echo  ║   Sistem Produksi - Sedang Berjalan   ║
echo echo  ╚═══════════════════════════════════════╝
echo echo.
echo echo  Buka browser dan ketik:
echo echo  http://localhost:5000
echo echo.
echo echo  Tekan Ctrl+C untuk menutup aplikasi
echo echo.
echo start "" "http://localhost:5000"
echo python app.py
echo pause
) > "%LAUNCHER%"

:: Buat shortcut di Desktop pakai PowerShell
powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%USERPROFILE%\Desktop\YHK Produksi.lnk'); $s.TargetPath = '%LAUNCHER%'; $s.WorkingDirectory = '%APP_DIR%'; $s.Description = 'Young Harmonis Konveksi - Sistem Produksi'; $s.Save()" >nul 2>&1

if exist "%USERPROFILE%\Desktop\YHK Produksi.lnk" (
    echo  ✓ Shortcut "YHK Produksi" berhasil dibuat di Desktop
) else (
    echo  ✓ File BUKA-YHK.bat dibuat di folder aplikasi
)

:: ── SELESAI ──────────────────────────────────────────────────────────────────
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║                  ✅ INSTALASI SELESAI!               ║
echo  ╠══════════════════════════════════════════════════════╣
echo  ║                                                      ║
echo  ║  Cara pakai selanjutnya:                             ║
echo  ║  → Double-click "YHK Produksi" di Desktop           ║
echo  ║  → Browser akan terbuka otomatis                     ║
echo  ║                                                      ║
echo  ║  Data tersimpan di OneDrive dan tersinkron           ║
echo  ║  ke semua komputer yang sudah diinstall              ║
echo  ║                                                      ║
echo  ╚══════════════════════════════════════════════════════╝
echo.

set /p MULAI="  Mau langsung buka aplikasinya sekarang? (y/n): "
if /i "%MULAI%"=="y" (
    set YHK_DATA_DIR=%DATA_DIR%
    start "" "http://localhost:5000"
    python app.py
)

pause
