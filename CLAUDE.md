# Young Harmonis Production — Sistem Produksi

Aplikasi manajemen produksi konveksi untuk Young Harmoni. Single-file HTML + Firebase (no build step).

## Stack
- **Frontend**: Vanilla JS + CSS — satu file `index.html` (~2400 baris)
- **Database**: Firebase Firestore (db `yh-sistem-produksi`)
- **Auth**: Firebase Auth, terhubung ke portal Harmoni (`harmoni-indonesia`) via `authDb` (Firebase instance kedua)
- **Storage**: Firebase Storage (butuh Blaze plan) — foto dikompresi dulu via Canvas API sebelum upload
- **Hosting**: GitHub Pages (`adhiitmuh.github.io/yh-sistem-produksi`)

## Struktur Firebase Collections
- `transaksi` — setor jahitan (`type:"jahit"`), setor guntingan (`type:"gunting"`), ambil jahitan (`type:"ambil"`)
- `kasbon`, `pembayaran` — keuangan penjahit
- `qc` — hasil QC & finishing
- `keluar` — stok keluar / pengiriman
- `kain_masuk`, `kain_ambil` — manajemen kain
- `alih_tugas` — pindah bahan antar penjahit
- `config/settings` — daftar penjahit, operator cutting, item, kain, nama konveksi
- `config/stok` — stok barang jadi (`nama||ukuran` → qty)
- `config/stok_guntingan` — stok per operator cutting
- `config/stok_jahitan` — stok per penjahit (bahan dipegang)
- `config/stok_kain` — stok kain per jenis
- `config/modal_data` — data modal & harga jual per item

## Auth Flow
1. User login via portal Harmoni (Firebase instance `authDb`)
2. App baca `users/{uid}.apps.yhk.akses` dan `.role`
3. Role `owner` di portal → `admin` di app; role lain baca `apps.yhk.role`

## Pola Koding
- Semua operasi Firestore lewat helper: `fsGet`, `fsSet`, `fsAdd`, `fsDel`, `fsAll`, `fsQuery`
- Konfirmasi dialog: gunakan `confirm2(msg)` yang returns `Promise<boolean>` — JANGAN pakai `new Promise(r=>showConfirm(...,r))` tanpa set `cfmRejectCallback`
- Foto: selalu lewat `uploadFotos(files)` — sudah handle non-blocking dan kompresi otomatis
- Item blocks (jahit/gunting/ambil/keluar): class harus `.iblock`, ada input `.ibn` (nama), `.ibu` (upah), `.ibl` (lembar), ukuran via `.ukin`
- Penjahit vs Operator: `settings.penjahit[]` → select `j-pjt/a-pjt/kb-pjt/by-pjt/qc-pjt/at-dari/at-ke`; `settings.operator[]` → select `g-op/ka-op`
- Item master punya dua upah: `upah` (jahit) dan `upah_gunting` (cutting) — `acShow` otomatis pilih yang tepat berdasarkan `bid[0]==="g"`
- Render tags: `renderPjtTags()` untuk penjahit, `renderOpTags()` untuk operator — keduanya dipanggil setelah `loadSettings` dan `saveSettings`

## Bug History (sudah diperbaiki)
- `uploadFotos` blocking → sekarang non-blocking + kompresi Canvas
- `submitKeluar` baca `i.qty` padahal colK kirim `i.pcs` → stok tidak terkurangi → sudah fix
- `addGuntingFromKain` buat `.blk` bukan `.iblock` → item tidak tersimpan → sudah fix
- `addQCRow` div id `qcr-i` konflik dengan input reject → reject selalu 0 → sudah fix
- `addQCRow()` tanpa argumen → "undefined – undefined" → sekarang tampil form input

## Deploy
Push ke `main` → otomatis live di GitHub Pages (biasanya 1-2 menit).
