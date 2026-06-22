# Sesi 00 — Overview & Arsitektur

> ⏱️ Estimasi: 15 menit
> 🎯 Tujuan: Peserta paham **apa yang akan dibangun**, **kenapa pakai BLoC + Freezed + Clean Arch**, dan **alur data Flutter ↔ Backend**.

---

## 1. Apa Itu "NextElektronik"?

**NextElektronik** adalah aplikasi mobile e-commerce untuk single-store (UMKM elektronik). User bisa browse produk, masukkan ke keranjang, checkout, bayar, dan lacak pesanan — semua dari HP.

> ⚠️ **BUKAN MARKETPLACE** (Tokopedia/Shopee) — ini satu toko, owner pakai dashboard web (backend Next.js), customer pakai mobile app.

### Persona Aplikasi Flutter

| Role | Akses Mobile App |
|------|------------------|
| **Customer** | Browse, search, cart, checkout, bayar, tracking pesanan, kelola profil |
| **Admin** | TIDAK pakai mobile app — admin pakai dashboard web Next.js |

---

## 2. Fitur Utama yang Akan Dibangun

### Auth
- Splash screen (cek token)
- Onboarding (intro app)
- Login / Register
- Logout

### Browsing & Discovery
- Home dengan banner slider + kategori chip + featured products
- Product list (filter by kategori, search)
- Product detail (gambar, deskripsi, harga, stok)
- Search page (real-time)

### Shopping
- Cart (tambah, edit qty, hapus)
- Checkout multi-step (alamat → kurir → bayar)
- Payment via WebView (Xendit invoice)
- Order list + detail + tracking
- Repay order yang expired
- Cancel order

### Profile
- Edit profile (nama, phone)
- Change password
- Delete account
- Manage alamat (CRUD + pin map)
- Privacy policy & terms

---

## 3. Tech Stack — Kenapa?

| Tools | Versi | Alasan |
|-------|-------|--------|
| **Flutter** | 3.x | Cross-platform Android/iOS, hot reload, ekosistem matang |
| **Dart** | 3.x | Null safety, type-safe, modern syntax |
| **flutter_bloc** | ^9.0.0 | State management terstruktur, mudah ditest, separation logic vs UI |
| **freezed** | ^3.0.0 | Union types + immutable model, hilangkan boilerplate |
| **dartz** | ^0.10.1 | `Either<L, R>` untuk error handling explicit |
| **http** | ^1.3.0 | Simple HTTP client (alternatif dio, tapi cukup) |
| **shared_preferences** | ^2.5.1 | Persistent storage untuk token & user info |
| **google_fonts** | ^6.2.1 | Custom font (Quicksand) tanpa download manual |
| **cached_network_image** | ^3.4.1 | Image caching otomatis untuk produk |
| **carousel_slider** | ^5.0.0 | Banner slider di home |
| **shimmer** | ^3.0.0 | Skeleton loading effect |
| **intl** | ^0.20.2 | Format Rupiah & tanggal locale id_ID |
| **flutter_map** + **latlong2** | ^8.3.0 | OpenStreetMap untuk pin alamat (gratis, no API key) |
| **geolocator** | ^14.0.2 | Get current location user |
| **webview_flutter** | ^4.13.1 | Tampilkan Xendit invoice page in-app |
| **url_launcher** | ^6.3.1 | Buka link eksternal (privacy policy, dll) |

> 💡 **Tips Pengajar**: jelaskan satu per satu kenapa dipilih. Peserta sering tanya "kenapa bukan dio?" — jawab: http sudah cukup, dio overkill untuk skala ini.

---

## 4. Arsitektur — Clean Architecture + BLoC

