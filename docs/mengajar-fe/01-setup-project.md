# Sesi 01 — Setup Project Flutter

> ⏱️ Estimasi: 30 menit
> 🎯 Tujuan: Peserta punya project Flutter running di emulator dengan semua dependency siap dan struktur folder rapi.

---

## 1. Konsep Singkat (5 menit)

### Apa itu Flutter?
- Framework UI cross-platform dari Google (Dart bahasa, Skia renderer)
- Satu codebase → Android, iOS, Web, Desktop
- **Hot Reload** — perubahan UI langsung muncul di emulator (~1 detik)
- **Widget Tree** — semuanya widget (Scaffold, Text, Button, dll)

### Kenapa Flutter?
- Performa native (compile ke ARM)
- UI konsisten cross-platform
- Ekosistem besar (pub.dev)
- Cocok untuk MVP cepat sampai production scale

---

## 2. Cek Environment

```bash
flutter --version
flutter doctor -v
```

✅ **Checkpoint**: semua "[✓]" hijau. Kalau ada "[!]" atau "[✗]", fix dulu sebelum lanjut.

Common fix:
- Android licenses: `flutter doctor --android-licenses` → tekan `y` semua
- iOS (Mac saja): `sudo gem install cocoapods`

---

## 3. Buat Project Baru

```bash
# Bikin di folder development/<batch>/ atau bebas
flutter create flutter_onlinestore_app --org com.jagoflutter
cd flutter_onlinestore_app
```

> 💡 **Catatan**: `--org com.jagoflutter` → applicationId jadi `com.jagoflutter.flutter_onlinestore_app`. Nanti kita ubah ke `com.jagoflutter.nextelektronik` di sesi release.

### Jalankan Pertama Kali
```bash
flutter run
```

Pilih device (emulator atau fisik). Tunggu sampai counter app default muncul.

✅ **Checkpoint**: aplikasi default Flutter counter tampil dan tombol `+` berfungsi.

---

## 4. Install Dependencies

Edit `pubspec.yaml`, ganti bagian `dependencies` dan `dev_dependencies`:

```yaml
name: flutter_onlinestore_app
description: "Flutter Online Store App - E-Commerce"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8

  # State Management
  flutter_bloc: ^9.0.0
  freezed_annotation: ^3.0.0

  # Network & Data
  http: ^1.3.0
  dartz: ^0.10.1
  shared_preferences: ^2.5.1

  # UI
  google_fonts: ^6.2.1
  cached_network_image: ^3.4.1
  carousel_slider: ^5.0.0
  shimmer: ^3.0.0

  # Utils
  intl: ^0.20.2
  url_launcher: ^6.3.1

  # Maps & Location
  flutter_map: ^8.3.0
  latlong2: ^0.9.1
  geolocator: ^14.0.2

  # Payment WebView
  webview_flutter: ^4.13.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^6.0.0

  # Code Generation
  freezed: ^3.0.0
  build_runner: ^2.4.14

  # Testing
  bloc_test: ^10.0.0
  mocktail: ^1.0.4

  # Release tools
  flutter_launcher_icons: ^0.14.4
  change_app_package_name: ^1.5.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

Lalu install:

```bash
flutter pub get
```

✅ **Checkpoint**: terminal print "Got dependencies!" tanpa error. Cek `pubspec.lock` muncul.

> 💡 **Tips**: kalau ada conflict version, run `flutter pub upgrade --major-versions`.

---

## 5. Bersihkan Project Awal

### Hapus `lib/main.dart` default, ganti jadi minimal:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextElektronik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: Scaffold(
        body: Center(child: Text('NextElektronik 🛍️')),
      ),
    );
  }
}
```

Save → hot reload. Harus muncul text "NextElektronik 🛍️" di tengah layar.

✅ **Checkpoint**: text muncul, tidak ada error di terminal.

---

## 6. Buat Struktur Folder

```bash
# Dari root project
mkdir -p lib/core/constants
mkdir -p lib/core/components
mkdir -p lib/core/extensions

mkdir -p lib/data/datasources
mkdir -p lib/data/models/request
mkdir -p lib/data/models/response

mkdir -p lib/presentation/auth/bloc
mkdir -p lib/presentation/auth/pages

mkdir -p lib/presentation/home/bloc
mkdir -p lib/presentation/home/pages
mkdir -p lib/presentation/home/widgets

mkdir -p lib/presentation/product/bloc
mkdir -p lib/presentation/product/pages

mkdir -p lib/presentation/cart/bloc
mkdir -p lib/presentation/cart/pages

mkdir -p lib/presentation/address/bloc
mkdir -p lib/presentation/address/pages
mkdir -p lib/presentation/address/widgets

mkdir -p lib/presentation/checkout/bloc
mkdir -p lib/presentation/checkout/pages

mkdir -p lib/presentation/order/bloc
mkdir -p lib/presentation/order/pages

mkdir -p lib/presentation/profile/pages

mkdir -p assets/images
```

