import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/guest_prompt_view.dart';
import '../../../core/components/spaces.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../address/pages/address_list_page.dart';
import '../../auth/login_page.dart';
import '../../order/pages/order_list_page.dart';
import '../bloc/profile_bloc.dart';
import 'edit_profile_page.dart';

class ProfileApiPage extends StatefulWidget {
  const ProfileApiPage({super.key});

  @override
  State<ProfileApiPage> createState() => _ProfileApiPageState();
}

class _ProfileApiPageState extends State<ProfileApiPage> {
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await AuthLocalDatasource().isLoggedIn();
    if (!mounted) return;
    setState(() => _isLoggedIn = loggedIn);
    if (loggedIn) {
      context.read<ProfileBloc>().add(const ProfileEvent.getProfile());
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text('Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.read<ProfileBloc>().add(const ProfileEvent.logout());
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        title: const Text('Profil Saya'),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        automaticallyImplyLeading: false,
      );

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == null) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_isLoggedIn == false) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const GuestPromptView(
          message: 'Silakan masuk untuk melihat profil Anda.',
        ),
      );
    }
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (ctx, state) {
        state.maybeWhen(
          loggedOut: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (_) => false,
            );
          },
          error: (msg) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg)));
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Profil Saya'),
          leading: Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (ctx, state) {
            final user = state.maybeWhen(
              loaded: (u) => u,
              updated: (u) => u,
              orElse: () => null,
            );
            final loading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );
            if (loading && user == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          (user?.name?.isNotEmpty == true
                                  ? user!.name![0]
                                  : '?')
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SpaceWidth(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? '-',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            Text(user?.email ?? '-',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600)),
                            if (user?.phone?.isNotEmpty == true)
                              Text(user!.phone!,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SpaceHeight(16),
                _MenuTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profil',
                  onTap: user == null
                      ? null
                      : () => context
                          .push(EditProfilePage(user: user)),
                ),
                _MenuTile(
                  icon: Icons.location_on_outlined,
                  title: 'Alamat Saya',
                  onTap: () => context.push(const AddressListPage()),
                ),
                _MenuTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Pesanan Saya',
                  onTap: () => context.push(const OrderListPage()),
                ),
                const SpaceHeight(24),
                Button.outlined(
                  onPressed: _confirmLogout,
                  label: 'Keluar',
                  color: Colors.red,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  const _MenuTile({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
