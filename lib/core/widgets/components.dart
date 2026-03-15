import 'package:flutter/material.dart';
import 'package:meditime/core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS — theme-adaptive color shortcuts
// ─────────────────────────────────────────────────────────────────────────────

extension _ThemeX on BuildContext {
  ColorScheme get cs => Theme.of(this).colorScheme;
  TextTheme get tt => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Switcher
// ─────────────────────────────────────────────────────────────────────────────

class ProfileSwitcher extends StatelessWidget {
  final String name;
  final String initials;
  final List<String> dependents;
  final VoidCallback onTap;

  const ProfileSwitcher({
    super.key,
    required this.name,
    required this.initials,
    required this.dependents,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Avatar(initials: initials, size: 32),
            const SizedBox(width: 8),
            Text(name,
                style: context.tt.labelLarge?.copyWith(color: cs.primary)),
            if (dependents.isNotEmpty) ...[
              const SizedBox(width: 6),
              Container(width: 1, height: 16, color: cs.outlineVariant),
              const SizedBox(width: 6),
              Text(
                dependents.join(' · '),
                style:
                    context.tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
            const SizedBox(width: 4),
            Icon(Icons.expand_more_rounded,
                size: 18, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar
// ─────────────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String initials;
  final double size;
  const _Avatar({required this.initials, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: cs.primaryContainer, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: size * 0.35,
          fontWeight: FontWeight.w700,
          color: cs.onPrimaryContainer,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Card
// ─────────────────────────────────────────────────────────────────────────────

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color containerColor;
  final Color contentColor;
  final IconData icon;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.containerColor,
    required this.contentColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: contentColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: contentColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: contentColor.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Medicine Timeline Tile
// ─────────────────────────────────────────────────────────────────────────────

class MedicineTile extends StatelessWidget {
  final String time;
  final String name;
  final String dose;
  final String instruction;
  final MedicineStatus status;
  final VoidCallback? onTake;
  final VoidCallback? onSkip;
  final VoidCallback? onSnooze;

  const MedicineTile({
    super.key,
    required this.time,
    required this.name,
    required this.dose,
    required this.instruction,
    required this.status,
    this.onTake,
    this.onSkip,
    this.onSnooze,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final colors = _statusColors(context, status);
    final isPending = status == MedicineStatus.pending;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Text(
              time,
              style:
                  context.tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              const SizedBox(height: 4),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: colors.dot,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: cs.surface, width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: colors.dot.withOpacity(0.4),
                        blurRadius: 4,
                        spreadRadius: 1)
                  ],
                ),
              ),
              if (isPending)
                Container(
                    width: 2, height: 72, color: cs.outlineVariant),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isPending ? cs.surface : colors.bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isPending
                      ? cs.outlineVariant
                      : colors.dot.withOpacity(0.3),
                  width: isPending ? 1.5 : 1,
                ),
                boxShadow: isPending
                    ? [
                        BoxShadow(
                            color: context.isDark
                                ? Colors.black26
                                : const Color(0x0D000000),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: context.tt.titleSmall?.copyWith(
                            color: isPending ? cs.onSurface : colors.text,
                          ),
                        ),
                      ),
                      _StatusChip(status: status, context: context),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$dose · $instruction',
                    style: context.tt.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  if (isPending) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _ActionBtn(
                            label: '✓ Take',
                            color: StatusColors.getTaken(context),
                            bg: StatusColors.getTakenContainer(context),
                            onTap: onTake),
                        const SizedBox(width: 6),
                        _ActionBtn(
                            label: 'Skip',
                            color: StatusColors.getMissed(context),
                            bg: StatusColors.getMissedContainer(context),
                            onTap: onSkip),
                        const SizedBox(width: 6),
                        _ActionBtn(
                            label: '+30m',
                            color: StatusColors.getPending(context),
                            bg: StatusColors.getPendingContainer(context),
                            onTap: onSnooze),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _StatusColorSet _statusColors(BuildContext context, MedicineStatus s) {
    switch (s) {
      case MedicineStatus.taken:
        return _StatusColorSet(
          StatusColors.getTakenContainer(context),
          StatusColors.getTaken(context),
          StatusColors.getTaken(context),
        );
      case MedicineStatus.missed:
        return _StatusColorSet(
          StatusColors.getMissedContainer(context),
          StatusColors.getMissed(context),
          StatusColors.getMissed(context),
        );
      case MedicineStatus.pending:
        return _StatusColorSet(
          context.cs.surface,
          context.cs.onSurfaceVariant,
          context.cs.onSurface,
        );
    }
  }
}

class _StatusColorSet {
  final Color bg, dot, text;
  const _StatusColorSet(this.bg, this.dot, this.text);
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Chip
// ─────────────────────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final MedicineStatus status;
  final BuildContext context;
  const _StatusChip({required this.status, required this.context});

  @override
  Widget build(BuildContext _) {
    final (label, bg, fg) = switch (status) {
      MedicineStatus.taken => (
          '✓ Taken',
          StatusColors.getTakenContainer(context),
          StatusColors.getTaken(context),
        ),
      MedicineStatus.missed => (
          '✗ Missed',
          StatusColors.getMissedContainer(context),
          StatusColors.getMissed(context),
        ),
      MedicineStatus.pending => (
          'Due',
          StatusColors.getPendingContainer(context),
          StatusColors.getPending(context),
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Button (Take / Skip / Snooze)
// ─────────────────────────────────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color, bg;
  final VoidCallback? onTap;
  const _ActionBtn(
      {required this.label, required this.color, required this.bg, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color)),
      ),
    );
  }
}

enum MedicineStatus { taken, missed, pending }

// ─────────────────────────────────────────────────────────────────────────────
// Stock Progress Bar
// ─────────────────────────────────────────────────────────────────────────────

class StockBar extends StatelessWidget {
  final int remaining;
  final int total;
  final int daysLeft;

  const StockBar(
      {super.key,
      required this.remaining,
      required this.total,
      required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    final ratio = (remaining / total).clamp(0.0, 1.0);
    final isLow = daysLeft <= 3;
    final isMid = daysLeft <= 7;
    final color = isLow
        ? StatusColors.getMissed(context)
        : (isMid ? StatusColors.getPending(context) : StatusColors.getTaken(context));
    final bgColor = isLow
        ? StatusColors.getMissedContainer(context)
        : StatusColors.getTakenContainer(context).withOpacity(0.4);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$remaining left',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color)),
              Text('$daysLeft day${daysLeft == 1 ? '' : 's'} supply',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      color: color.withOpacity(0.75))),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Streak Row
// ─────────────────────────────────────────────────────────────────────────────

class StreakRow extends StatelessWidget {
  final List<StreakDay> days;
  const StreakRow({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: days.map((d) => Expanded(child: _StreakCell(day: d))).toList(),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            '${days.where((d) => d.status == DayStatus.taken).length}-day streak this week 🔥',
            style: context.tt.labelSmall
                ?.copyWith(color: context.cs.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _StreakCell extends StatelessWidget {
  final StreakDay day;
  const _StreakCell({required this.day});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (day.status) {
      DayStatus.taken => (
          StatusColors.getTakenContainer(context),
          StatusColors.getTaken(context)
        ),
      DayStatus.missed => (
          StatusColors.getMissedContainer(context),
          StatusColors.getMissed(context)
        ),
      DayStatus.partial => (
          StatusColors.getPendingContainer(context),
          StatusColors.getPending(context)
        ),
      DayStatus.future => (
          context.cs.surfaceContainerHighest,
          context.cs.onSurfaceVariant
        ),
    };
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 36,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Text(day.label,
          style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: fg)),
    );
  }
}

class StreakDay {
  final String label;
  final DayStatus status;
  const StreakDay(this.label, this.status);
}

enum DayStatus { taken, missed, partial, future }

// ─────────────────────────────────────────────────────────────────────────────
// Medicine Card
// ─────────────────────────────────────────────────────────────────────────────

class MedicineCard extends StatelessWidget {
  final String name;
  final String type;
  final String schedule;
  final int stockRemaining;
  final int stockTotal;
  final int daysLeft;
  final bool isLowStock;
  final VoidCallback? onEdit;
  final VoidCallback? onRefill;

  const MedicineCard({
    super.key,
    required this.name,
    required this.type,
    required this.schedule,
    required this.stockRemaining,
    required this.stockTotal,
    required this.daysLeft,
    this.isLowStock = false,
    this.onEdit,
    this.onRefill,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final lowColor = StatusColors.getLowStock(context);
    final lowContainer = StatusColors.getLowStockContainer(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isLowStock ? lowContainer : cs.outlineVariant,
          width: isLowStock ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_typeIcon(type), size: 22, color: cs.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: context.tt.titleSmall),
                      Text(schedule,
                          style: context.tt.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                if (isLowStock)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: lowContainer,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('Low stock',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: lowColor)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            StockBar(
                remaining: stockRemaining,
                total: stockTotal,
                daysLeft: daysLeft),
            if (isLowStock) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: onRefill,
                  style: FilledButton.styleFrom(
                    backgroundColor: StatusColors.getPendingContainer(context),
                    foregroundColor: StatusColors.getPending(context),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Mark as refilled',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                      foregroundColor: cs.secondary,
                      textStyle: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.pause_outlined, size: 16),
                  label: const Text('Pause'),
                  style: TextButton.styleFrom(
                      foregroundColor: cs.onSurfaceVariant,
                      textStyle: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    return switch (type.toLowerCase()) {
      'tablet' => Icons.medication_rounded,
      'syrup' => Icons.local_drink_outlined,
      'injection' => Icons.vaccines_outlined,
      'drops' => Icons.water_drop_outlined,
      'inhaler' => Icons.air_outlined,
      _ => Icons.medication_rounded,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Alert Banner
// ─────────────────────────────────────────────────────────────────────────────

class AlertBanner extends StatelessWidget {
  final String message;
  final AlertType type;
  final VoidCallback? onAction;
  final String? actionLabel;

  const AlertBanner({
    super.key,
    required this.message,
    this.type = AlertType.warning,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon) = switch (type) {
      AlertType.warning => (
          StatusColors.getPendingContainer(context),
          StatusColors.getPending(context),
          Icons.warning_amber_rounded,
        ),
      AlertType.error => (
          StatusColors.getMissedContainer(context),
          StatusColors.getMissed(context),
          Icons.error_outline_rounded,
        ),
      AlertType.success => (
          StatusColors.getTakenContainer(context),
          StatusColors.getTaken(context),
          Icons.check_circle_outline_rounded,
        ),
      AlertType.info => (
          context.cs.tertiaryContainer,
          context.cs.tertiary,
          Icons.info_outline_rounded,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: fg))),
          if (onAction != null && actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                  foregroundColor: fg,
                  padding: const EdgeInsets.symmetric(horizontal: 8)),
              child: Text(actionLabel!,
                  style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ),
        ],
      ),
    );
  }
}

enum AlertType { warning, error, success, info }

// ─────────────────────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader(
      {super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: context.tt.titleMedium),
          if (action != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: context.cs.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                textStyle: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 13),
              ),
              child: Text(action!),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Prescription Card
// ─────────────────────────────────────────────────────────────────────────────

class PrescriptionCard extends StatelessWidget {
  final String doctorName;
  final String date;
  final String reason;
  final List<String> medicines;
  final bool isScanned;
  final VoidCallback? onScan;

  const PrescriptionCard({
    super.key,
    required this.doctorName,
    required this.date,
    required this.reason,
    required this.medicines,
    required this.isScanned,
    this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 60,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.description_outlined,
                  color: cs.onSurfaceVariant, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctorName, style: context.tt.titleSmall),
                  Text('$date · $reason',
                      style: context.tt.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  if (isScanned)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: medicines
                          .take(2)
                          .map((m) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: cs.primaryContainer.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(m,
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: cs.primary)),
                              ))
                          .toList()
                        ..addAll(medicines.length > 2
                            ? [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: cs.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text('+${medicines.length - 2} more',
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 11,
                                          color: cs.onSurfaceVariant)),
                                )
                              ]
                            : []),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: onScan,
                      icon: const Icon(Icons.document_scanner_outlined, size: 14),
                      label: const Text('Extract medicines (OCR)',
                          style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: StatusColors.getPending(context),
                        side: BorderSide(
                            color: StatusColors.getPendingContainer(context)),
                        backgroundColor: StatusColors.getPendingContainer(context),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isScanned
                    ? StatusColors.getTakenContainer(context)
                    : StatusColors.getPendingContainer(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isScanned ? 'Scanned' : 'Pending',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isScanned
                      ? StatusColors.getTaken(context)
                      : StatusColors.getPending(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Emergency Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class EmergencyCardWidget extends StatelessWidget {
  final String name;
  final String age;
  final String bloodGroup;
  final List<String> allergies;
  final List<String> conditions;
  final List<String> medicines;
  final String emergencyContact;
  final String lastUpdated;

  const EmergencyCardWidget({
    super.key,
    required this.name,
    required this.age,
    required this.bloodGroup,
    required this.allergies,
    required this.conditions,
    required this.medicines,
    required this.emergencyContact,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bgColor = isDark ? const Color(0xFF2D1B1B) : const Color(0xFFFFF3F0);
    final borderColor = isDark ? const Color(0xFF7A3030) : const Color(0xFFFFB4AB);
    final headerColor = isDark ? const Color(0xFF3D2020) : const Color(0xFFFFDAD6);
    final titleColor = isDark ? const Color(0xFFFFB4AB) : const Color(0xFF410002);
    final subtitleColor = isDark ? const Color(0xFFCF8080) : const Color(0xFF93000A);
    final textColor = isDark ? const Color(0xFFFFDAD6) : const Color(0xFF410002);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(19), topRight: Radius.circular(19)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.emergency_rounded, color: subtitleColor, size: 20),
                    const SizedBox(width: 8),
                    Text('EMERGENCY MEDICAL CARD',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: titleColor,
                            letterSpacing: 0.5)),
                  ],
                ),
                Text(lastUpdated,
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        color: subtitleColor)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: headerColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        name.split(' ').map((n) => n[0]).take(2).join(),
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: subtitleColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: titleColor)),
                        Text('Age $age · Blood: $bloodGroup',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 13,
                                color: subtitleColor)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(color: borderColor),
                const SizedBox(height: 10),
                _EmRow(label: 'Allergies', value: allergies.join(', '), labelColor: subtitleColor, textColor: textColor),
                _EmRow(label: 'Conditions', value: conditions.join(' · '), labelColor: subtitleColor, textColor: textColor),
                _EmRow(label: 'Medicines', value: medicines.join(' · '), labelColor: subtitleColor, textColor: textColor),
                _EmRow(label: 'Emergency contact', value: emergencyContact, isLast: true, labelColor: subtitleColor, textColor: textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final Color labelColor;
  final Color textColor;
  const _EmRow({required this.label, required this.value, this.isLast = false, required this.labelColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: labelColor)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor)),
        ],
      ),
    );
  }
}
