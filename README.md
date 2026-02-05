# RidhoPlaylist

Aplikasi playlist lokal bertema Spotify yang memindai MP3 dari penyimpanan perangkat.

## Fitur
- Tema gelap ala Spotify dengan daftar playlist dan mini player.
- Pemindaian folder musik lokal untuk file MP3.
- Pemutar audio lokal (play/pause/seek) yang hanya aktif jika MP3 tersedia.
- Dukungan Android, iOS, dan Windows.

## Persiapan
1. Pastikan Flutter SDK terpasang dan `flutter doctor` bersih.
2. Jalankan `flutter pub get` di folder proyek.

## Build & Run
### Android
```bash
flutter run -d android
```
**Catatan izin:**
- `READ_EXTERNAL_STORAGE` untuk Android 12 ke bawah.
- `READ_MEDIA_AUDIO` untuk Android 13+.

### iOS
```bash
flutter run -d ios
```
**Catatan izin:**
- `UIFileSharingEnabled` dan `LSSupportsOpeningDocumentsInPlace` diaktifkan.
- Tambahkan akses folder dokumen melalui `NSDocumentsFolderUsageDescription`.

### Windows
```bash
flutter run -d windows
```
**Catatan izin:**
- Windows tidak memerlukan izin khusus untuk mengakses folder yang dipilih user.

## Cara Scan MP3
1. Buka tab **Songs**.
2. Tekan tombol **Scan MP3**.
3. Pilih folder musik yang berisi file `.mp3`.
4. Lagu akan tampil, lalu bisa diputar.
