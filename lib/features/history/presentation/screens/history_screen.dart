import 'package:flutter/material.dart';
import 'package:meditime/core/theme/app_theme.dart';
import 'package:meditime/core/widgets/components.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Stats'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Time Period Toggle ──────────────────────────────────
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text('This month', 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: Text('All time', 
                          style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // ── Key Stats ──────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    value: '92%',
                    label: 'Adherence',
                    icon: Icons.analytics_rounded,
                    containerColor: cs.primaryContainer.withOpacity(0.6),
                    contentColor: cs.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    value: '84',
                    label: 'Taken',
                    icon: Icons.check_circle_rounded,
                    containerColor: StatusColors.getTakenContainer(context),
                    contentColor: StatusColors.getTaken(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    value: '3',
                    label: 'Missed',
                    icon: Icons.cancel_rounded,
                    containerColor: StatusColors.getMissedContainer(context),
                    contentColor: StatusColors.getMissed(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // ── Per-medicine adherence ──────────────────────────────
            const SectionHeader(title: 'Per-medicine adherence'),
            const SizedBox(height: 8),
            _buildAdherenceBar(context, 'Metformin 500mg', 0.95),
            _buildAdherenceBar(context, 'Amlodipine 5mg', 0.88),
            _buildAdherenceBar(context, 'Vitamin D3', 0.65),

            const SizedBox(height: 32),

            // ── Health Vitals ────────────────────────────────────────
            SectionHeader(title: 'Health Vitals', action: '+ Add log', onAction: () {}),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _VitalCard(
                    title: 'Blood sugar', 
                    value: '5.4', 
                    unit: 'mmol/L', 
                    status: 'Normal', 
                    icon: Icons.water_drop_rounded, 
                    color: Colors.orange
                  ),
                  _VitalCard(
                    title: 'Blood pressure', 
                    value: '120/80', 
                    unit: 'mmHg', 
                    status: 'Normal', 
                    icon: Icons.favorite_rounded, 
                    color: Colors.red
                  ),
                  _VitalCard(
                    title: 'Weight', 
                    value: '72.5', 
                    unit: 'kg', 
                    status: '-1.2kg', 
                    icon: Icons.monitor_weight_rounded, 
                    color: Colors.blue
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildAdherenceBar(BuildContext context, String name, double percentage) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Text('${(percentage * 100).toInt()}%', 
                style: TextStyle(color: cs.primary, fontWeight: FontWeight.w800, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.secondary],
                    ),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VitalCard extends StatelessWidget {
  final String title, value, unit, status;
  final IconData icon;
  final Color color;

  const _VitalCard({
    required this.title, 
    required this.value, 
    required this.unit, 
    required this.status, 
    required this.icon, 
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(title, style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(width: 4),
              Text(unit, style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status, 
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: cs.primary)),
          ),
        ],
      ),
    );
  }
}
