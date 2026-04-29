# 🧵 Young Harmonis Konveksi — Sistem Produksi
Aplikasi manajemen produksi konveksi: setor jahitan, setor guntingan, pengambilan, kasbon, dan export laporan.

---

## 📦 Instalasi (Sekali saja)

### 1. Install Python
- Download Python 3.10+ dari https://python.org/downloads
- Saat install, centang **"Add Python to PATH"**

### 2. Ekstrak folder ini
Letakkan folder `yhk-app` di lokasi yang mudah, misalnya:
- Windows: `C:\Users\NamaKamu\yhk-app`
- Mac: `/Users/NamaKamu/yhk-app`

### 3. Install dependensi
Buka Terminal / Command Prompt, lalu ketik:

```bash
cd path/ke/yhk-app
pip install -r requirements.txt
```

---

## 🚀 Cara Menjalankan

### Windows
Double-click file `jalankan.bat`
ATAU buka Command Prompt dan ketik:
```
cd C:\Users\NamaKamu\yhk-app
python app.py
```

### Mac / Linux
Buka Terminal dan ketik:
```bash
cd /Users/NamaKamu/yhk-app
python3 app.py
```

### Buka di browser
Setelah muncul pesan "Buka browser: http://localhost:5000", 
buka browser (Chrome/Firefox/Safari) dan kunjungi:
**http://localhost:5000**

---

## 💾 Data Tersimpan Dimana?

Data disimpan di folder `data/` dalam bentuk file JSON:
- `transaksi.json` — semua transaksi produksi
- `kasbon.json` — data kasbon per penjahit  
- `settings.json` — pengaturan nama & daftar penjahit

> **Backup**: Copy folder `data/` secara berkala ke USB/Google Drive

---

## 📊 Import Kasbon dari Excel

Format Excel yang didukung:
- Setiap sheet = 1 nama penjahit (nama sheet harus mengandung nama penjahit)
- Kolom 1: Tanggal (format tanggal Excel)
- Kolom 2: Jumlah kasbon (angka)
- Kolom 3: Keterangan (teks, opsional)

---

## ⚙️ Fitur

| Fitur | Keterangan |
|---|---|
| Setor Jahitan | Catat hasil jahitan + hitung upah otomatis |
| Setor Guntingan | Catat hasil cutting per operator |
| Ambil Jahitan | Catat pengambilan bahan oleh penjahit |
| Kasbon | Input manual + import dari Excel |
| Ringkasan | Upah vs kasbon → saldo per penjahit |
| Export Excel | 4 sheet: jahitan, guntingan, ambil, ringkasan |
| Export PDF | Laporan lengkap siap cetak |
| Pengaturan | Kustom nama penjahit & nama konveksi |

---

## ❓ Masalah Umum

**"python tidak dikenali"**  
→ Reinstall Python dan centang "Add Python to PATH"

**"Port 5000 sudah dipakai"**  
→ Edit `app.py` baris terakhir, ganti `port=5000` ke `port=5001`

**Browser tidak bisa buka**  
→ Pastikan Python sedang jalan, coba http://127.0.0.1:5000

---

## 🔄 Update / Backup

Untuk backup data: copy folder `data/` ke tempat aman.
Untuk restore: paste kembali folder `data/` ke dalam `yhk-app/`.
