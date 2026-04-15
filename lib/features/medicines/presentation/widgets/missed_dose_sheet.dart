import 'package:flutter/material.dart';

/// Bottom sheet for collecting missed-dose reason.
/// Returns the selected reason string or null if dismissed.
class MissedDoseSheet extends StatefulWidget {
  final String medicineName;
  final DateTime scheduledTime;

  const MissedDoseSheet({
    super.key,
    required this.medicineName,
    required this.scheduledTime,
  });

  /// Show the sheet and return the selected reason (or null).
  static Future<MissedDoseResult?> show(
    BuildContext context, {
    required String medicineName,
    required DateTime scheduledTime,
  }) {
    return showModalBottomSheet<MissedDoseResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MissedDoseSheet(
        medicineName: medicineName,
        scheduledTime: scheduledTime,
      ),
    );
  }

  @override
  State<MissedDoseSheet> createState() => _MissedDoseSheetState();
}

class MissedDoseResult {
  final String reason;
  final String? note;
  MissedDoseResult({required this.reason, this.note});
}

class _MissedDoseSheetState extends State<MissedDoseSheet> {
  String? _selectedReason;
  final _noteController = TextEditingController();

  static const _reasons = [
    {'icon': '🤦', 'label': 'Forgot'},
    {'icon': '⚠️', 'label': 'Side effects'},
    {'icon': '📦', 'label': 'Ran out'},
    {'icon': '🤷', 'label': "Didn't need it"},
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Missed dose',
              style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.medicineName} — ${_formatTime(widget.scheduledTime)}',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 20),

            // Reason chips
            Text('Why did you miss this dose?',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _reasons.map((r) {
                final isSelected = _selectedReason == r['label'];
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(r['icon']!, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(r['label']!),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedReason = r['label']);
                  },
                  selectedColor: cs.primaryContainer,
                  backgroundColor: cs.surfaceContainerHighest,
                  labelStyle: TextStyle(
                    color: isSelected ? cs.onPrimaryContainer : cs.onSurface,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? cs.primary : Colors.transparent,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Optional note
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Add a note (optional)',
                hintStyle: TextStyle(color: cs.onSurfaceVariant.withOpacity(0.6)),
                filled: true,
                fillColor: cs.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _selectedReason != null
                    ? () {
                        Navigator.of(context).pop(MissedDoseResult(
                          reason: _selectedReason!,
                          note: _noteController.text.isEmpty
                              ? null
                              : _noteController.text,
                        ));
                      }
                    : null,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Save reason',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min $amPm';
  }
}
