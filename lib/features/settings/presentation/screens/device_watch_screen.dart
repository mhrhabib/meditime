import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/core/device/device_preferences.dart';
import 'package:meditime/core/sync/scheduling_service.dart';
import 'package:meditime/core/storage/app_database.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';

class DeviceWatchScreen extends StatefulWidget {
  const DeviceWatchScreen({super.key});

  @override
  State<DeviceWatchScreen> createState() => _DeviceWatchScreenState();
}

class _DeviceWatchScreenState extends State<DeviceWatchScreen> {
  final _db = AppDatabase.instance;
  List<ProfileTableData> _profiles = [];
  Set<String> _selected = {};
  String? _default;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profiles = await _db.getAllProfiles();
    final watched = await DevicePreferences.getWatchedProfileIds();
    final def = await DevicePreferences.getDefaultProfileId();
    if (!mounted) return;
    setState(() {
      _profiles = profiles;
      _selected = watched.toSet();
      _default = def;
    });
  }

  Future<void> _save() async {
    // 1. Update primary user in cubit (handles both storage and UI state)
    if (_default != null) {
      await context.read<ProfileCubit>().setMainUser(_default!);
    }
    if (!mounted) return;

    // 2. Update watched profiles list
    await DevicePreferences.setWatchedProfileIds(_selected.toList());
    if (!mounted) return;

    // 3. Reschedule background notifications
    try {
      await SchedulingService.instance.scheduleWatched();
    } catch (e) {
      debugPrint('[DeviceWatchScreen] scheduleWatched failed: $e');
    }

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content:
            Text('Settings saved — identification and notifications updated'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Give the user a brief moment to see the confirmation before closing.
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Settings'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _InfoSection(
              icon: Icons.person_pin_rounded,
              title: 'Primary Identity',
              subtitle:
                  'The profile checked on the right is the main user of this specific phone.',
            ),
            const SizedBox(height: 12),
            const _InfoSection(
              icon: Icons.notifications_active_rounded,
              title: 'Notification Watch',
              subtitle:
                  'Checked boxes on the left determine which additional profiles you receive alerts for.',
            ),
            const SizedBox(height: 24),
            RadioGroup<String?>(
              groupValue: _default,
              onChanged: (v) {
                setState(() {
                  _default = v;
                  if (v != null) _selected.add(v); // Always watch primary
                });
              },
              child: Column(
                children: _profiles.map((p) {
                  final isWatched = _selected.contains(p.id);
                  final isPrimary = _default == p.id;

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isPrimary
                            ? Colors.blue.withValues(alpha: 0.3)
                            : Colors.grey.withValues(alpha: 0.1),
                        width: isPrimary ? 2 : 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        leading: Checkbox(
                          value: isWatched,
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                _selected.add(p.id);
                              } else {
                                if (isPrimary) {
                                  // Cannot unwatch yourself
                                  _toast(
                                      'You must watch your own primary profile');
                                  return;
                                }
                                _selected.remove(p.id);
                              }
                            });
                          },
                        ),
                        title: Text(
                          p.name,
                          style: TextStyle(
                            fontWeight:
                                isPrimary ? FontWeight.bold : FontWeight.normal,
                            color:
                                isPrimary ? Colors.blue.shade800 : Colors.black,
                          ),
                        ),
                        subtitle: isPrimary
                            ? const Text('Primary Account',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600))
                            : (isWatched
                                ? const Text('Watching notifications')
                                : null),
                        trailing: Radio<String?>(
                          value: p.id,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              Text(subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
