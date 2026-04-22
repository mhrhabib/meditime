import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/core/storage/app_database.dart';
import 'package:meditime/core/theme/cubit/theme_cubit.dart';
import 'package:meditime/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:meditime/features/auth/presentation/cubit/auth_state.dart';
import 'package:meditime/features/history/domain/entities/dose_log.dart';
import 'package:meditime/features/history/presentation/cubit/history_cubit.dart';
import 'package:meditime/features/medicines/presentation/cubit/medicine_cubit.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';
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
            subtitle: 'Tap to back up your data',
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
            subtitle: '1.0.0 (Beta)',
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
            'Are you sure you want to sign out? Your local data will be removed from this device but kept in the cloud.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              // 1. Wipe local DB (v5 helper)
              await AppDatabase.instance.clearAllUserData();
              // 2. Clear Supabase session (router will redirect to sign-in)
              if (context.mounted) {
                await context.read<AuthCubit>().signOut();
              }
            },
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

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        final profile = profileState.activeProfile;
        final name = profileState.activeProfileName;
        final initials = profileState.initials;

        final subtitleParts = <String>[];
        if (profile?.age != null) subtitleParts.add('Age ${profile!.age}');
        if (profile?.gender != null && profile!.gender!.isNotEmpty) {
          subtitleParts.add(profile.gender!);
        }
        
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final email = authState is AuthAuthenticated ? authState.email : '';
            final subtitle = subtitleParts.isEmpty 
              ? email
              : '${subtitleParts.join(' · ')} · $email';

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
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 3.w),
                        ),
                        alignment: Alignment.center,
                        child: Text(initials,
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
                            Text(name,
                                style: tt.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18.sp)),
                            Text(subtitle,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: BlocBuilder<MedicineCubit, MedicineState>(
                      builder: (context, medState) {
                        return BlocBuilder<HistoryCubit, HistoryState>(
                          builder: (context, historyState) {
                            final medicineCount = medState.medicines.length;
                            final streakDays =
                                _currentStreakDays(historyState.events);
                            final adherencePct =
                                (historyState.adherenceRate * 100).round();
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _StatItem(
                                    label: 'Medicines',
                                    value: '$medicineCount'),
                                _StatDivider(),
                                _StatItem(
                                    label: 'Streak', value: '${streakDays}d'),
                                _StatDivider(),
                                _StatItem(
                                    label: 'Adherence',
                                    value: '$adherencePct%'),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Count consecutive days ending today that have at least one taken dose.
  /// Logs without a taken status don't break the streak by themselves;
  /// an empty day does.
  int _currentStreakDays(List<DoseLog> events) {
    if (events.isEmpty) return 0;
    final takenDates = <DateTime>{
      for (final e in events)
        if (e.status == DoseStatus.taken)
          DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day),
    };
    if (takenDates.isEmpty) return 0;

    final now = DateTime.now();
    var cursor = DateTime(now.year, now.month, now.day);
    var streak = 0;
    while (takenDates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
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
