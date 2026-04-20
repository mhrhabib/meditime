import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/features/onboarding/presentation/cubit/onboarding_cubit.dart';

class PremiumPage extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onSkip;

  const PremiumPage(
      {super.key, required this.onStart, required this.onSkip});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage>
    with SingleTickerProviderStateMixin {
  bool _yearlySelected = true;

  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  static const _perks = [
    (Icons.people_alt_rounded, 'Unlimited family profiles'),
    (Icons.notifications_active_rounded, 'Caregiver sharing & alerts'),
    (Icons.document_scanner_rounded, 'OCR prescription scanning'),
    (Icons.auto_awesome_rounded, 'AI medicine recognition'),
    (Icons.picture_as_pdf_rounded, 'Export reports as PDF'),
    (Icons.block_rounded, 'Ad-free experience'),
  ];

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  cs.primaryContainer,
                  cs.primaryContainer.withValues(alpha: 0.4),
                  cs.surface,
                ],
                stops: const [0, 0.35, 0.7],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      tooltip: 'Skip',
                      icon: Icon(Icons.close_rounded,
                          color: cs.onPrimaryContainer
                              .withValues(alpha: 0.7)),
                      onPressed: widget.onSkip,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 96,
                        height: 96,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _shimmer,
                              builder: (_, __) => Transform.rotate(
                                angle: _shimmer.value * 6.28,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: SweepGradient(
                                      colors: [
                                        cs.primary.withValues(alpha: 0.0),
                                        cs.primary.withValues(alpha: 0.35),
                                        cs.primary.withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    cs.primary,
                                    cs.primary.withValues(alpha: 0.75),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: cs.primary.withValues(alpha: 0.4),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                  Icons.workspace_premium_rounded,
                                  size: 40,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('MEDITIME PRO',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.6,
                                color: cs.primary)),
                      ),
                      const SizedBox(height: 12),
                      BlocBuilder<OnboardingCubit, OnboardingState>(
                        builder: (ctx, state) {
                          final name = state.userName;
                          return Text(
                            name != null && name.isNotEmpty
                                ? 'Try Pro free\nfor 3 days, $name'
                                : 'Try Pro free\nfor 3 days',
                            style: tt.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: cs.onPrimaryContainer,
                              letterSpacing: -0.6,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Unlock everything. Cancel anytime.',
                        style: tt.bodyMedium?.copyWith(
                            color: cs.onPrimaryContainer
                                .withValues(alpha: 0.7)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: cs.surface.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: cs.primary.withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (_) => const Icon(Icons.star_rounded,
                                    size: 14, color: Color(0xFFFFB300)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '4.9 · Loved by 500K+ users',
                              style: tt.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _PerkGrid(perks: _perks),
                      const SizedBox(height: 24),
                      const _TrialTimeline(),
                      const SizedBox(height: 24),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _PlanCard(
                                selected: !_yearlySelected,
                                title: 'Monthly',
                                price: '৳99',
                                sub: 'per month',
                                onTap: () =>
                                    setState(() => _yearlySelected = false),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _PlanCard(
                                selected: _yearlySelected,
                                title: 'Yearly',
                                price: '৳699',
                                sub: 'Just ৳58/mo',
                                originalPrice: '৳1,188',
                                badge: 'SAVE 40%',
                                onTap: () =>
                                    setState(() => _yearlySelected = true),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline_rounded,
                              size: 14, color: cs.outline),
                          const SizedBox(width: 6),
                          Text(
                            'Secure payment · Cancel anytime',
                            style:
                                tt.labelSmall?.copyWith(color: cs.outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
                decoration: BoxDecoration(
                  color: cs.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              cs.primary,
                              cs.primary.withValues(alpha: 0.82),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              context
                                  .read<OnboardingCubit>()
                                  .setPremium(true);
                              widget.onStart();
                            },
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Start 3-day free trial',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                          color: Colors.white,
                                          letterSpacing: 0.2)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded,
                                      color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _yearlySelected
                          ? 'Free for 3 days, then ৳699/year. Cancel anytime.'
                          : 'Free for 3 days, then ৳99/month. Cancel anytime.',
                      style: tt.bodySmall?.copyWith(color: cs.outline),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: widget.onSkip,
                      child: Text('Continue with free plan',
                          style: TextStyle(
                              color: cs.outline,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PerkGrid extends StatelessWidget {
  final List<(IconData, String)> perks;
  const _PerkGrid({required this.perks});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: perks.map((p) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: (MediaQuery.of(context).size.width - 48 - 10) / 2,
            maxWidth: (MediaQuery.of(context).size.width - 48 - 10) / 2,
          ),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: cs.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: cs.primary.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(p.$1, size: 16, color: cs.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    p.$2,
                    style: tt.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TrialTimeline extends StatelessWidget {
  const _TrialTimeline();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    const steps = [
      (Icons.lock_open_rounded, 'Today', 'Full access unlocked. No charge.'),
      (
        Icons.notifications_rounded,
        'Day 2',
        "We'll remind you 24h before trial ends."
      ),
      (
        Icons.event_available_rounded,
        'Day 3',
        'Cancel anytime in Settings — no fees.'
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(steps[i].$1, size: 18, color: cs.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(steps[i].$2,
                          style: tt.labelMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.primary)),
                      const SizedBox(height: 2),
                      Text(steps[i].$3,
                          style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant, height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
            if (i < steps.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  width: 2,
                  height: 14,
                  color: cs.primary.withValues(alpha: 0.15),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String price;
  final String sub;
  final String? originalPrice;
  final String? badge;
  final VoidCallback onTap;

  const _PlanCard({
    required this.selected,
    required this.title,
    required this.price,
    required this.sub,
    this.originalPrice,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
            decoration: BoxDecoration(
              color: selected
                  ? cs.primaryContainer.withValues(alpha: 0.45)
                  : cs.surface.withValues(alpha: 0.9),
              border: Border.all(
                color: selected ? cs.primary : cs.outlineVariant,
                width: selected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _RadioDot(selected: selected),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: tt.labelLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (originalPrice != null)
                  Text(
                    originalPrice!,
                    style: tt.bodySmall?.copyWith(
                      color: cs.outline,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                Text(
                  price,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: selected ? cs.primary : cs.onSurface,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(sub, style: tt.bodySmall?.copyWith(color: cs.outline)),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: -10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(badge!,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    )),
              ),
            ),
        ],
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? cs.primary : cs.outline,
          width: 2,
        ),
        color: selected ? cs.primary : Colors.transparent,
      ),
      alignment: Alignment.center,
      child: selected
          ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
          : null,
    );
  }
}
