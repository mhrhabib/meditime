import 'package:flutter/material.dart';
import 'package:meditime/core/theme/app_theme.dart';

// ─── PREMIUM SCREEN ──────────────────────────────────────────
class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _yearly = true;

  @override
  Widget build(BuildContext context) {
    final perks = [
      (
        Icons.people_outline_rounded,
        'Unlimited family profiles',
        'Add parents, children, spouse'
      ),
      (
        Icons.person_add_outlined,
        'Caregiver sharing & alerts',
        'Notify family on missed doses'
      ),
      (
        Icons.document_scanner_outlined,
        'OCR prescription scanning',
        'Auto-extract medicines from photos'
      ),
      (
        Icons.picture_as_pdf_outlined,
        'Export history PDF / CSV',
        'Share reports with your doctor'
      ),
      (
        Icons.camera_alt_outlined,
        'AI medicine recognition',
        'Identify pills from photos'
      ),
      (Icons.block_outlined, 'Ad-free experience', 'No interruptions, ever'),
    ];

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppTheme.primaryContainer,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Icon(Icons.workspace_premium_rounded,
                        color: AppTheme.primary, size: 44),
                    const SizedBox(height: 8),
                    Text('Unlock Total Health Management',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: AppTheme.onPrimaryContainer),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('3-day free trial · cancel anytime',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppTheme.secondary)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Perks
                  ...perks.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryContainer
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:
                                  Icon(p.$1, color: AppTheme.primary, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.$2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                  Text(p.$3,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: AppTheme.outline)),
                                ],
                              ),
                            ),
                            const Icon(Icons.check_circle_rounded,
                                color: AppTheme.primary, size: 20),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Pricing toggle
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _yearly = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: !_yearly
                                    ? AppTheme.primary
                                    : AppTheme.outlineVariant,
                                width: !_yearly ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text('Monthly',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: AppTheme.outline)),
                                const SizedBox(height: 4),
                                Text('৳99',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.w800)),
                                Text('per month',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppTheme.outline)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _yearly = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _yearly
                                  ? AppTheme.primaryContainer
                                      .withValues(alpha: 0.3)
                                  : null,
                              border: Border.all(
                                color: _yearly
                                    ? AppTheme.primary
                                    : AppTheme.outlineVariant,
                                width: _yearly ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Column(
                                  children: [
                                    Text('Yearly',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                color: AppTheme.outline)),
                                    const SizedBox(height: 4),
                                    Text('৳699',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: AppTheme.primary)),
                                    Text('৳58/month',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: AppTheme.secondary)),
                                  ],
                                ),
                                Positioned(
                                  top: -24,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: AppTheme.primary,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Text('Best value · 40% off',
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Start 3-day free trial',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('No charge for 3 days. Cancel anytime.',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppTheme.outline),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  TextButton(
                      onPressed: () {},
                      child: const Text('Restore purchase',
                          style: TextStyle(
                              fontFamily: 'Nunito', color: AppTheme.outline))),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
