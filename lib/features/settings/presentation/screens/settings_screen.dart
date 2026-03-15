import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/core/theme/cubit/theme_cubit.dart';
import 'package:meditime/features/reminders/presentation/screens/reminders_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // ── Profile Section ──────────────────────────────────────
          _ProfileCard(),
          const SizedBox(height: 24),

          // ── Preferences Section ──────────────────────────────────
          _SectionTitle('Preferences'),
          _SettingsTile(
            icon: Icons.notifications_active_outlined,
            title: 'Notifications & Reminders',
            subtitle: 'Alarms, snooze, quiet hours',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RemindersScreen()),
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
                    DropdownMenuItem(value: ThemeModeOption.system, child: Text('System')),
                    DropdownMenuItem(value: ThemeModeOption.light, child: Text('Light')),
                    DropdownMenuItem(value: ThemeModeOption.dark, child: Text('Dark')),
                  ],
                ),
              );
            },
          ),
          
          _SettingsTile(
            icon: Icons.security_outlined,
            title: 'Security & Biometrics',
            subtitle: 'Face ID, App lock',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // ── Data Section ─────────────────────────────────────────
          _SectionTitle('Data & Backup'),
          _SettingsTile(
            icon: Icons.cloud_upload_outlined,
            title: 'Automatic Backup',
            subtitle: 'Last synced: 2 hours ago',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.file_download_outlined,
            title: 'Export Health Data',
            subtitle: 'PDF, CSV or FHIR format',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // ── Support Section ──────────────────────────────────────
          _SectionTitle('Support'),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Help Center',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // ── About Section ────────────────────────────────────────
          _SectionTitle('About'),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'Software Version',
            subtitle: '1.2.0 (Stable)',
          ),
          _SettingsTile(
            icon: Icons.gavel_outlined,
            title: 'Terms & Privacy Policy',
            onTap: () {},
          ),
          
          const SizedBox(height: 32),
          
          // Sign Out
          Center(
            child: TextButton(
              onPressed: () => _showSignOutDialog(context),
              style: TextButton.styleFrom(
                foregroundColor: cs.error,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout_rounded, size: 18),
                  SizedBox(width: 8),
                  const Text('Sign out from this device', 
                    style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  String _getThemeModeLabel(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.system: return 'System Default';
      case ThemeModeOption.light: return 'Light Mode';
      case ThemeModeOption.dark: return 'Dark Mode';
    }
  }

  void _showSignOutDialog(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('Are you sure you want to sign out? Your local data will be safely encrypted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(backgroundColor: cs.error, foregroundColor: cs.onError),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
                ),
                alignment: Alignment.center,
                child: Text('MH', 
                  style: tt.headlineSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mhr Habib', 
                      style: tt.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                    Text('Joined March 2024', 
                      style: tt.bodySmall?.copyWith(color: Colors.white.withOpacity(0.9))),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'Medicines', value: '12'),
                _StatDivider(),
                _StatItem(label: 'Streak', value: '5d'),
                _StatDivider(),
                _StatItem(label: 'Points', value: '450'),
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
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 24, color: Colors.white.withOpacity(0.2));
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 12),
      child: Text(title, 
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
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
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: cs.primary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, 
                      style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w700, fontSize: 15)),
                    if (subtitle != null)
                      Text(subtitle!, 
                        style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
              if (trailing != null) trailing!
              else if (onTap != null)
                Icon(Icons.chevron_right_rounded, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}
