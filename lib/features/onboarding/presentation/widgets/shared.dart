import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const PageHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(icon, color: cs.primary, size: 26.r),
        ),
        SizedBox(height: 16.h),
        Text(
          title,
          style: tt.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1.15,
            fontSize: 24.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          style: tt.bodyLarge?.copyWith(
            color: cs.onSurfaceVariant,
            height: 1.5,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}

class NextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const NextButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          minimumSize: Size(double.infinity, 56.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.sp),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_rounded, size: 18.r),
          ],
        ),
      ),
    );
  }
}

class ProgressDots extends StatelessWidget {
  final int total;
  final int current;

  const ProgressDots({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isActive ? 24.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: isActive ? cs.primary : cs.outlineVariant,
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }
}

class TrustChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color iconColor;

  const TrustChip({
    super.key,
    required this.icon,
    required this.label,
    required this.sub,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16.r),
          SizedBox(width: 6.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: cs.onPrimaryContainer,
                  height: 1.1,
                ),
              ),
              Text(
                sub,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 9.sp,
                  color: cs.onPrimaryContainer.withValues(alpha: 0.6),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
