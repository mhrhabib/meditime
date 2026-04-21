import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditime/features/medicines/presentation/screens/add_medicine_screen.dart';
import 'package:meditime/features/prescriptions/presentation/screens/prescriptions_screen.dart';
import 'package:meditime/features/home/presentation/screens/home_screen.dart';
import 'package:meditime/features/history/presentation/screens/history_screen.dart';
import 'package:meditime/features/medicines/presentation/screens/medicine_list_screen.dart';
import 'package:meditime/features/settings/presentation/screens/settings_screen.dart';
import 'package:solar_icons/solar_icons.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    MedicineListScreen(),
    HistoryScreen(),
    PrescriptionsScreen(),
    SettingsScreen(),
  ];

  void _openAddMedicine() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_index],
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: _getFAB(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 64.h,
              decoration: BoxDecoration(
                color: (Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.65)),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.25)),
                  width: 1.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, SolarIconsOutline.home,
                      SolarIconsOutline.home2, 'Home'),
                  _buildNavItem(1, SolarIconsOutline.pill,
                      SolarIconsOutline.pill, 'Meds'),
                  _buildNavItem(2, SolarIconsOutline.history,
                      SolarIconsOutline.history, 'History'),
                  _buildNavItem(3, SolarIconsOutline.document,
                      SolarIconsOutline.document, 'Docs'),
                  _buildNavItem(4, SolarIconsOutline.settings,
                      SolarIconsOutline.settings, 'Settings'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _getFAB() {
    if (_index == 1) {
      return Padding(
        padding: EdgeInsets.only(bottom: 30.h),
        child: FloatingActionButton.extended(
          onPressed: () {
            HapticFeedback.lightImpact();
            _openAddMedicine();
          },
          icon: Icon(SolarIconsOutline.addCircle, size: 24.r),
          label: Text('Add Medicine', style: TextStyle(fontSize: 14.sp)),
        ),
      );
    } 
    return null;
  }

  Widget _buildNavItem(
      int index, IconData icon, IconData selectedIcon, String label) {
    final isSelected = _index == index;
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.outline.withValues(alpha: 0.7);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_index != index) {
            HapticFeedback.lightImpact();
            setState(() => _index = index);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  child: Container(
                    height: 32.r,
                    width: 32.r,
                    decoration: BoxDecoration(
                      color: activeColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 22.r,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 9.sp,
                letterSpacing: 0.1,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
