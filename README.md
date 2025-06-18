# 💈 Lookism Hairstudio Booking App

Aplikasi mobile untuk melakukan booking layanan potong rambut di Lookism Hairstudio secara **mudah, cepat, dan modern**, berbasis **Flutter** dan **Firebase**.

---

## 👤 Customer (Pelanggan)

| Fitur | Deskripsi |
|-------|-----------|
| 🔐 **Register & Login** | Autentikasi menggunakan email dan password |
| 📋 **Lihat Daftar Layanan** | Menampilkan semua layanan aktif (potong rambut, cukur jenggot, dsb) |
| 📅 **Booking Layanan** | Pilih layanan, tanggal, jam, dan barberman |
| 💬 **Berikan Review** | Setelah layanan selesai, customer bisa memberikan komentar & rating |
| 📜 **Lihat Riwayat Booking** | Menampilkan daftar pesanan yang sudah dilakukan |
| 🔓 **Logout** | Keluar dari akun pengguna |

---

## ✂️ Barberman

| Fitur | Deskripsi |
|-------|-----------|
| 🔐 **Login Barberman** | Akses khusus untuk barberman |
| 📆 **Lihat Jadwal Booking** | Daftar pelanggan yang sudah memesan berdasarkan tanggal dan jam |
| ✅ **Tandai Layanan Selesai** | Hanya bisa melayani 1 pelanggan per jam untuk menghindari konflik jadwal |

---

## 🛠️ Admin

| Fitur | Deskripsi |
|-------|-----------|
| 🔐 **Login Admin** | Akses khusus untuk pengelola studio |
| 🧾 **Kelola Data Layanan (CRUD)** | Tambah, ubah, hapus, aktif/nonaktifkan layanan |
| ⭐ **Lihat Review Customer** | Tampilkan semua ulasan dari pelanggan |

---

## 🧑‍💻 Teknologi yang Digunakan

- ⚙️ **Flutter** - Framework utama aplikasi
- 🔄 **GetX** - Routing dan State Management
- 🔥 **Firebase**
  - Firebase Auth (Autentikasi)
  - Firestore (Database)
  - Firebase Cloud Messaging (Notifikasi)
- 🎨 **Google Fonts** - Tampilan teks lebih menarik



