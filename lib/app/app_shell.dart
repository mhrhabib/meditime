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
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: (Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.4)
                    : Colors.white.withOpacity(0.65)),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.white.withOpacity(0.25)),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
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
    if (_index == 0 || _index == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            HapticFeedback.lightImpact();
            _openAddMedicine();
          },
          icon: const Icon(SolarIconsOutline.addCircle),
          label: const Text('Add Medicine'),
        ),
      );
    } else if (_index == 3) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            HapticFeedback.lightImpact();
            // Handle new prescription action
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('New RX'),
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
    final inactiveColor = theme.colorScheme.outline.withOpacity(0.7);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_index != index) {
            HapticFeedback.lightImpact();
            setState(() => _index = index);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Center(
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
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: activeColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Icon(
                    isSelected ? selectedIcon : icon,
                    color: isSelected ? activeColor : inactiveColor,
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: 1),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 9,
                  letterSpacing: 0.1,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
