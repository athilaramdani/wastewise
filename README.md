# WasteWise
Aplikasi **WasteWise** — Manajemen Sampah & Daur Ulang
**Gambaran Singkat**
Aplikasi **WasteWise** membantu pengguna dalam mengelola sampah rumah tangga maupun kantor agar lebih efisien dan ramah lingkungan. Aplikasi ini memungkinkan pengguna untuk mencatat jenis sampah, memantau jadwal pengumpulan, serta memperoleh informasi mengenai cara daur ulang. Tujuan akhirnya adalah mengurangi volume sampah yang dibuang dan meningkatkan tingkat daur ulang.

## Fitur Utama

1. **Splash Screen**: Menggunakan `flutter_native_splash`.
2. **Autentikasi**: Firebase Authentication (Email/Password) dan google login.
3. **Local Storage**: SharedPreferences untuk menyimpan sesi `isLoggedIn`.
4. **CRUD Data Sampah**: Menggunakan Cloud Firestore.
5. **API**: Gemini (untuk chatBotnya)
6. **State Management**: GetX.
7. **Tema**: Dark & Light mode bertema warna hijau. Font Poppins.

## Cara Install & Menjalankan

1. Clone repository:
   ```bash
   git clone https://github.com/yourname/wastewise.git
   ```

2. Masuk ke folder proyek:
   ```bash
   cd wastewise
   ```

3. Install dependency:
   ```bash
   flutter pub get
   ```

4. Setup Firebase:
    - Buat project di Firebase Console.
    - Download google-services.json dan GoogleService-Info.plist.
    - Letakkan di folder android/app/ dan ios/Runner/.
    - Update build.gradle dan AndroidManifest.xml sesuai instruksi.

5. Generate splash screen:
   ```bash
   flutter pub run flutter_native_splash:create
   ```

6. Jalankan app:
   ```bash
   flutter run
   ```

## Flow Aplikasi

- Splash Screen akan cek status login (dari SharedPreferences).
- Jika isLoggedIn = true, langsung ke Dashboard/Home.
- Jika belum login, user akan diarahkan ke halaman Login.
- Di halaman Login, user bisa memasukkan email & password, atau pindah ke Register.
- Setelah login sukses, user diarahkan ke Home.
- Di Home, user bisa menambahkan catatan sampah, melihat daftar, mengedit, atau menghapus.
- Data catatan sampah disimpan di Firestore di koleksi users/{uid}/wastes.

## Struktur Folder

Lihat di dokumentasi folder.

## Tambah / Update / Delete Catatan Sampah

- Tambah sampah: Tekan tombol + (icon di AppBar), isi form, klik simpan.
- Update sampah: Tekan list item, form edit muncul, update, simpan.
- Hapus sampah: Tekan icon delete pada list item.

## Screenshot (Contoh)

| Splash Screen | Login | Home |
|---------------|-------|------|
| | | |

> Belum ditambahkan

---

## Penutup
> blm