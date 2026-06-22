# Sesi 02 — Core Layer & Design System

> ⏱️ Estimasi: 45 menit
> 🎯 Tujuan: Peserta paham kenapa kita pisah `core/`, bisa bikin theme + reusable component + extension yang dipakai di semua fitur.

---

## 1. Konsep (5 menit)

### Kenapa Ada `core/`?
Folder `core/` berisi **kode yang dipakai lintas fitur** — tidak terikat ke fitur tertentu (auth, product, cart, dll).

- `constants/` — nilai konstan (warna, base URL, asset path)
- `components/` — widget reusable (Button, TextField, Spaces)
- `extensions/` — Dart extension method untuk ekstend tipe built-in

### Kenapa Extension Method?
Idiomatic Dart. Bikin kode lebih readable.

```dart
// BAD (procedural)
Text(formatRupiah(299000))
Text(formatDate('2026-04-27T08:30:00Z'))

// GOOD (extension)
Text(299000.currencyFormatRp)
Text('2026-04-27T08:30:00Z'.toFormattedDate)
```

### Kenapa Reusable Component?
- Konsistensi UI (1 button style di semua page)
- Sekali ubah → semua page ikut berubah
- Bikin page code lebih singkat & focused ke business logic

---

## 2. AppColors (Constant Warna)

Buat `lib/core/constants/colors.dart`:

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (teal palette)
  static const Color primary = Color(0xFF1F6F5F);
  static const Color primaryDark = Color(0xFF185A4D);
  static const Color secondary = Color(0xFF2FA084);
  static const Color tertiary = Color(0xFF6FCF97);
  static const Color background = Color(0xFFEEEEEE);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF616161);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color slate50 = Color(0xFFF8FAFC);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Order Status Colors
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusPaid = Color(0xFF3B82F6);
  static const Color statusShipping = Color(0xFF6366F1);
  static const Color statusDelivered = Color(0xFF22C55E);
  static const Color statusExpired = Color(0xFFF97316);
  static const Color statusCancelled = Color(0xFFEF4444);

  // Gradient (header)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1F6F5F), Color(0xFF2FA084)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
```

> 💡 **ATURAN**: JANGAN hardcode `Color(0xFF...)` di widget. SELALU pakai `AppColors.xxx`.

---

## 3. Variables (Base URL)

Buat `lib/core/constants/variables.dart`:

```dart
class Variables {
  // Production
  static const String baseUrl = 'https://nextelektronik.jagofullstack.com';

  // Untuk development lokal, comment yang atas dan uncomment salah satu:
  // static const String baseUrl = 'http://10.0.2.2:3000';        // Android emulator
  // static const String baseUrl = 'http://localhost:3000';       // iOS simulator
  // static const String baseUrl = 'http://192.168.x.x:3000';     // Device fisik di LAN
}
```

> 💡 **Penjelasan**: `10.0.2.2` adalah IP khusus emulator Android untuk akses `localhost` host machine.

---

## 4. Extension: Currency Format

Buat `lib/core/extensions/currency_ext.dart`:

```dart
import 'package:intl/intl.dart';

extension CurrencyExt on num {
  /// 299000 → "Rp 299.000"
  String get currencyFormatRp {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(this);
  }

  /// 299000 → "299.000" (tanpa simbol)
  String get currencyFormat {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(this);
  }
}

extension StringCurrencyExt on String {
  /// "299000.00" (dari API) → "Rp 299.000"
  String get toRupiah {
    final value = double.tryParse(this) ?? 0;
    return value.currencyFormatRp;
  }

