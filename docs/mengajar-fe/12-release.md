# Sesi 12 — Build & Release ke Play Store

> ⏱️ Estimasi: 45 menit
> 🎯 Tujuan: Peserta paham langkah lengkap dari "code di laptop" sampai "live di Play Store" — ganti app id, app icon, generate signing key, sign release build, upload AAB.

> 📌 **Note**: Sebagian besar langkah hanya perlu dilakukan SEKALI (keystore, signing config). Build berikutnya tinggal jalankan script.

---

## 1. Konsep (5 menit)

### APK vs AAB
- **APK**: file install Android lama, satu file fit-all device
- **AAB** (Android App Bundle): format baru Google, Play Store auto-generate APK terkecil per device. **WAJIB** untuk upload ke Play Store sekarang.

### Signing Key
Tiap app di Play Store harus di-**sign** dengan keystore yang sama selamanya. Kalau hilang → tidak bisa update app, harus rilis app id baru.

> ⚠️ **HATI-HATI**: Simpan keystore JKS + password di tempat aman (1Password / Google Drive private). HILANG = APP MATI.

### Obfuscation
`--obfuscate` mengganti nama class/method di Dart jadi short random string. Susah di-reverse engineer.

---

## 2. Setup App Icon (Launcher Icon)

Sudah install `flutter_launcher_icons` di pubspec. Edit `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/logo.png"
  min_sdk_android: 21
  web:
    generate: true
    image_path: "assets/images/logo.png"
    background_color: "#FFFFFF"
    theme_color: "#1F6F5F"
```

Generate:
```bash
dart run flutter_launcher_icons
```

✅ **Checkpoint**: cek `android/app/src/main/res/mipmap-*/launcher_icon.png` muncul.

---

## 3. Ganti App ID & Nama App

### A. Ganti applicationId
Edit `android/app/build.gradle.kts`:
```kotlin
defaultConfig {
    applicationId = "com.jagoflutter.nextelektronik"   // <-- ubah ini
    ...
}
```

Update juga `namespace`:
```kotlin
android {
    namespace = "com.jagoflutter.nextelektronik"
    ...
}
```

> 💡 **Alternative**: pakai package `change_app_package_name`:
> ```bash
> dart run change_app_package_name:main com.jagoflutter.nextelektronik
> ```
> Otomatis ubah semua reference.

### B. Ganti label di AndroidManifest.xml
```xml
<application
    android:label="NextElektronik"
    android:icon="@mipmap/launcher_icon"
    ...>
```

### C. Update version di `pubspec.yaml`
```yaml
version: 1.0.0+1
# Format: <versionName>+<versionCode>
# Setiap rilis: increment versionCode (1, 2, 3, ...)
```

---

## 4. Generate Signing Key (Keystore)

Dari root project:

```bash
keytool -genkey -v \
  -keystore android/app/nextelektronik-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias nextelektronik
```

Akan ditanya:

| Pertanyaan | Contoh Jawaban |
|---|---|
| Enter keystore password | `nextelektronik2026` |
| Re-enter new password | `nextelektronik2026` |
| What is your first and last name? | `Bahri` |
| What is the name of your organizational unit? | `Development` |
| What is the name of your organization? | `Jago Flutter Academy` |
| What is the name of your City? | `Sleman` |
| What is the name of your State? | `Yogyakarta` |
| Two-letter country code | `ID` |
| Is CN=... correct? | `yes` |
| Enter key password for <nextelektronik> | (Enter — sama dengan store password) |

✅ **Checkpoint**: file `android/app/nextelektronik-release.jks` muncul.

> 🔐 **Backup keystore**: copy file `.jks` + tulis password di password manager. HILANG = tidak bisa update Play Store.

---

## 5. Buat `key.properties`

Buat `android/key.properties`:
```properties
storePassword=nextelektronik2026
keyPassword=nextelektronik2026
keyAlias=nextelektronik
storeFile=nextelektronik-release.jks
```

⚠️ JANGAN commit file ini ke git!

### Update `.gitignore`
Tambahkan:
```gitignore
# Release keystore
android/app/*.jks
android/key.properties
```