```
┌──────────────────────────────────────────────────────┐
│              PRESENTATION LAYER                      │
│                                                      │
│   ┌───────────────┐      ┌────────────────────┐      │
│   │   Pages       │◀────▶│   BLoC (Freezed)   │      │
│   │   (Widget)    │      │   Event → State    │      │
│   └───────────────┘      └────────────────────┘      │
│         ▲                          │                 │
│         │ rebuild                  │ call            │
│         │ (BlocBuilder)            ▼                 │
└─────────┼──────────────────────────┼─────────────────┘
          │                          │
          │                          ▼
┌─────────┼──────────────────────────────────────────┐
│         │      DATA LAYER                          │
│         │                                          │
│         │      ┌──────────────────┐                │
│         └──────│ Remote Datasource│◀── HTTP ──┐    │
│                │ (Either<S, T>)   │           │    │
│                └──────────────────┘           │    │
│                                               │    │
│                ┌──────────────────┐           │    │
│                │ Local Datasource │           │    │
│                │ (SharedPrefs)    │           │    │
│                └──────────────────┘           │    │
│                                               │    │
│                ┌──────────────────┐           │    │
│                │ Models           │           │    │
│                │ (fromMap/toMap)  │           │    │
│                └──────────────────┘           │    │
└───────────────────────────────────────────────┼────┘
                                                │
                                                ▼
                          ┌─────────────────────────────────┐
                          │  Next.js Backend (REST API)     │
                          │  https://nextelektronik...      │
                          └─────────────────────────────────┘
```

### Aturan Layer

- **Presentation** TIDAK boleh import `http` langsung — selalu lewat datasource.
- **Datasource** mengembalikan `Either<String, T>` — JANGAN throw exception ke BLoC.
- **BLoC** memetakan Either ke State (success/error).
- **Page/Widget** rebuild via `BlocBuilder` atau side effect via `BlocListener`.

---

## 5. Alur Bisnis (User Journey)

### Alur Belanja Customer
```
Splash → cek token → Login (kalau belum) → MainPage (BottomNav)
                                            │
                                            ├── Home (banner, kategori, produk)
                                            │       │
                                            │       └─→ ProductDetail → Add to Cart
                                            │
                                            ├── Search → cari produk → Detail
                                            │
                                            ├── Cart → Checkout
                                            │           │
                                            │           ├─→ Pilih Alamat (map picker)
                                            │           ├─→ Pilih Kurir (Bitship rates)
                                            │           └─→ Bayar (WebView Xendit)
                                            │                  │
                                            │                  └─→ Payment Success
                                            │                         │
                                            │                         └─→ Order List
                                            │
                                            ├── Orders → tracking, cancel, repay
                                            │
                                            └── Profile → edit, password, alamat, logout
```

### Order Status (sinkron dengan backend)
```
PENDING_PAYMENT ──┬── PAID → PROCESSING → SHIPPING → DELIVERED ✓
                  │
                  ├── EXPIRED (24 jam) ──[repay]──> PENDING_PAYMENT
                  │
                  └── CANCELLED
```

---

## 6. Struktur Folder

```
flutter_onlinestore_app/
├── lib/
│   ├── main.dart                       # Entry: MultiBlocProvider + Theme + SplashPage
│   ├── core/
│   │   ├── constants/
│   │   │   ├── colors.dart             # AppColors (teal palette)
│   │   │   └── variables.dart          # Variables.baseUrl
│   │   ├── components/
│   │   │   ├── buttons.dart            # Button.filled / Button.outlined
│   │   │   ├── custom_text_field.dart
│   │   │   ├── search_input.dart
│   │   │   ├── spaces.dart             # SpaceHeight / SpaceWidth
│   │   │   └── step_indicator.dart     # Indicator step checkout
│   │   └── extensions/
│   │       ├── context_ext.dart        # context.push() / pop()
│   │       ├── currency_ext.dart       # 299000.currencyFormatRp
│   │       └── date_ext.dart           # date.toFormattedDate
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── api_helper.dart         # HTTP wrapper + logging
│   │   │   ├── auth_local_datasource.dart
│   │   │   ├── auth_remote_datasource.dart
│   │   │   ├── product_remote_datasource.dart
│   │   │   ├── category_remote_datasource.dart
│   │   │   ├── banner_remote_datasource.dart
│   │   │   ├── cart_remote_datasource.dart
│   │   │   ├── address_remote_datasource.dart
│   │   │   ├── shipping_remote_datasource.dart
│   │   │   └── order_remote_datasource.dart
│   │   └── models/
│   │       ├── request/                # Login, Register, Cart, Address, Order
│   │       └── response/               # Auth, Product, Category, Banner, Cart, Address, Shipping, Order
│   └── presentation/
│       ├── auth/                       # splash, onboarding, login, register
│       ├── home/                       # main_page, home_page, search_page
│       ├── product/                    # product_detail_page
│       ├── cart/                       # cart_page
│       ├── address/                    # list, form, map picker
│       ├── checkout/                   # checkout, shipping_method, payment, success
│       ├── order/                      # order_list, order_detail
│       └── profile/                    # profile, edit, password, delete, privacy, terms
├── android/
├── ios/
├── assets/
│   └── images/
│       └── logo.png
└── pubspec.yaml
```

