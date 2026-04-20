import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/core/theme/cubit/theme_cubit.dart';
import 'package:meditime/features/reminders/presentation/screens/reminders_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontSize: 20.sp)),
        centerTitle: false,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        children: [
          // ── Profile Section ──────────────────────────────────────
          _ProfileCard(),
          SizedBox(height: 24.h),

          // ── Preferences Section ──────────────────────────────────
          const _SectionTitle('Preferences'),
          _SettingsTile(
            icon: Icons.notifications_active_outlined,
            title: 'Notifications & Reminders',
            subtitle: 'Alarms, snooze, quiet hours',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RemindersScreen()),
              );
            },
          ),

          // Dark Mode Toggle
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return _SettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Appearance',
                subtitle: _getThemeModeLabel(state.themeModeOption),
                trailing: DropdownButton<ThemeModeOption>(
                  value: state.themeModeOption,
                  underline: const SizedBox(),
                  onChanged: (ThemeModeOption? newValue) {
                    if (newValue != null) {
                      context.read<ThemeCubit>().updateTheme(newValue);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                        value: ThemeModeOption.system, child: Text('System')),
                    DropdownMenuItem(
                        value: ThemeModeOption.light, child: Text('Light')),
                    DropdownMenuItem(
                        value: ThemeModeOption.dark, child: Text('Dark')),
                  ],
                ),
              );
            },
          ),

          _SettingsTile(
            icon: Icons.security_outlined,
            title: 'Security & Biometrics',
            subtitle: 'Face ID, App lock',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Security settings coming soon!')));
            },
          ),
          SizedBox(height: 24.h),

          // ── Data Section ─────────────────────────────────────────
          const _SectionTitle('Data & Backup'),
          _SettingsTile(
            icon: Icons.cloud_upload_outlined,
            title: 'Automatic Backup',
            subtitle: 'Last synced: 2 hours ago',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Backup triggered successfully! ✓')));
            },
          ),
          _SettingsTile(
            icon: Icons.file_download_outlined,
            title: 'Export Health Data',
            subtitle: 'PDF, CSV or FHIR format',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Generating health report PDF...')));
            },
          ),
          SizedBox(height: 24.h),

          // ── Support Section ──────────────────────────────────────
          const _SectionTitle('Support'),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Help Center',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening help center...')));
            },
          ),
          _SettingsTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening feedback form...')));
            },
          ),
          SizedBox(height: 24.h),

          // ── About Section ────────────────────────────────────────
          const _SectionTitle('About'),
          const _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'Software Version',
            subtitle: '1.2.0 (Stable)',
          ),
          _SettingsTile(
            icon: Icons.gavel_outlined,
            title: 'Terms & Privacy Policy',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Opening terms and conditions...')));
            },
          ),

          SizedBox(height: 32.h),

          // Sign Out
          Center(
            child: TextButton(
              onPressed: () => _showSignOutDialog(context),
              style: TextButton.styleFrom(
                foregroundColor: cs.error,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout_rounded, size: 18.r),
                  SizedBox(width: 8.w),
                  Text('Sign out from this device',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp)),
                ],
              ),
            ),
          ),
          SizedBox(height: 48.h),
        ],
      ),
    );
  }

  String _getThemeModeLabel(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.system:
        return 'System Default';
      case ThemeModeOption.light:
        return 'Light Mode';
      case ThemeModeOption.dark:
        return 'Dark Mode';
    }
  }

  void _showSignOutDialog(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
            'Are you sure you want to sign out? Your local data will be safely encrypted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(
                backgroundColor: cs.error, foregroundColor: cs.onError),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5), width: 3.w),
                ),
                alignment: Alignment.center,
                child: Text('MH',
                    style: tt.headlineSmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 18.sp)),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mhr Habib',
                        style: tt.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18.sp)),
                    Text('Joined March 2024',
                        style: tt.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11.sp)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit_note_rounded,
                    color: Colors.white, size: 24.r),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const _StatItem(label: 'Medicines', value: '12'),
                _StatDivider(),
                const _StatItem(label: 'Streak', value: '5d'),
                _StatDivider(),
                const _StatItem(label: 'Points', value: '450'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18.sp)),
        Text(label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8), fontSize: 11.sp)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.w, height: 24.h, color: Colors.white.withValues(alpha: 0.2));
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 0, 0, 12.h),
      child: Text(title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                fontSize: 12.sp,
              )),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: cs.primary, size: 22.r),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp)),
                    if (subtitle != null)
                      Text(subtitle!,
                          style: TextStyle(
                              color: cs.onSurfaceVariant, fontSize: 11.sp)),
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (onTap != null)
                Icon(Icons.chevron_right_rounded,
                    color: cs.outline, size: 20.r),
            ],
          ),
        ),
      ),
    );
  }
}
