# Sesi 11 — Profile & Account Management

> ⏱️ Estimasi: 45 menit
> 🎯 Tujuan: Peserta bisa bikin profile page lengkap dengan edit profil, ubah password, hapus akun, navigasi ke alamat, link static (T&C + Privacy), logout.

---

## 1. Konsep (5 menit)

### Profile = User Dashboard
Tab terakhir di BottomNav. Tidak butuh BLoC khusus — datasource `AuthRemoteDatasource` sudah punya `updateProfile`, `changePassword`, `deleteAccount`. Page langsung panggil datasource dengan loading state lokal.

### Pattern Profile Menu
- Header gradient + avatar + nama + email
- Group menu (Akun / Informasi / Lainnya)
- Tombol logout
- Versi app di bawah

### Static Pages (T&C, Privacy)
Pakai Markdown atau plain Text. Bikin file `terms_conditions_page.dart` dan `privacy_policy_page.dart` dengan content hardcode atau load dari `assets/`.

---

## 2. ProfilePage

`lib/presentation/profile/pages/profile_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_onlinestore_app/data/models/response/auth_response_model.dart';
import 'package:flutter_onlinestore_app/presentation/address/pages/address_list_page.dart';
import 'package:flutter_onlinestore_app/presentation/profile/pages/edit_profile_page.dart';
import 'package:flutter_onlinestore_app/presentation/profile/pages/change_password_page.dart';
import 'package:flutter_onlinestore_app/presentation/profile/pages/terms_conditions_page.dart';
import 'package:flutter_onlinestore_app/presentation/profile/pages/privacy_policy_page.dart';
import 'package:flutter_onlinestore_app/presentation/profile/pages/delete_account_page.dart';
import 'package:flutter_onlinestore_app/presentation/auth/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userJson = await AuthLocalDatasource().getUser();
    if (userJson != null && mounted) {
      setState(() => _user = User.fromJson(userJson));
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar', style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await AuthLocalDatasource().clearAll();
      if (mounted) context.pushAndRemoveUntil(const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SpaceHeight(16),
            _buildSection('Akun', [
              _MenuItem(
                icon: Icons.person_outline,
                title: 'Edit Profil',
                onTap: () async {
                  final updated = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                  if (updated == true) _loadUser();
                },
              ),
              _MenuItem(
                icon: Icons.location_on_outlined,
                title: 'Alamat Pengiriman',
                onTap: () => context.push(const AddressListPage()),
              ),
              _MenuItem(
                icon: Icons.lock_outline,
                title: 'Ubah Password',
                onTap: () => context.push(const ChangePasswordPage()),
              ),
            ]),
            const SpaceHeight(12),
            _buildSection('Informasi', [
              _MenuItem(
                icon: Icons.description_outlined,
                title: 'Syarat & Ketentuan',
                onTap: () => context.push(const TermsConditionsPage()),
              ),
              _MenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Kebijakan Privasi',
                onTap: () => context.push(const PrivacyPolicyPage()),
              ),
            ]),
            const SpaceHeight(12),
            _buildSection('Lainnya', [
              _MenuItem(
                icon: Icons.delete_outline,
                title: 'Hapus Akun',
                titleColor: AppColors.error,
                onTap: () => context.push(const DeleteAccountPage()),
              ),
            ]),
            const SpaceHeight(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text('Keluar', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SpaceHeight(16),
            const Text('NextElektronik v1.0.0',
              style: TextStyle(fontSize: 12, color: AppColors.grey)),
            const SpaceHeight(24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 56, bottom: 24),
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Column(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white.withValues(alpha: 0.5), width: 2),
            ),
            child: const Icon(Icons.person, size: 36, color: AppColors.white),
          ),
          const SpaceHeight(12),
          Text(_user?.name ?? 'User', style: GoogleFonts.quicksand(
            fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.white)),
          const SpaceHeight(4),
          Text(_user?.email ?? '', style: GoogleFonts.quicksand(
            fontSize: 13, color: AppColors.white.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<_MenuItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title, style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.grey)),
          ),
          ...items.map((item) => ListTile(
            leading: Icon(item.icon, color: item.titleColor ?? AppColors.darkGrey),
            title: Text(item.title, style: TextStyle(
              fontWeight: FontWeight.w500, color: item.titleColor ?? AppColors.black)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
            onTap: item.onTap,
          )),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  const _MenuItem({required this.icon, required this.title, required this.onTap, this.titleColor});
}
```

---

## 3. EditProfilePage

`lib/presentation/profile/pages/edit_profile_page.dart`:

