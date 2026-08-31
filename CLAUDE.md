# Young Harmonis Production — Sistem Produksi

Aplikasi manajemen produksi konveksi untuk Young Harmoni. Single-file HTML + Firebase (no build step).

## Stack
- **Frontend**: Vanilla JS + CSS — satu file `index.html` (~2600+ baris)
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
- `fsAdd` otomatis stamp `createdAt` (server timestamp), `createdBy` (uid), `createdByNama` (nama user) — untuk audit trail
- Konfirmasi dialog: gunakan `confirm2(msg)` yang returns `Promise<boolean>` — JANGAN pakai `new Promise(r=>showConfirm(...,r))` tanpa set `cfmRejectCallback`
- Foto: selalu lewat `uploadFotos(files)` — sudah handle non-blocking dan kompresi otomatis. Photo bucket: `fF.j / g / a / qc / ke / by` (init di line ~896)
- Item blocks (jahit/gunting/ambil/keluar): class harus `.iblock`, ada input `.ibn` (nama), `.ibu` (upah), `.ibl` (lembar), ukuran via `.ukin`
- Penjahit vs Operator: `settings.penjahit[]` → select `j-pjt/a-pjt/kb-pjt/by-pjt/qc-pjt/at-dari/at-ke`; `settings.operator[]` → select `g-op/ka-op`
- Item master punya dua upah: `upah` (jahit) dan `upah_gunting` (cutting) — `acShow` otomatis pilih yang tepat berdasarkan `bid[0]==="g"`
- Render tags: `renderPjtTags()` untuk penjahit, `renderOpTags()` untuk operator — keduanya dipanggil setelah `loadSettings` dan `saveSettings`
- `mkDelBtn(col, docId, cbName)` — `cbName` adalah STRING nama fungsi global (bukan function reference) supaya inline handler aman. Contoh: `mkDelBtn("pembayaran", d._id, "loadRingkasan")`
- Field keterangan: `transaksi` pakai `keterangan`, sisanya (`kasbon`/`pembayaran`/`qc`/`keluar`/dst) pakai `ket`. JANGAN tertukar

## Bug History (sudah diperbaiki)
- `uploadFotos` blocking → sekarang non-blocking + kompresi Canvas
- `submitKeluar` baca `i.qty` padahal colK kirim `i.pcs` → stok tidak terkurangi → sudah fix
- `addGuntingFromKain` buat `.blk` bukan `.iblock` → item tidak tersimpan → sudah fix
- `addQCRow` div id `qcr-i` konflik dengan input reject → reject selalu 0 → sudah fix
- `addQCRow()` tanpa argumen → "undefined – undefined" → sekarang tampil form input
- `submitGunting` tidak simpan `totalUpah` & `colG` tidak isi `subtotal` → upah operator cutting selalu Rp 0 di Ringkasan → sudah fix + tombol Backfill di Pengaturan untuk data lama
- `fsAdd` tidak stamp `createdBy`/`createdByNama` (regressed dari 444c0fe) → panel Menunggu Verifikasi tampil "Diinput oleh: —" → sudah fix
- Hapus pembayaran/kasbon tidak trigger `loadRingkasan` → saldo stale → sudah fix (cb `"loadRingkasan"` di `mkDelBtn`)
- `mkDelBtn` cb pakai `Function.toString()` (inject seluruh body ke onclick) → fragile → refactor jadi string nama fungsi
- `delTx` cuma reload `loadStats`, tidak `loadRingkasan` → saldo stale setelah hapus dari Riwayat → sudah fix
- `showRingDetail` baca `d.keterangan` untuk kasbon/pembayaran (harusnya `d.ket`) → keterangan tidak tampil di modal detail → sudah fix

## Fitur Ringkasan & Profil (modal detail)
- Card di Ringkasan clickable → `showRingDetail(name)` buka modal `#ring-det-modal` dengan 4 stat + 3 list: transaksi (`rdet-tx`), kasbon (`rdet-kb`), pembayaran (`rdet-by`)
- `ringData` (map by name) — struktur: `{name, upah, kasbon, bayar, type, txList, kbList, byList}` di-cache dari `loadRingkasan`
- Setiap entri transaksi di modal punya tombol Edit (mini-modal `#etx-mo`, hanya tanggal + keterangan) & Hapus (`delTxFromRing`)
- Edit ringan (`editTxLite`) juga tersedia di halaman Riwayat (`loadRiwayat`) untuk hunt-and-fix pakai filter
- Formula saldo di Ringkasan: `saldo = upah - kasbon_netto - bayar_verified`
  - `upah` = sum(`transaksi.totalUpah`) semua entri
  - `kasbon_netto` = sum(`kasbon.jumlah`) − sum(`pembayaran.potong_kasbon`) dari entri VERIFIED
  - `bayar_verified` = sum(`pembayaran.jumlah` + `pembayaran.potong_kasbon`) dari entri VERIFIED
  - Pending pembayaran (`status==="pending"`) TIDAK dihitung — saldo baru berkurang saat admin verifikasi

## Fitur Potong Kasbon
- Form Pembayaran (`s-bayar`) punya field `by-pk` (Potong Kasbon) selain `by-jml` (Jumlah TF)
- Disimpan sebagai `pembayaran.potong_kasbon` (default 0)
- `showKasbonInfo()` tampilkan sisa kasbon aktif saat pilih penjahit
- `by-jml` dan `by-pk` pakai `text` + `inputmode="numeric"` dengan `fmtRpIn`/`parseRpIn` (auto thousand separator)

## Fitur Pending → Verifikasi Pembayaran
- Staff bisa catat pembayaran → status `pending`, WAJIB upload bukti TF (`fF.by`) kalau `jml>0`
- Admin catat pembayaran → langsung `verified`, dengan `verifiedBy` + `verifiedAt`
- Panel "⏳ Menunggu Verifikasi" (`#by-verifikasi-wrap`) muncul di atas history — admin lihat tombol Verifikasi/Tolak, staff lihat status baca-saja
- `verifikasiBayar(id)` — update doc `{status:"verified", verifiedBy, verifiedAt}` + reload Ringkasan
- `tolakBayar(id)` — hapus doc (aksi tidak reversible)
- `loadRingkasan` **skip** entri `status==="pending"` — saldo baru berkurang saat admin verifikasi
- Modal detail Ringkasan tampilkan badge `PENDING` (warna gold) untuk entri belum verified
- Backward compat: entri lama tanpa `status` field diperlakukan sebagai `verified`

## Role Permissions
- `STAFF_DEL_ALLOW = ["transaksi"]` — staff hanya boleh hapus setoran (jahit/gunting/ambil), tidak boleh hapus `pembayaran`/`kasbon`/`qc`/`keluar`/`alih_tugas`/`kain_masuk`/`kain_ambil`
- Staff boleh edit ringan transaksi (tanggal + keterangan) via modal Ringkasan atau halaman Riwayat
- Staff boleh catat pembayaran (auto `pending`), tapi TIDAK boleh verifikasi/tolak
- Tombol Backfill Upah Gunting hanya untuk admin (via `applyRole` toggle `#backfill-card`)

## Deploy
Push ke `main` → otomatis live di GitHub Pages (biasanya 1-2 menit).
