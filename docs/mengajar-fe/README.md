# Mengajar Frontend Flutter Onlinestore — Panduan Step by Step

> Dokumen ini dibuat untuk membantu mengajar di **JagoFlutter Academy (FIC Batch 25)** dengan tema **"Build E-Commerce Flutter App + Backend Next.js (NextElektronik)"**.
> Target akhir: peserta bisa membuat aplikasi Flutter e-commerce production-ready yang mengkonsumsi REST API Next.js — siap rilis ke Play Store.

> 📚 Companion dokumen backend: `next-ecommerce/docs/mengajar-backend/` — ajarkan backend dulu, baru frontend ini.

---

## Daftar Isi (Urutan Mengajar)

| # | Topik | File | Estimasi |
|---|-------|------|----------|
| 00 | Overview & Arsitektur | [00-overview.md](./00-overview.md) | 15 menit |
| 01 | Setup Project Flutter | [01-setup-project.md](./01-setup-project.md) | 30 menit |
| 02 | Core Layer (Theme, Component, Extension) | [02-core-design-system.md](./02-core-design-system.md) | 45 menit |
| 03 | Data Layer (Models, Datasource, API Helper) | [03-data-layer.md](./03-data-layer.md) | 60 menit |
| 04 | Authentication (Splash, Login, Register) | [04-auth.md](./04-auth.md) | 60 menit |
| 05 | Main Page & Home (BottomNav, Banner, Category, Product) | [05-home-main.md](./05-home-main.md) | 75 menit |
| 06 | Product Detail | [06-product-detail.md](./06-product-detail.md) | 45 menit |
| 07 | Shopping Cart | [07-cart.md](./07-cart.md) | 45 menit |
| 08 | Address + Maps Integration | [08-address-maps.md](./08-address-maps.md) | 75 menit |
| 09 | Checkout & Shipping | [09-checkout-shipping.md](./09-checkout-shipping.md) | 60 menit |
| 10 | Payment WebView & Orders | [10-payment-orders.md](./10-payment-orders.md) | 75 menit |
| 11 | Profile & Account Management | [11-profile.md](./11-profile.md) | 45 menit |
| 12 | Build & Release ke Play Store | [12-release.md](./12-release.md) | 45 menit |

**Total**: ~11-12 jam materi (bisa dipecah jadi 6-7 sesi @ 2 jam).

---

## Cara Pakai Dokumen Ini

1. **Untuk Pengajar**: ikuti urutan file. Tiap file punya:
   - **Tujuan** sesi (estimasi + outcome)
   - **Konsep** (slide-ready, jelaskan dulu sebelum coding)
   - **Live Coding** (step demi step yang harus diketik peserta)
   - **Checkpoint** (verifikasi UI/output di tiap milestone)
   - **Latihan** (peserta praktek mandiri / homework)
   - **Common Issues** (error yang sering muncul + solusi)

2. **Untuk Peserta**: clone repo final (`flutter_onlinestore_app`) sebagai referensi. Tapi **JANGAN copy-paste** — ketik ulang biar paham.

3. **Bantuan AI**: tiap docs bisa di-feed ke AI assistant (Claude, ChatGPT, Cursor) sebagai konteks. Format Markdown ini sengaja dibikin self-contained per sesi, jadi AI bisa pandu peserta step demi step tanpa kontaminasi sesi lain.

4. **Persiapan Sebelum Kelas**:
   - Flutter SDK 3.x terinstall (cek: `flutter --version`)
   - Dart SDK 3.x (built-in dengan Flutter)
   - Android Studio + emulator / device fisik
   - VS Code + extension: Dart, Flutter, Awesome Flutter Snippets
   - Backend Next.js sudah running (ikuti `mengajar-backend/` dulu) — atau pakai server demo `https://nextelektronik.jagofullstack.com`
   - Postman/Insomnia untuk eksplorasi API
   - Akun Play Console (opsional, untuk sesi 12)

---

## Filosofi Mengajar

