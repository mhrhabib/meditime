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
                  const TrustChip(
                    icon: Icons.star_rounded,
                    label: '4.9',
                    sub: 'Play Store',
                    iconColor: Color(0xFFFFB300),
                  ),
                  SizedBox(width: 8.w),
                  TrustChip(
                    icon: Icons.people_rounded,
                    label: '500K+',
                    sub: 'users',
                    iconColor: cs.primary,
                  ),
                  SizedBox(width: 8.w),
                  TrustChip(
                    icon: Icons.verified_user_rounded,
                    label: 'Private',
                    sub: 'on device',
                    iconColor: cs.primary,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: cs.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: cs.primary.withValues(alpha: 0.15),
                      child: Text('R',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: cs.primary)),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (_) => Icon(Icons.star_rounded,
                                  size: 12.r, color: const Color(0xFFFFB300)),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '"Helped my father take his BP pills on time. Life-changing."',
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text('— Rafiq · Dhaka',
                              style:
                                  tt.labelSmall?.copyWith(color: cs.outline, fontSize: 10.sp)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
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