  /// "299000.00" → 299000.0
  double get toPrice {
    return double.tryParse(this) ?? 0;
  }
}
```

### Penggunaan:
```dart
Text(299000.currencyFormatRp)        // "Rp 299.000"
Text(product.price!.toRupiah)        // dari API string decimal
double harga = "299000.00".toPrice;  // 299000.0
```

---

## 5. Extension: Date Format

Buat `lib/core/extensions/date_ext.dart`:

```dart
import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  /// "27 Apr 2026, 15:30 WIB"
  String get toFormattedDate {
    return '${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(toLocal())} WIB';
  }

  /// "27 Apr 2026"
  String get toFormattedDateOnly {
    return DateFormat('dd MMM yyyy', 'id_ID').format(toLocal());
  }

  /// "15:30"
  String get toFormattedTime {
    return DateFormat('HH:mm', 'id_ID').format(toLocal());
  }

  /// "Baru saja" / "5 menit lalu" / "2 jam lalu" / "Kemarin"
  String get toRelativeTime {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return toFormattedDateOnly;
  }
}

extension StringDateExt on String {
  DateTime get toDateTime => DateTime.parse(this);
  String get toFormattedDate => DateTime.parse(this).toFormattedDate;
}
```

> ⚠️ **Penting**: locale `id_ID` butuh inisialisasi. Tambahkan ini di `main()`:
> ```dart
> import 'package:intl/date_symbol_data_local.dart';
> 
> void main() async {
>   WidgetsFlutterBinding.ensureInitialized();
>   await initializeDateFormatting('id_ID', null);
>   runApp(const MyApp());
> }
> ```

---

## 6. Extension: Navigation (Context)

Buat `lib/core/extensions/context_ext.dart`:

```dart
import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  void push(Widget page) {
    Navigator.push(this, MaterialPageRoute(builder: (_) => page));
  }

  void pushReplacement(Widget page) {
    Navigator.pushReplacement(this, MaterialPageRoute(builder: (_) => page));
  }

  void pushAndRemoveUntil(Widget page) {
    Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void pop() => Navigator.pop(this);
}
```

### Penggunaan:
```dart
// Push ke halaman baru
context.push(const ProductDetailPage());

// Replace (ga bisa back)
context.pushReplacement(const LoginPage());

// Clear semua stack (after login)
context.pushAndRemoveUntil(const MainPage());

// Pop
context.pop();
```

---

## 7. Component: Spaces

Buat `lib/core/components/spaces.dart`:

```dart
import 'package:flutter/material.dart';