- **Build > Theory**: 70% live coding, 30% konsep. Bikin peserta ngetik dan jalanin emulator.
- **Hot Reload Friendly**: tiap perubahan kecil → save → lihat hasilnya di emulator. Bikin feedback loop pendek.
- **Real World Stack**: pakai BLoC + Freezed + Clean Architecture (bukan setState pattern atau toy state management).
- **Pattern over Hack**: ajarkan satu cara saja (Bloc + Either + fromMap), konsisten di semua fitur.
- **Production Mindset**: dari awal pakai pattern yang akan dipakai di project produksi (extension method, freezed union, datasource pattern).

---

## Stack yang Akan Diajarkan

```
┌─────────────────────────────────────────┐
│  Flutter App (Mobile - Android/iOS)     │
│                                         │
│   ┌─────────────────────────────────┐   │
│   │  Presentation Layer             │   │
│   │  - Pages (StatefulWidget)       │   │
│   │  - Widgets (reusable)           │   │
│   │  - BLoC (flutter_bloc + Freezed)│   │
│   └─────────────────────────────────┘   │
│              │                          │
│              ▼                          │
│   ┌─────────────────────────────────┐   │
│   │  Data Layer                     │   │
│   │  - Datasources (Remote + Local) │   │
│   │  - Models (fromMap/toMap)       │   │
│   │  - Either<String, T> (dartz)    │   │
│   └─────────────────────────────────┘   │
│              │                          │
└──────────────┼──────────────────────────┘
               │ HTTP (REST API + JSON)
               ▼
┌─────────────────────────────────────────┐
│  Next.js Backend (NextElektronik)       │
│  - REST API /api/*                      │
│  - JWT Auth                             │
│  - Xendit Payment Gateway               │
│  - Bitship Shipping Aggregator          │
└─────────────────────────────────────────┘
```

---

## Tips Mengajar

- **Test Account Demo** (backend `nextelektronik.jagofullstack.com`):
  - Customer: `customer@nextelektronik.com` / `password123`
  - Admin: `admin@nextelektronik.com` / `password123`
  > 💡 Buatkan akun ini di backend sebelum kelas (lewat seed atau register manual).

- **Cara Tangani Pertanyaan "Kenapa Pakai X?"**:
  - **BLoC**: state management terstruktur, separation business logic vs UI, mudah ditest.
  - **Freezed**: union type + immutable model, hilangkan boilerplate `copyWith`/`==`/`hashCode`.
  - **dartz `Either<String, T>`**: explicit error handling, hindari try-catch berantai di UI.
  - **fromMap/toMap (manual)**: ringan, no codegen overhead, mudah debug. (Alternatif: json_serializable jika scale up.)
  - **Extension method**: idiomatic Dart, lebih readable (`299000.currencyFormatRp` vs `formatRupiah(299000)`).

- **Jika Peserta Stuck**:
  - Cek terminal output (error stack trace).
  - `flutter clean && flutter pub get` — fix dependency cache issue.
  - `dart run build_runner build --delete-conflicting-outputs` — untuk freezed generate.
  - Cek `Variables.baseUrl` — paling sering miss baseUrl atau port salah.
  - DevTools Network tab untuk debug HTTP call.
  - `ApiHelper` sudah log semua request/response di debug mode.

---

## Output Akhir Peserta

Setelah selesai semua sesi, peserta punya:

- [ ] Repo Flutter siap rilis (Android + iOS)
- [ ] 12+ BLoC + Freezed states untuk tiap fitur
- [ ] 8 datasource consume backend REST API
- [ ] Clean Architecture (core/data/presentation)
- [ ] Auth flow lengkap (splash → login → bottom nav)
- [ ] E-Commerce flow lengkap (browse → cart → checkout → payment → tracking)
- [ ] Payment WebView integration dengan Xendit
- [ ] Maps + Geolocator untuk pick alamat
- [ ] App icon, signing key, dan APK/AAB siap rilis Play Store

---

## ➡️ Mulai dari [Sesi 00 — Overview](./00-overview.md)