```dart
import 'package:flutter/material.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/custom_text_field.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_onlinestore_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_onlinestore_app/data/models/response/auth_response_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userJson = await AuthLocalDatasource().getUser();
    if (userJson != null && mounted) {
      final user = User.fromJson(userJson);
      _nameCtrl.text = user.name ?? '';
      _phoneCtrl.text = user.phone ?? '';
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    final result = await AuthRemoteDatasource().updateProfile(
      name: _nameCtrl.text,
      phone: _phoneCtrl.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    result.fold(
      (err) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err))),
      (user) async {
        await AuthLocalDatasource().saveUser(user.toJson());
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context, true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(controller: _nameCtrl, label: 'Nama Lengkap'),
            const SpaceHeight(16),
            CustomTextField(controller: _phoneCtrl, label: 'No HP', keyboardType: TextInputType.phone),
            const SpaceHeight(24),
            Button.filled(
              onPressed: _isLoading ? null : _save,
              label: _isLoading ? 'Menyimpan...' : 'Simpan',
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 4. ChangePasswordPage

`lib/presentation/profile/pages/change_password_page.dart`:

```dart
import 'package:flutter/material.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/custom_text_field.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/data/datasources/auth_remote_datasource.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_newCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak cocok')));
      return;
    }
    setState(() => _isLoading = true);
    final result = await AuthRemoteDatasource().changePassword(
      currentPassword: _currentCtrl.text,
      newPassword: _newCtrl.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    result.fold(
      (err) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err))),
      (msg) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: AppColors.success));
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Password')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _currentCtrl,
                label: 'Password Saat Ini',
                obscureText: _obscure,
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SpaceHeight(16),
              CustomTextField(
                controller: _newCtrl,
                label: 'Password Baru',
                obscureText: _obscure,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Wajib diisi';
                  if (v.length < 6) return 'Min. 6 karakter';
                  return null;
                },
              ),
              const SpaceHeight(16),
              CustomTextField(
                controller: _confirmCtrl,
                label: 'Konfirmasi Password Baru',
                obscureText: _obscure,
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SpaceHeight(24),
              Button.filled(
                onPressed: _isLoading ? null : _submit,
                label: _isLoading ? 'Memproses...' : 'Ubah Password',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 5. DeleteAccountPage

`lib/presentation/profile/pages/delete_account_page.dart`:

```dart
import 'package:flutter/material.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/custom_text_field.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_onlinestore_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_onlinestore_app/presentation/auth/pages/login_page.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Akun?'),
        content: const Text('Tindakan ini PERMANEN. Semua data akan dihapus dan tidak bisa dipulihkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus Permanen', style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    final result = await AuthRemoteDatasource().deleteAccount(password: _passwordCtrl.text);
    if (!mounted) return;
    setState(() => _isLoading = false);
    result.fold(
      (err) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err))),
      (msg) async {
        await AuthLocalDatasource().clearAll();
        if (!mounted) return;
        context.pushAndRemoveUntil(const LoginPage());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hapus Akun')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(children: [
                Icon(Icons.warning_amber, color: AppColors.error),
                SizedBox(width: 12),
                Expanded(child: Text(
                  'Menghapus akun akan menghapus semua data Anda secara permanen.',
                  style: TextStyle(color: AppColors.error))),
              ]),
            ),
            const SpaceHeight(16),
            CustomTextField(
              controller: _passwordCtrl,
              label: 'Masukkan password untuk konfirmasi',
              obscureText: true,
            ),
            const SpaceHeight(24),
            Button.filled(
              onPressed: _isLoading ? null : _deleteAccount,
              label: _isLoading ? 'Menghapus...' : 'Hapus Akun Saya',
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 6. Static Pages (T&C + Privacy Policy)

`lib/presentation/profile/pages/terms_conditions_page.dart`:

```dart
import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Syarat & Ketentuan')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          '''Syarat & Ketentuan NextElektronik

1. Aplikasi ini hanya untuk pembelian pribadi.
2. Pesanan yang sudah dibayar tidak bisa di-refund kecuali...
3. ... (lanjutan T&C)''',
          style: TextStyle(height: 1.5),
        ),
      ),
    );
  }
}
```

`lib/presentation/profile/pages/privacy_policy_page.dart` — pattern sama dengan konten privacy policy.

> 💡 **Tips Production**: load dari file `assets/legal/terms.md` (pakai package `flutter_markdown`) supaya bisa update tanpa rebuild app.

---

## 7. Test Flow

1. Login → buka tab Profil
2. Header tampil avatar + nama + email
3. Tap "Edit Profil" → form muncul terisi → ubah nama → simpan → SnackBar success → kembali, nama di profile update
4. Tap "Ubah Password" → fill 3 field → submit → success → kembali
5. Tap "Alamat Pengiriman" → buka AddressListPage
6. Tap "Hapus Akun" → page muncul, isi password, konfirm dialog → akun dihapus, redirect ke Login
7. Tap "Keluar" → konfirmasi → token cleared → kembali ke Login

✅ **Checkpoint**: semua flow profile working.

---

## ✅ Checklist Akhir Sesi 11

- [ ] ProfilePage dengan header + 3 section menu + logout
- [ ] EditProfilePage (nama, phone) → updateProfile
- [ ] ChangePasswordPage (current + new + confirm)
- [ ] DeleteAccountPage dengan password confirm + dialog
- [ ] TermsConditionsPage (static)
- [ ] PrivacyPolicyPage (static)
- [ ] Logout flow: clearAll → redirect Login
- [ ] User data load dari SharedPreferences

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| User data tidak update setelah edit | Lupa `saveUser` setelah API success | Call `AuthLocalDatasource().saveUser(...)` setelah updateProfile sukses |
| Logout tidak redirect | Pakai `Navigator.pushReplacement` (back masih bisa) | Pakai `pushAndRemoveUntil` |
| Password gagal "incorrect" padahal benar | API hash mismatch | Cek backend hash algorithm (bcrypt) |
| Email tidak tampil | User model belum tersimpan | Test login ulang, cek `saveUser` |

---

## 📝 Latihan Mandiri

1. Tambah **avatar upload** (image_picker package) — pakai endpoint upload backend
2. Tambah **dark mode toggle** di section "Lainnya" (pakai ThemeData provider)
3. Tambah **bahasa Inggris/Indonesia toggle** (pakai `intl` locale)
4. Tambah **app version** auto dari `package_info_plus` package (bukan hardcode)

---

## ➡️ Lanjut ke [Sesi 12 — Build & Release ke Play Store](./12-release.md)
