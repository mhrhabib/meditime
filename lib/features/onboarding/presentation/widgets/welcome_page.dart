import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'shared.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const WelcomePage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      color: cs.primaryContainer,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 128.r,
                height: 128.r,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.3),
                      blurRadius: 30.r,
                      offset: Offset(0, 12.h),
                    ),
                  ],
                ),
                child: Icon(Icons.medication_rounded,
                    size: 64.r, color: Colors.white),
              ),
              SizedBox(height: 28.h),
              Text(
                'MediTime',
                style: tt.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onPrimaryContainer,
                  letterSpacing: -1,
                  fontSize: 32.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your personal health companion.\nNever miss a dose again.',
                style: tt.bodyLarge?.copyWith(
                  color: cs.onPrimaryContainer.withValues(alpha: 0.75),
                  height: 1.5,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TrustChip(
                    icon: Icons.verified_user_rounded,
                    label: 'Private',
                    sub: 'on device',
                    iconColor: cs.primary,
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onNext();
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 56.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r)),
                    backgroundColor: cs.primary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Let's get started",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16.sp,
                              color: Colors.white)),
                      SizedBox(width: 8.w),
                      Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 20.r),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Takes 60 seconds · No account needed',
                style: tt.bodySmall?.copyWith(
                    color: cs.onPrimaryContainer.withValues(alpha: 0.6), fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
