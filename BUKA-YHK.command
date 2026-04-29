#!/bin/bash
export YHK_DATA_DIR="/Users/adhiitmuh/Library/CloudStorage/OneDrive-Pribadi/YHK-Produksi-Data"
cd "/Users/adhiitmuh/Documents/yhk-app"
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