---

## 6. ProGuard Rules

Buat `android/app/proguard-rules.pro`:

```pro
# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# HTTP / OkHttp
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# WebView (untuk payment)
-keep class androidx.webkit.** { *; }

# Play Core (deferred components)
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# JSON / Reflection
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
```

---

## 7. Update `android/app/build.gradle.kts`

```kotlin
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load signing key dari key.properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.jagoflutter.nextelektronik"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.jagoflutter.nextelektronik"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
```

**Perubahan dari default:**
1. Import `Properties` & `FileInputStream`
2. Block `keystoreProperties` load `key.properties`
3. `signingConfigs.create("release")` baca dari properties
4. `buildTypes.release` pakai `release` signing + minify + shrink + proguard

---

## 8. Buat Release Script

Buat `release_appbundle.sh` di root project:

```bash
#!/bin/bash
set -e

echo "=========================================="
echo "  NextElektronik - Release App Bundle"
echo "=========================================="

echo ""
echo "[1/4] Membersihkan build lama..."
flutter clean

echo ""
echo "[2/4] Install dependency..."
flutter pub get

echo ""
echo "[3/4] Generate freezed files..."
dart run build_runner build --delete-conflicting-outputs || true

echo ""
echo "[4/4] Build App Bundle (release + obfuscated)..."
flutter build appbundle --release \
    --obfuscate \
    --split-debug-info=build/debug-info

echo ""
echo "=========================================="
echo "  BUILD SELESAI!"
echo "=========================================="
echo ""
echo "  File AAB:"
echo "    build/app/outputs/bundle/release/app-release.aab"
echo ""
echo "  Debug symbols (untuk Crashlytics):"
echo "    build/debug-info/"
echo ""
```

Beri permission:
```bash
chmod +x release_appbundle.sh
```

---

## 9. Test Build Lokal Dulu

### Test APK release (untuk install manual di device)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

Install ke device:
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

Coba pakai app — kalau crash, perbaiki sebelum build AAB.

### Build AAB
```bash
./release_appbundle.sh
```

Output: `build/app/outputs/bundle/release/app-release.aab`

✅ **Checkpoint**: file AAB muncul, ukuran wajar (10-50MB).

---

## 10. Upload ke Play Console

### Persiapan Akun Play Console
1. Daftar di https://play.google.com/console (one-time fee $25)
2. Verifikasi identitas (biasanya butuh 1-2 hari)

### Buat App
1. Play Console → "Create app"
2. Isi:
   - App name: NextElektronik
   - Default language: Indonesian
   - App or game: App
   - Free or paid: Free
   - Centang declarations (kebijakan developer)

### Setup Required
Sebelum upload, lengkapi (di sidebar "Set up your app"):
- App access
- Ads (declare punya/tidak)
- Content rating questionnaire
- Target audience
- News app declaration
- COVID-19 contact tracing (No)
- Data safety
- Government apps
- Financial features

### Upload AAB
1. **Production** → "Create new release"
2. Pilih "Let Google manage and protect your app signing key" → Continue
3. Upload `app-release.aab`
4. Tulis **Release notes** (ada di template, bisa edit per bahasa):
   ```
   Versi 1.0.0
   - Rilis pertama NextElektronik
   - Browse produk, cart, checkout, payment Xendit
   - Tracking pesanan + maps integration
   ```
5. Save → Review release → Submit
6. Tunggu Google review (1-7 hari pertama kali, 1-24 jam update berikutnya)

### Internal Testing Track (Cepat)
Sebelum production, test dulu via Internal Testing:
1. **Internal testing** → Create new release
2. Upload AAB sama
3. Tab "Testers" → buat email list (tester) atau pakai Google Group
4. Share link "Internal testing" ke tester
5. Tester install via Play Store internal link

---

## 11. Update Build Berikutnya

Saat ada perubahan dan ingin rilis update:

1. **Update version** di `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2   # 1.0.1 = versionName, 2 = versionCode (WAJIB increment)
   ```
2. Run release script:
   ```bash
   ./release_appbundle.sh
   ```
