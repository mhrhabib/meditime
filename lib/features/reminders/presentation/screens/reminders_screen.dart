import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _soundVibration = true;
  bool _autoRepeat = true;
  bool _lockScreen = true;
  bool _criticalOverride = false;
  bool _allowSnooze = true;
  int _snoozeDuration = 10;
  int _maxSnooze = 3;
  bool _quietHours = false;
  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 6, minute: 0);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Alert behavior ──────────────────────────────────
          const _SectionHeader('Alert Behavior'),
          _Card(children: [
            SwitchListTile(
              value: _soundVibration,
              onChanged: (v) => setState(() => _soundVibration = v),
              activeColor: cs.primary,
              secondary: _iconBox(context, Icons.volume_up_rounded, cs.primary),
              title: Text('Sound & Vibration', style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
              subtitle: Text('Play a sound when a reminder fires', style: tt.bodySmall),
            ),
            const _Divider(),
            SwitchListTile(
              value: _autoRepeat,
              onChanged: (v) => setState(() => _autoRepeat = v),
              activeColor: cs.primary,
              secondary: _iconBox(context, Icons.repeat_rounded, cs.secondary),
              title: Text('Auto-repeat Alarm', style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
              subtitle: Text('Re-rings every 5 min until you respond', style: tt.bodySmall),
            ),
            const _Divider(),
            SwitchListTile(
              value: _lockScreen,
              onChanged: (v) => setState(() => _lockScreen = v),
              activeColor: cs.primary,
              secondary: _iconBox(context, Icons.lock_outline_rounded, cs.tertiary),
              title: Text('Lock Screen Notification', style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
              subtitle: Text('Show dose details without unlocking', style: tt.bodySmall),
            ),
            const _Divider(),
            SwitchListTile(
              value: _criticalOverride,
              onChanged: (v) => setState(() => _criticalOverride = v),
              activeColor: cs.error,
              secondary: _iconBox(context, Icons.priority_high_rounded, cs.error),
              title: Text('Critical Alert Override', style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
              subtitle: Text('Break through silent/DND for life-critical meds', style: tt.bodySmall),
            ),
          ]),
          const SizedBox(height: 24),

          // ── Snooze settings ─────────────────────────────────
          const _SectionHeader('Snooze Settings'),
          _Card(children: [
            SwitchListTile(
              value: _allowSnooze,
              onChanged: (v) => setState(() => _allowSnooze = v),
              activeColor: cs.primary,
              secondary: _iconBox(context, Icons.snooze_rounded, cs.secondary),
              title: Text('Allow Snooze', style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
              subtitle: Text('Snooze and respond later', style: tt.bodySmall),
            ),
            if (_allowSnooze) ...[
              const _Divider(),
              ListTile(
                leading: _iconBox(context, Icons.timer_outlined, cs.outline),
                title: Text('Snooze Duration', style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                trailing: _StepperWidget(
                  value: _snoozeDuration,
                  unit: 'min',
                  min: 5,
                  max: 30,
                  step: 5,
                  onChanged: (v) => setState(() => _snoozeDuration = v),
                ),
              ),
              const _Divider(),
              ListTile(
                leading: _iconBox(context, Icons.block_rounded, cs.outline),
                title: Text('Max Snooze Count', style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                subtitle: Text('After this, marked as missed', style: tt.bodySmall),
                trailing: _StepperWidget(
                  value: _maxSnooze,
                  unit: 'times',
                  min: 1,
                  max: 5,
                  step: 1,
                  onChanged: (v) => setState(() => _maxSnooze = v),
                ),
              ),
            ],
          ]),
          const SizedBox(height: 24),

          // ── Quiet hours ─────────────────────────────────────
          const _SectionHeader('Quiet Hours'),
          _Card(children: [
            SwitchListTile(
              value: _quietHours,
              onChanged: (v) => setState(() => _quietHours = v),
              activeColor: cs.primary,
              secondary: _iconBox(context, Icons.bedtime_outlined, cs.tertiary),
              title: Text('Enable Quiet Hours', style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
              subtitle: Text('Mute non-critical reminders', style: tt.bodySmall),
            ),
            if (_quietHours) ...[
              const _Divider(),
              ListTile(
                leading: _iconBox(context, Icons.nights_stay_outlined, cs.outline),
                title: Text('From', style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                trailing: TextButton(
                  onPressed: () => _pickTime(context, _quietStart, (t) => setState(() => _quietStart = t)),
                  child: Text(_quietStart.format(context), 
                    style: TextStyle(fontWeight: FontWeight.w800, color: cs.primary)),
                ),
              ),
              const _Divider(),
              ListTile(
                leading: _iconBox(context, Icons.wb_sunny_outlined, cs.outline),
                title: Text('Until', style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                trailing: TextButton(
                  onPressed: () => _pickTime(context, _quietEnd, (t) => setState(() => _quietEnd = t)),
                  child: Text(_quietEnd.format(context), 
                    style: TextStyle(fontWeight: FontWeight.w800, color: cs.primary)),
                ),
              ),
            ],
          ]),
          const SizedBox(height: 32),

          // ── Save button ─────────────────────────────────────
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Notification settings saved ✓'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: cs.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Save Changes'),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, TimeOfDay initial, void Function(TimeOfDay) onPick) async {
    final result = await showTimePicker(context: context, initialTime: initial);
    if (result != null) onPick(result);
  }

  Widget _iconBox(BuildContext context, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, 
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        )),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, indent: 56, endIndent: 16, 
      color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3));
  }
}

class _StepperWidget extends StatelessWidget {
  final int value, min, max, step;
  final String unit;
  final ValueChanged<int> onChanged;

  const _StepperWidget({
    required this.value, required this.unit, required this.min, 
    required this.max, required this.step, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          icon: const Icon(Icons.remove_rounded, size: 18),
          onPressed: value > min ? () => onChanged(value - step) : null,
          style: IconButton.styleFrom(minimumSize: const Size(32, 32)),
        ),
        const SizedBox(width: 12),
        Text('$value $unit', 
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(width: 4),
        IconButton.filledTonal(
          icon: const Icon(Icons.add_rounded, size: 18),
          onPressed: value < max ? () => onChanged(value + step) : null,
          style: IconButton.styleFrom(minimumSize: const Size(32, 32)),
        ),
      ],
    );
  }
}
