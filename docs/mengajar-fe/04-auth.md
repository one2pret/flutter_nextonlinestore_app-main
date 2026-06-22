# Sesi 04 — Authentication Flow

> ⏱️ Estimasi: 60 menit
> 🎯 Tujuan: Peserta paham BLoC + Freezed pattern, bisa bikin Splash → Onboarding → Login → Register, simpan token, dan redirect ke MainPage.

---

## 1. Konsep (10 menit)

### BLoC Pattern
- **Event** → input dari UI (user tap login)
- **BLoC** → proses event, panggil datasource, emit state
- **State** → output ke UI (loading/success/error)

```
[UI Page] --add(Event)--> [BLoC] --emit(State)--> [UI Page rebuild]
                            │
                            └──> [Datasource] --> [API]
```

### Freezed Union Type
Bikin sealed class otomatis dengan factory + `copyWith` + `==` + `hashCode`.

```dart
@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.success(AuthResponseModel data) = _Success;
  const factory LoginState.error(String message) = _Error;
}
```

Untuk pattern matching di UI pakai `maybeWhen`:
```dart
state.maybeWhen(
  loading: () => CircularProgressIndicator(),
  success: (data) => Text('Welcome ${data.user?.name}'),
  error: (msg) => Text(msg),
  orElse: () => SizedBox(),
);
```

### Code Generation
Tiap kali tulis/ubah file Freezed, WAJIB run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Generated file: `xxx.freezed.dart` (jangan diedit, auto-overwrite).

---

## 2. LoginBloc (Freezed)

### 2.1 Buat folder & file
```bash
mkdir -p lib/presentation/auth/bloc
```

Buat 3 file dalam folder ini:
- `login_event.dart`
- `login_state.dart`
- `login_bloc.dart`

### 2.2 `login_bloc.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_onlinestore_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_onlinestore_app/data/models/request/login_request_model.dart';
import 'package:flutter_onlinestore_app/data/models/response/auth_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource _datasource;

  LoginBloc(this._datasource) : super(const LoginState.initial()) {
    on<_Login>(_onLogin);
  }

  Future<void> _onLogin(_Login event, Emitter<LoginState> emit) async {
    emit(const LoginState.loading());
    final result = await _datasource.login(
      LoginRequestModel(email: event.email, password: event.password),
    );
    result.fold(
      (error) => emit(LoginState.error(error)),
      (data) => emit(LoginState.success(data)),
    );
  }
}
```

### 2.3 `login_event.dart`
```dart
part of 'login_bloc.dart';

@freezed
sealed class LoginEvent with _$LoginEvent {
  const factory LoginEvent.login({
    required String email,
    required String password,
  }) = _Login;
}
```

### 2.4 `login_state.dart`
```dart
part of 'login_bloc.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.success(AuthResponseModel data) = _Success;
  const factory LoginState.error(String message) = _Error;
}
```

### 2.5 Generate freezed file
```bash
dart run build_runner build --delete-conflicting-outputs
```

✅ **Checkpoint**: `login_bloc.freezed.dart` muncul. Tidak ada red squiggle di IDE.

> 🐛 **Common Issue**: kalau ada error "conflicting outputs" — pakai flag `--delete-conflicting-outputs` di atas.

---

## 3. RegisterBloc

Pattern sama persis dengan LoginBloc.

### 3.1 `lib/presentation/auth/bloc/register_bloc.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_onlinestore_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_onlinestore_app/data/models/request/register_request_model.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRemoteDatasource _datasource;

  RegisterBloc(this._datasource) : super(const RegisterState.initial()) {
    on<_Register>(_onRegister);
  }

  Future<void> _onRegister(_Register event, Emitter<RegisterState> emit) async {
    emit(const RegisterState.loading());
    final result = await _datasource.register(
      RegisterRequestModel(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      ),
    );
    result.fold(
      (error) => emit(RegisterState.error(error)),
      (message) => emit(RegisterState.success(message)),
    );
  }
}
```

### 3.2 `register_event.dart`
```dart
part of 'register_bloc.dart';

@freezed
sealed class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) = _Register;
}
```

### 3.3 `register_state.dart`
```dart
part of 'register_bloc.dart';

