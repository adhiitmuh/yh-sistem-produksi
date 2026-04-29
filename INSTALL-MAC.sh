#!/bin/bash
# ═══════════════════════════════════════════════════════════
#   Young Harmonis Konveksi - Mac Installer
# ═══════════════════════════════════════════════════════════

APP_DIR="$(cd "$(dirname "$0")" && pwd)"
clear

echo ""
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║     Young Harmonis Konveksi - Installer Mac          ║"
echo "  ║                    Versi 1.0                         ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo ""

# ── STEP 1: Cek Python ──────────────────────────────────────
echo "[1/5] Mengecek Python..."
if ! command -v python3 &>/dev/null; then
    echo ""
    echo "  ❌ Python3 belum terinstall!"
    echo ""
    echo "  Download dari: https://python.org/downloads"
    echo "  Atau install via Homebrew: brew install python3"
    echo ""
    exit 1
fi
PYVER=$(python3 --version)
echo "  ✓ $PYVER ditemukan"

# ── STEP 2: Lokasi app ──────────────────────────────────────
echo ""
echo "[2/5] Lokasi aplikasi..."
echo "  ✓ Aplikasi di: $APP_DIR"

# ── STEP 3: Install library ─────────────────────────────────
echo ""
echo "[3/5] Menginstall library Python..."
echo "  (1-3 menit, hanya sekali)"
echo ""
pip3 install flask openpyxl reportlab --quiet 2>/dev/null || \
pip3 install flask openpyxl reportlab --quiet --break-system-packages 2>/dev/null
if [ $? -ne 0 ]; then
    echo "  ❌ Gagal install. Cek koneksi internet."
    exit 1
fi
echo "  ✓ Semua library berhasil diinstall"

# ── STEP 4: Setup OneDrive ───────────────────────────────────
echo ""
echo "[4/5] Setup folder data (OneDrive)..."
echo ""
echo "  Pilih lokasi penyimpanan data:"
echo ""
echo "  [1] OneDrive for Business (direkomendasikan untuk tim)"
echo "  [2] OneDrive Personal"  
echo "  [3] Simpan lokal saja"
echo ""
read -p "  Masukkan pilihan (1/2/3): " PILIHAN

case $PILIHAN in
1)
    # Cari OneDrive Business
    OD_PATH=""
    for d in "$HOME"/Library/CloudStorage/OneDrive-*; do
        [ -d "$d" ] && OD_PATH="$d" && break
    done
    # Fallback: cari di ~/OneDrive - *
    if [ -z "$OD_PATH" ]; then
        for d in "$HOME"/OneDrive\ -*; do
            [ -d "$d" ] && OD_PATH="$d" && break
        done
    fi
    if [ -n "$OD_PATH" ]; then
        echo "  ✓ OneDrive Business ditemukan: $OD_PATH"
    else
        echo "  ⚠️  OneDrive Business tidak ditemukan otomatis."
        echo "  Contoh path: /Users/namakamu/Library/CloudStorage/OneDrive-PTYoungHarmonis"
        read -p "  Masukkan path OneDrive Business: " OD_PATH
    fi
    DATA_DIR="$OD_PATH/YHK-Produksi-Data"
    ;;
2)
    # Cari OneDrive Personal
    OD_PATH=""
    if [ -d "$HOME/Library/CloudStorage/OneDrive-Personal" ]; then
        OD_PATH="$HOME/Library/CloudStorage/OneDrive-Personal"
    elif [ -d "$HOME/OneDrive" ]; then
        OD_PATH="$HOME/OneDrive"
    fi
    if [ -n "$OD_PATH" ]; then
        echo "  ✓ OneDrive Personal: $OD_PATH"
    else
        read -p "  Masukkan path OneDrive Personal: " OD_PATH
    fi
    DATA_DIR="$OD_PATH/YHK-Produksi-Data"
    ;;
*)
    DATA_DIR="$APP_DIR/data"
    ;;
esac

echo ""
echo "  📁 Data akan disimpan di:"
echo "     $DATA_DIR"
echo ""
mkdir -p "$DATA_DIR/foto"
echo "$DATA_DIR" > "$APP_DIR/data_path.txt"
echo "  ✓ Folder data siap"

# ── STEP 5: Buat app yang bisa double-click ─────────────────
echo ""
echo "[5/5] Membuat aplikasi yang bisa double-click..."

# Buat launcher .command (bisa double-click di Mac Finder)
LAUNCHER="$APP_DIR/BUKA-YHK.command"
cat > "$LAUNCHER" << LAUNCHER_EOF
#!/bin/bash
export YHK_DATA_DIR="$DATA_DIR"
cd "$APP_DIR"
clear
echo ""
echo "  ╔═══════════════════════════════════════╗"
echo "  ║   Young Harmonis Konveksi             ║"
echo "  ║   Sedang berjalan...                  ║"
echo "  ╚═══════════════════════════════════════╝"
echo ""
echo "  Membuka browser di http://localhost:5000"
echo "  Tekan Ctrl+C untuk menutup aplikasi"
echo ""
sleep 1
open "http://localhost:5000"
python3 app.py
LAUNCHER_EOF
chmod +x "$LAUNCHER"
echo "  ✓ File BUKA-YHK.command dibuat (double-click untuk buka)"

# Buat .app bundle supaya bisa ada ikon di Dock (opsional)
APP_BUNDLE="$HOME/Applications/YHK Produksi.app"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
cat > "$APP_BUNDLE/Contents/MacOS/YHK Produksi" << APP_EOF
#!/bin/bash
export YHK_DATA_DIR="$DATA_DIR"
cd "$APP_DIR"
open "http://localhost:5000"
python3 app.py
APP_EOF
chmod +x "$APP_BUNDLE/Contents/MacOS/YHK Produksi"
cat > "$APP_BUNDLE/Contents/Info.plist" << PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>YHK Produksi</string>
    <key>CFBundleExecutable</key>
    <string>YHK Produksi</string>
    <key>CFBundleIdentifier</key>
    <string>com.youngharmonis.produksi</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSUIElement</key>
    <false/>
</dict>
</plist>
PLIST_EOF

if [ -d "$APP_BUNDLE" ]; then
    echo "  ✓ App 'YHK Produksi' dibuat di ~/Applications"
    echo "    (Bisa drag ke Dock!)"
fi

# ── SELESAI ──────────────────────────────────────────────────
echo ""
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║                ✅ INSTALASI SELESAI!                 ║"
echo "  ╠══════════════════════════════════════════════════════╣"
echo "  ║                                                      ║"
echo "  ║  Cara pakai selanjutnya:                             ║"
echo "  ║  → Double-click BUKA-YHK.command di Finder          ║"
echo "  ║    atau buka YHK Produksi dari ~/Applications        ║"
echo "  ║                                                      ║"
echo "  ║  Data disimpan di OneDrive dan sinkron otomatis      ║"
echo "  ║  ke semua komputer tim yang sudah diinstall          ║"
echo "  ║                                                      ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo ""
read -p "  Buka aplikasi sekarang? (y/n): " BUKA
if [[ "$BUKA" =~ ^[Yy]$ ]]; then
    export YHK_DATA_DIR="$DATA_DIR"
    open "http://localhost:5000"
    python3 "$APP_DIR/app.py"
fi
