# 🧵 Young Harmonis Konveksi — Panduan Setup Lengkap
## Multi-Komputer dengan OneDrive

---

## 🗺️ Gambaran Sistem

```
   Mac kamu (owner)
        │
        ▼
   OneDrive Business ──────────────────────────────┐
   /YHK-Produksi-Data/                             │
   ├── transaksi.json   ◄── sinkron otomatis       │
   ├── kasbon.json           ke semua komputer      │
   ├── settings.json                                │
   └── foto/                                        │
        │                                           │
        ├── Windows PC 1 (anggota 1)               │
        ├── Windows PC 2 (anggota 2)               │
        ├── Windows PC 3 (anggota 3)               │
        └── Windows PC 4+ (anggota lainnya) ◄──────┘

Semua orang input data → tersimpan di OneDrive → 
semua bisa lihat data terbaru
```

---

## 📋 Urutan Setup (Lakukan sekali)

### A. Setup di Mac kamu dulu (PERTAMA)

1. **Pastikan OneDrive Business sudah login** di Mac
   - Cek di menu bar atas, ada ikon OneDrive (awan biru)
   - Kalau belum: download dari https://apps.microsoft.com/onedrive

2. **Ekstrak ZIP aplikasi** ke folder yang mudah diingat
   - Contoh: `~/Documents/yhk-app/`

3. **Jalankan installer Mac:**
   ```bash
   cd ~/Documents/yhk-app
   bash INSTALL-MAC.sh
   ```
   - Pilih **[1] OneDrive for Business**
   - Installer akan otomatis menemukan folder OneDrive-mu

4. **Setelah install**, aplikasi bisa dibuka dengan:
   - Double-click `BUKA-YHK.command` di Finder
   - Atau buka `YHK Produksi` dari folder Applications

---

### B. Setup di tiap komputer Windows anggota

> Lakukan ini **satu per satu** di setiap komputer Windows

#### Langkah di setiap komputer Windows:

**1. Pastikan Python sudah terinstall**
   - Download: https://python.org/downloads
   - ⚠️ Centang **"Add Python to PATH"** saat install!

**2. Pastikan OneDrive Business sudah login**
   - Di Windows 10/11, OneDrive sudah built-in
   - Login dengan akun Microsoft 365 bisnis

**3. Copy folder aplikasi ke komputer ini**
   - Copy folder `yhk-app` ke komputer (bisa pakai USB atau kirim via email/WhatsApp)
   - Letakkan di `C:\yhk-app\` atau `D:\yhk-app\`

**4. Jalankan installer:**
   - Double-click `INSTALL-WINDOWS.bat`
   - Pilih **[1] OneDrive for Business**
   - Installer otomatis mencari folder OneDrive-mu
   - Tunggu sampai muncul "✅ INSTALASI SELESAI!"

**5. Shortcut `YHK Produksi` akan muncul di Desktop**
   - Double-click untuk buka aplikasi
   - Browser terbuka otomatis ke http://localhost:5000

---

## 🔄 Cara Kerja Sinkronisasi

```
Anggota input data di PC Windows
        │
        ▼
Data tersimpan ke folder OneDrive di komputer itu
        │
        ▼
OneDrive sinkron otomatis ke cloud (butuh internet)
        │
        ▼
Mac kamu dan semua PC lain download perubahan otomatis
        │
        ▼
Semua orang lihat data terbaru ✓
```

**Catatan penting:**
- Butuh koneksi internet untuk sinkronisasi
- Kalau offline: bisa tetap input data, akan sinkron saat online lagi
- Jangan buka aplikasi di 2 komputer **bersamaan** untuk input data yang sama
  (bisa konflik file JSON)

---

## 📁 Struktur Folder OneDrive

```
OneDrive - PT Young Harmonis/
└── YHK-Produksi-Data/
    ├── transaksi.json    ← semua data setor/ambil/gunting
    ├── kasbon.json       ← data kasbon per penjahit
    ├── settings.json     ← nama penjahit & pengaturan
    └── foto/             ← semua foto bukti
        ├── abc123.jpg
        ├── def456.png
        └── ...
```

---

## 💡 Tips Penggunaan

### Pembagian tugas yang disarankan:
| Komputer | Siapa | Tugas |
|----------|-------|-------|
| Mac kamu | Owner/Admin | Lihat ringkasan, export laporan, pengaturan |
| Windows PC 1 | Admin gudang | Input setor jahitan & guntingan |
| Windows PC 2 | Admin produksi | Input pengambilan jahitan |
| Windows PC lain | Staff | Input sesuai divisi |

### Backup otomatis:
Data di OneDrive sudah otomatis tersimpan di cloud.
OneDrive for Business juga punya **version history** — kalau data rusak bisa restore ke versi sebelumnya.

---

## ❓ Troubleshooting

**"OneDrive Business tidak ditemukan otomatis"**
→ Cari manual di File Explorer, biasanya:
`C:\Users\NamaKamu\OneDrive - NamaPerusahaan`

**"Data tidak sinkron ke komputer lain"**
→ Cek ikon OneDrive di taskbar, pastikan tidak ada error
→ Pastikan ada koneksi internet

**"Aplikasi tidak mau buka setelah restart"**
→ Cukup double-click shortcut `YHK Produksi` di Desktop lagi

**"Port 5000 sudah dipakai"**
→ Edit file `BUKA-YHK.bat`, ganti `5000` jadi `5001`
→ Buka browser ke http://localhost:5001

**Foto tidak muncul di komputer lain**
→ Tunggu sinkronisasi OneDrive selesai (lihat ikon di taskbar)
→ Foto berukuran besar butuh waktu lebih lama untuk sinkron

---

## 📞 Kalau ada masalah

Hubungi admin atau tanyakan ke AI assistant dengan
screenshot pesan error yang muncul.