class SpaceHeight extends StatelessWidget {
  final double height;
  const SpaceHeight(this.height, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class SpaceWidth extends StatelessWidget {
  final double width;
  const SpaceWidth(this.width, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
```

### Penggunaan:
```dart
Column(children: [
  Text('Hello'),
  const SpaceHeight(16),
  Text('World'),
])

Row(children: [
  Icon(Icons.star),
  const SpaceWidth(8),
  Text('4.5'),
])
```

> 💡 **Filosofi**: 1 char lebih singkat dari `SizedBox(height: 16)`, dan const constructor friendly.

---

## 8. Component: Button

Buat `lib/core/components/buttons.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_onlinestore_app/core/constants/colors.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool _isFilled;
  final double? width;
  final double height;
  final double fontSize;
  final Color? color;
  final bool disabled;

  const Button.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.width,
    this.height = 48,
    this.fontSize = 16,
    this.color,
    this.disabled = false,
  }) : _isFilled = true;

  const Button.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.width,
    this.height = 48,
    this.fontSize = 16,
    this.color,
    this.disabled = false,
  }) : _isFilled = false;

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppColors.primary;

    if (_isFilled) {
      return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: disabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: btnColor,
          side: BorderSide(color: btnColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Penggunaan:
```dart
Button.filled(
  onPressed: () => print('Tap!'),
  label: 'Login',
  icon: Icons.login,
)

Button.outlined(
  onPressed: () {},
  label: 'Daftar',
)

Button.filled(
  onPressed: null,
  label: 'Stok Habis',
  disabled: true,
)
```

> 💡 **Pattern**: pakai **named constructor** (`.filled`, `.outlined`) untuk variant. Lebih intuitif dari `Button(type: 'filled')`.

---

## 9. Component: CustomTextField

Buat `lib/core/components/custom_text_field.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_onlinestore_app/core/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText ?? label,
            hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 10. Component: SearchInput

Buat `lib/core/components/search_input.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_onlinestore_app/core/constants/colors.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const SearchInput({
    super.key,
    required this.controller,
    this.hintText = 'Cari produk...',
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: AppColors.grey),
        filled: true,
        fillColor: AppColors.lightGrey,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
```

---

## 11. Setup Theme di `main.dart`

Update `lib/main.dart` (pakai sementara, nanti di sesi 04 ditambah MultiBlocProvider):

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/custom_text_field.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/extensions/currency_ext.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        scaffoldBackgroundColor: AppColors.white,
        textTheme: GoogleFonts.quicksandTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
      home: const DemoPage(),
    );
  }
}

// Halaman demo untuk uji coba core component
class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Core Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(controller: emailCtrl, label: 'Email'),
            const SpaceHeight(16),
            Button.filled(onPressed: () {}, label: 'Login'),
            const SpaceHeight(12),
            Button.outlined(onPressed: () {}, label: 'Daftar'),
            const SpaceHeight(24),
            Text(
              'Harga: ${299000.currencyFormatRp}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
```

Hot reload → lihat semua component tampil.

✅ **Checkpoint**:
- AppBar font Quicksand (bold)
- Field email dengan label di atas
- Button hijau (primary)
- Button outline hijau
- Text "Harga: Rp 299.000"

---

## 12. Step Indicator (Untuk Checkout)

Buat `lib/core/components/step_indicator.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_onlinestore_app/core/constants/colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;       // 1, 2, 3
  final int totalSteps;
  final List<String> labels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final step = i + 1;
        final isActive = step <= currentStep;
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.primary : AppColors.divider,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$step',
                  style: TextStyle(
                    color: isActive ? AppColors.white : AppColors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? AppColors.primary : AppColors.grey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
```

> Akan dipakai di sesi 09 (Checkout).

---

## ✅ Checklist Akhir Sesi 02

- [ ] `core/constants/colors.dart` — AppColors lengkap
- [ ] `core/constants/variables.dart` — baseUrl set
- [ ] `core/extensions/currency_ext.dart` — `.currencyFormatRp`, `.toRupiah`, `.toPrice`
- [ ] `core/extensions/date_ext.dart` — `.toFormattedDate`, `.toRelativeTime`
- [ ] `core/extensions/context_ext.dart` — `.push()`, `.pushReplacement()`, `.pushAndRemoveUntil()`, `.pop()`
- [ ] `core/components/spaces.dart`
- [ ] `core/components/buttons.dart` (Button.filled + Button.outlined)
- [ ] `core/components/custom_text_field.dart`
- [ ] `core/components/search_input.dart`
- [ ] `core/components/step_indicator.dart`
- [ ] Theme set di `main.dart` (Quicksand font, AppColors.primary)
- [ ] `initializeDateFormatting('id_ID', null)` di main
- [ ] Demo page tampil semua component

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| `LocaleDataException: Locale data has not been initialized` | Lupa init intl | Tambahkan `initializeDateFormatting('id_ID', null)` di main |
| Font Quicksand tidak muncul | google_fonts gagal download | Cek koneksi, force rebuild `flutter run` |
| `The non-abstract class 'Button' is missing implementations` | Conflict dengan Button bawaan | Pastikan import `buttons.dart` di file yang pakai |
| Extension tidak ke-detect | Lupa import extension file | Import file extension di tiap file yang pakai |

---

## 📝 Latihan Mandiri

1. Bikin extension `StringExt` untuk capitalize first letter: `'hello'.capitalize` → `'Hello'`
2. Tambahkan variant `Button.text` (tanpa border, plain text button) untuk link "Lupa Password?"
3. Bikin component `StatusBadge(String status)` yang otomatis pick warna dari status order (PENDING_PAYMENT, PAID, dll)

---

## ➡️ Lanjut ke [Sesi 03 — Data Layer](./03-data-layer.md)