3. Upload AAB baru ke Play Console (production / internal testing)
4. Tulis release notes
5. Submit

> ⚠️ **versionCode** harus selalu lebih besar dari sebelumnya. Kalau pakai `1`, next build harus `2`, `3`, dst.

---

## 12. iOS Release (Bonus)

> Butuh Apple Developer Account ($99/tahun + MacBook).

Singkat:
```bash
flutter build ipa --release
```

Upload via Transporter / Xcode Organizer ke App Store Connect. Sertifikasi lebih ketat (UI guidelines, privacy declaration), butuh `Info.plist` permission lengkap.

---

## ✅ Checklist Akhir Sesi 12

- [ ] App icon generated (`flutter_launcher_icons`)
- [ ] applicationId `com.jagoflutter.nextelektronik`
- [ ] App label "NextElektronik"
- [ ] Keystore `nextelektronik-release.jks` generated
- [ ] `key.properties` configured (tidak di-commit)
- [ ] `.gitignore` exclude `.jks` & `key.properties`
- [ ] `proguard-rules.pro` ada
- [ ] `build.gradle.kts` updated dengan signing release
- [ ] `release_appbundle.sh` jalan tanpa error
- [ ] AAB file muncul di `build/app/outputs/bundle/release/`
- [ ] (Opsional) Upload ke Play Console internal testing
- [ ] (Opsional) Update version untuk release berikutnya

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| `keystore was tampered with, or password was incorrect` | Password salah di `key.properties` | Cek password sama dengan saat generate JKS |
| `No key with alias 'xxx' found in keystore` | Alias salah | Cek `keyAlias` di key.properties sama dengan `-alias` saat keytool |
| `Execution failed for task ':app:minifyReleaseWithR8'` | Proguard strip class | Tambah `-keep` rule untuk class/plugin di proguard-rules |
| App crash di release tapi tidak di debug | Proguard agresif | Add `-keep` rules untuk semua plugin (lihat logcat) |
| `App not installed` di device | Sudah ada versi debug terinstall | Uninstall debug version dulu |
| Play Console reject "32-bit only" | Build hanya ARM, butuh 64-bit | Pastikan default split (Flutter sudah include 32+64-bit) |
| Upload AAB error "invalid signature" | Keystore beda dengan rilis sebelumnya | WAJIB pakai keystore yang sama selamanya |

---

## 📝 Latihan Mandiri

1. Setup **Firebase Crashlytics** untuk lacak crash di production (upload `app.android-arm.symbols`)
2. Setup **Internal Testing track** + invite 3 tester
3. Setup **GitHub Actions** untuk auto-build AAB on push tag (gitops)
4. Bikin **app screenshots** untuk Play Store listing (1080×1920, min 2 max 8 per device type)
5. Bikin **Privacy Policy** halaman publik (host di GitHub Pages atau Google Sites) — wajib URL public untuk Play Store

---

## 🎉 Selesai!

Selamat! Peserta sekarang punya:
- ✅ Repo Flutter complete dengan Clean Architecture + BLoC + Freezed
- ✅ 8 datasource consume backend REST API
- ✅ 12+ BLoC dengan freezed union state
- ✅ E-Commerce flow lengkap (browse → cart → checkout → payment → tracking)
- ✅ Maps + Geolocator + WebView integration
- ✅ APK/AAB siap rilis Play Store
- ✅ Pengalaman ngerjain end-to-end dari nol sampai produksi

---

## 📚 Resources Lanjutan

- **flutter_bloc**: https://bloclibrary.dev
- **Freezed**: https://pub.dev/packages/freezed
- **Flutter Layout Cheat Sheet**: https://docs.flutter.dev/ui/widgets/layout
- **OpenStreetMap Tile Usage Policy**: https://operations.osmfoundation.org/policies/tiles/
- **Xendit Test Mode**: https://docs.xendit.co/test-mode
- **Play Console Help**: https://support.google.com/googleplay/android-developer
- **Material Design**: https://m3.material.io

---

## ➡️ Kembali ke [README — Daftar Isi](./README.md)