---

## 7. Roadmap Kelas

| Sesi | Topik | Output Akhir |
|------|-------|--------------|
| 01 | Setup Project | Flutter running di emulator, dependency siap |
| 02 | Core Layer | Theme + AppColors + extension + reusable component |
| 03 | Data Layer | API Helper + Models + AuthLocalDatasource |
| 04 | Auth | Login working, token tersimpan, redirect ke MainPage |
| 05 | Home & Main | BottomNav 4 tab, banner slider, produk grid, search |
| 06 | Product Detail | Detail page + tombol Add to Cart |
| 07 | Cart | List item + qty controls + total |
| 08 | Address & Maps | CRUD alamat + map picker + region dropdown |
| 09 | Checkout | Pilih alamat + kurir + buat order |
| 10 | Payment & Orders | WebView Xendit + order list + tracking |
| 11 | Profile | Edit profile, password, delete account |
| 12 | Release | App icon, signing, build AAB, upload Play Store |

---

## 8. Demo Aplikasi Final (Tampilkan Sebelum Mulai!)

**WAJIB**: tunjukkan demo aplikasi yang sudah jadi sebelum mulai coding.

```bash
# Pengajar buka emulator/device, install APK final
- Splash + onboarding
- Login dengan test account
- Tour bottom nav (Home → Search → Orders → Profile)
- Add product to cart → checkout flow → payment WebView
- Tracking order
```

**Tujuan demo**: peserta lihat **finished product**, jadi tahu **kenapa belajar materi ini**.

---

## 9. Yang Perlu Disiapkan Peserta

Sebelum sesi pertama, pastikan peserta sudah:

- [ ] Install Flutter SDK 3.x (`flutter --version`)
- [ ] Run `flutter doctor` — semua centang hijau
- [ ] Install Android Studio + setup emulator (Pixel 6, API 33+)
- [ ] Atau pakai device fisik dengan USB debugging ON
- [ ] Install VS Code + extension: Dart, Flutter, Awesome Flutter Snippets
- [ ] Backend Next.js sudah running di local **ATAU** akses ke `https://nextelektronik.jagofullstack.com`
- [ ] Postman/Insomnia untuk eksplor API
- [ ] Buat akun customer di backend (untuk test login)

---

## 10. Konvensi yang Wajib Diikuti

Beberapa aturan project ini yang akan dipakai konsisten di semua sesi:

1. **Naming file**: `snake_case.dart` (e.g., `product_card_widget.dart`)
2. **Naming class**: `PascalCase` (e.g., `ProductCardWidget`)
3. **Naming method**: `camelCase` (e.g., `getProducts()`)
4. **Model**: pakai `fromMap()` / `toMap()` — BUKAN `fromJson()` untuk Map (kecuali full String JSON)
5. **State**: pakai Freezed union, BUKAN abstract class manual
6. **Datasource**: SELALU return `Either<String, T>`
7. **Format harga**: pakai extension `.currencyFormatRp` / `.toRupiah` — JANGAN hardcode NumberFormat
8. **Navigation**: pakai `context.push(Widget)` — BUKAN `Navigator.push` langsung
9. **Spacing**: pakai `SpaceHeight(16)` / `SpaceWidth(8)` — BUKAN `SizedBox(height: 16)` ad-hoc
10. **Color**: SELALU dari `AppColors.xxx` — JANGAN hardcode `Color(0xFF...)` di widget

---

## ➡️ Lanjut ke [Sesi 01 — Setup Project](./01-setup-project.md)