@freezed
sealed class RegisterState with _$RegisterState {
  const factory RegisterState.initial() = _Initial;
  const factory RegisterState.loading() = _Loading;
  const factory RegisterState.success(String message) = _Success;
  const factory RegisterState.error(String message) = _Error;
}
```

Re-run build_runner.

---

## 4. SplashPage

Buat `lib/presentation/auth/pages/splash_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_onlinestore_app/presentation/auth/pages/onboarding_page.dart';
import 'package:flutter_onlinestore_app/presentation/home/pages/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final isLoggedIn = await AuthLocalDatasource().isLoggedIn();
    if (!mounted) return;
    if (isLoggedIn) {
      context.pushAndRemoveUntil(const MainPage());
    } else {
      context.pushAndRemoveUntil(const OnboardingPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.storefront_rounded, size: 48, color: AppColors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Next', style: GoogleFonts.quicksand(
                  fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.tertiary)),
                Text('Elektronik', style: GoogleFonts.quicksand(
                  fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.white)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Belanja Online Mudah & Cepat',
              style: GoogleFonts.quicksand(
                fontSize: 14, color: AppColors.white.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

> 💡 **Key**: `mounted` check sebelum navigasi setelah async — supaya tidak crash kalau user pop dari splash.

---

## 5. OnboardingPage

Buat `lib/presentation/auth/pages/onboarding_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/presentation/auth/pages/login_page.dart';
import 'package:flutter_onlinestore_app/presentation/auth/pages/register_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.shopping_bag_rounded, size: 64, color: AppColors.white),
              ),
              const SpaceHeight(32),
              Text(
                'Selamat Datang di NextElektronik',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SpaceHeight(12),
              Text(
                'Belanja elektronik terlengkap, harga terbaik, langsung dari toko ke rumah kamu.',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(fontSize: 14, color: AppColors.darkGrey),
              ),
              const Spacer(),
              Button.filled(
                onPressed: () => context.push(const LoginPage()),
                label: 'Masuk',
                width: double.infinity,
              ),
              const SpaceHeight(12),
              Button.outlined(
                onPressed: () => context.push(const RegisterPage()),
                label: 'Daftar Akun',
                width: double.infinity,
              ),
              const SpaceHeight(16),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 6. LoginPage

Buat `lib/presentation/auth/pages/login_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/custom_text_field.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_onlinestore_app/presentation/auth/bloc/login_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/auth/pages/register_page.dart';
import 'package:flutter_onlinestore_app/presentation/home/pages/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (data) async {
              // Save token + user info
              await AuthLocalDatasource().saveToken(data.token!);
              await AuthLocalDatasource().saveUser(data.user!.toJson());
              if (context.mounted) {
                context.pushAndRemoveUntil(const MainPage());
              }
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: AppColors.error),
              );
            },
            orElse: () {},
          );
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Teal gradient header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 40),
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.storefront_rounded, size: 36, color: AppColors.white),
                    ),
                    const SpaceHeight(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Next', style: GoogleFonts.quicksand(
                          fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.tertiary)),
                        Text('Elektronik', style: GoogleFonts.quicksand(
                          fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white)),
                      ],
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Masuk', style: GoogleFonts.quicksand(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                      const SpaceHeight(4),
                      Text('Masuk ke akun kamu untuk mulai belanja',
                        style: GoogleFonts.quicksand(fontSize: 14, color: AppColors.darkGrey)),
                      const SpaceHeight(24),
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'contoh@email.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined, size: 20),
                        validator: (v) => (v == null || v.isEmpty) ? 'Email wajib diisi' : null,
                      ),
                      const SpaceHeight(16),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Masukkan password',
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20, color: AppColors.grey),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
                      ),
                      const SpaceHeight(24),

                      // Login button — BlocBuilder untuk loading state
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return Button.filled(
                            onPressed: state.maybeWhen(
                              loading: () => null,         // disable saat loading
                              orElse: () => () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginBloc>().add(
                                    LoginEvent.login(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                                }
                              },
                            ),
                            label: state.maybeWhen(
                              loading: () => 'Loading...',
                              orElse: () => 'Masuk',
                            ),
                            width: double.infinity,
                          );
                        },
                      ),
                      const SpaceHeight(24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Belum punya akun? ', style: GoogleFonts.quicksand(color: AppColors.darkGrey)),
                          GestureDetector(
                            onTap: () => context.push(const RegisterPage()),
                            child: Text('Daftar', style: GoogleFonts.quicksand(
                              color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Highlights:
1. **`BlocListener`** untuk side effect (navigate, SnackBar) — bukan rebuild UI
2. **`BlocBuilder`** untuk rebuild button (loading vs idle)
3. **`maybeWhen`** dengan `orElse` — handle semua state lain selain loading
4. **`mounted` check** sebelum `context.pushAndRemoveUntil` (async safety)

---

## 7. RegisterPage

Buat `lib/presentation/auth/pages/register_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/custom_text_field.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/presentation/auth/bloc/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: AppColors.success),
              );
              context.pop();
            },
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: AppColors.error),
              );
            },
            orElse: () {},
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                ),
                const SpaceHeight(16),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email wajib diisi';
                    if (!v.contains('@')) return 'Email tidak valid';
                    return null;
                  },
                ),
                const SpaceHeight(16),
                CustomTextField(
                  controller: _phoneController,
                  label: 'No HP',
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  validator: (v) => (v == null || v.isEmpty) ? 'No HP wajib diisi' : null,
                ),
                const SpaceHeight(16),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: _obscure,
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 20),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password wajib diisi';
                    if (v.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                const SpaceHeight(32),
                BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    return Button.filled(
                      onPressed: state.maybeWhen(
                        loading: () => null,
                        orElse: () => () {
                          if (_formKey.currentState!.validate()) {
                            context.read<RegisterBloc>().add(
                              RegisterEvent.register(
                                name: _nameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                                password: _passwordController.text,
                              ),
                            );
                          }
                        },
                      ),
                      label: state.maybeWhen(
                        loading: () => 'Loading...',
                        orElse: () => 'Daftar',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 8. Update `main.dart` (MultiBlocProvider)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_onlinestore_app/presentation/auth/bloc/login_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/auth/bloc/register_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/auth/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(AuthRemoteDatasource())),
        BlocProvider(create: (_) => RegisterBloc(AuthRemoteDatasource())),
        // ... bloc lain ditambahkan di sesi berikutnya
      ],
      child: MaterialApp(
        title: 'NextElektronik',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
          ),
          scaffoldBackgroundColor: AppColors.white,
          textTheme: GoogleFonts.quicksandTextTheme(),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
```

> ⚠️ **Catatan**: `SplashPage` reference `MainPage` (belum dibuat). Sementara bikin placeholder:
> ```dart
> // lib/presentation/home/pages/main_page.dart
> import 'package:flutter/material.dart';
> class MainPage extends StatelessWidget {
>   const MainPage({super.key});
>   @override
>   Widget build(BuildContext context) =>
>       const Scaffold(body: Center(child: Text('Main Page — to be implemented')));
> }
> ```

---

## 9. Test Flow End-to-End

1. Run app → Splash muncul 2 detik
2. Belum login → redirect ke Onboarding
3. Tap "Daftar" → form register → fill → submit → SnackBar success → kembali ke Onboarding
4. Tap "Masuk" → fill email & password → tap "Masuk"
5. Loading state muncul (tombol disable, label "Loading...")
6. Success → token tersimpan + redirect ke MainPage (placeholder)
7. Kill app → re-open → Splash → langsung ke MainPage (karena token tersimpan)

✅ **Checkpoint**: alur lengkap working tanpa crash.

---

## ✅ Checklist Akhir Sesi 04

- [ ] `LoginBloc` + Event + State + freezed.dart generated
- [ ] `RegisterBloc` + Event + State + freezed.dart generated
- [ ] `SplashPage` (cek token + delay 2 detik)
- [ ] `OnboardingPage` (welcome screen)
- [ ] `LoginPage` (form + BlocListener + BlocBuilder)
- [ ] `RegisterPage` (form + BlocListener)
- [ ] `main.dart` updated dengan MultiBlocProvider
- [ ] Test flow: register → login → token persist → auto-login setelah restart

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| `Don't know how to handle Event _Login` | Lupa register handler di constructor | Tambah `on<_Login>(_onLogin)` di BLoC |
| `LateInitializationError: ...freezed.dart not found` | Belum jalan build_runner | `dart run build_runner build --delete-conflicting-outputs` |
| `Could not find generator factories for: freezed` | Belum install freezed di dev_deps | Cek `pubspec.yaml`, `flutter pub get` |
| Snackbar tidak muncul setelah register | Lupa wrap dengan BlocListener | Pastikan BlocListener parent dari widget tree |
| `context not mounted` warning | Pakai context setelah await | Tambah `if (!mounted) return;` setelah await |
| Token tidak persist | Lupa `await` pada saveToken | Pakai `await AuthLocalDatasource().saveToken(...)` |

---

## 📝 Latihan Mandiri

1. Tambah "Lupa Password?" link di LoginPage (target: dialog "Coming soon")
2. Validasi password register: minimal 1 huruf besar + 1 angka
3. Tambah toggle "Show/Hide Password" di RegisterPage
4. Tambah field "Konfirmasi Password" di RegisterPage, validasi sama dengan password
5. Tambahkan logo asset (assets/images/logo.png) di Splash (replace icon storefront)

---

## ➡️ Lanjut ke [Sesi 05 — Main Page & Home](./05-home-main.md)