Struktur akhir `lib/`:
```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── components/
│   └── extensions/
├── data/
│   ├── datasources/
│   └── models/
│       ├── request/
│       └── response/
└── presentation/
    ├── auth/ (bloc + pages)
    ├── home/ (bloc + pages + widgets)
    ├── product/ (bloc + pages)
    ├── cart/ (bloc + pages)
    ├── address/ (bloc + pages + widgets)
    ├── checkout/ (bloc + pages)
    ├── order/ (bloc + pages)
    └── profile/ (pages)
```

---

## 7. Tambahkan Logo Asset

1. Siapkan file `logo.png` (transparent background, ukuran 1024×1024 PNG)
2. Taruh di `assets/images/logo.png`
3. Pastikan `pubspec.yaml` punya:
   ```yaml
   flutter:
     assets:
       - assets/images/
   ```
4. Run `flutter pub get` lagi

> 💡 Asset folder harus diakhiri `/` di pubspec, supaya semua file otomatis ke-include.

---

## 8. Test Pakai Salah Satu Package

Untuk pastikan dependency working, ganti `main.dart` sementara:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextElektronik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('NextElektronik')),
        body: const Center(
          child: Text(
            'Hello Quicksand! 🛍️',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
```

Hot reload → font berubah jadi Quicksand (custom font dari Google Fonts).

✅ **Checkpoint**: font Quicksand sukses ter-load, no error network di terminal.

---

## 9. Setup .gitignore

Pastikan `.gitignore` punya minimal:

```gitignore
# Flutter/Dart
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/

# IDE
.idea/
.vscode/
*.iml

# OS
.DS_Store

# Android
android/key.properties
android/app/upload-keystore.jks
**/android/**/gradle-wrapper.jar

# iOS
**/ios/**/Pods/

# Env (kalau pakai dotenv nanti)
.env
.env.*
```

---

## 10. First Commit

```bash
git init
git add .
git commit -m "feat: initial setup flutter onlinestore app + dependencies"
```

---

## ✅ Checklist Akhir Sesi 01

- [ ] `flutter doctor` semua centang hijau
- [ ] Project Flutter berhasil dibuat dengan org `com.jagoflutter`
- [ ] Semua dependency di `pubspec.yaml` terpasang
- [ ] App running di emulator (text "NextElektronik 🛍️" muncul)
- [ ] Struktur folder `lib/core`, `lib/data`, `lib/presentation` sudah dibuat
- [ ] Logo ada di `assets/images/logo.png`
- [ ] Test Google Fonts working (text pakai Quicksand)
- [ ] First commit Git

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| `Waiting for another flutter command to release the startup lock` | Process flutter sebelumnya nyangkut | `killall -9 dart` (Mac/Linux) atau restart terminal |
| `Gradle build failed` | Android SDK belum lengkap | Buka Android Studio → SDK Manager → install build tools terbaru |
| `pub get failed: version solving failed` | Conflict versi package | Cek constraint `environment.sdk`, atau `flutter pub upgrade` |
| `Connection refused` di emulator | Backend ga jalan / salah port | Pastikan backend running, dan baseUrl pakai `10.0.2.2` di emulator Android (bukan `localhost`) |
| Font tidak berubah | Internet putus saat google_fonts load | Cek koneksi, retry hot reload |
| Hot reload tidak jalan | Save di file yang ga di-include | Pastikan save di file Dart yang aktif (cek tab edit) |

---

## 📝 Latihan Mandiri

1. Coba ubah `seedColor` di `ColorScheme.fromSeed` → save → lihat perubahan
2. Tambahkan tombol `ElevatedButton` di body, tekan tombol → `print('Hello')` ke debug console
3. Eksplor `pub.dev` — cari package lucide_icons, baca dokumentasinya (untuk persiapan custom icon nanti)

---

## ➡️ Lanjut ke [Sesi 02 — Core Layer & Design System](./02-core-design-system.md)
