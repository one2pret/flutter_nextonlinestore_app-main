import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../order/pages/order_list_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../search/search_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _switchToSearch({String? category}) {
    setState(() => _selectedIndex = 1);
  }

  void _switchToHome() {
    setState(() => _selectedIndex = 0);
  }

  late final List<Widget> _pages = [
    HomeApiPage(onSwitchToSearch: _switchToSearch),
    SearchPage(onBack: _switchToHome),
    const OrderListPage(),
    const ProfileApiPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selectedIndex != 0) _switchToHome();
      },
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white.withValues(alpha: 0.6),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
      ),
    );
  }
}
