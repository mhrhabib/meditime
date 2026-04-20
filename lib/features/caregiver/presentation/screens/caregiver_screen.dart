import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaregiverScreen extends StatelessWidget {
  const CaregiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Caregiver Access', style: TextStyle(fontSize: 20.sp)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share your schedule with family or doctors so they can help you stay on track.',
              style: tt.bodyMedium?.copyWith(
                color: cs.outline,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                icon: Icon(Icons.link, size: 20.r),
                label: Text('Invite caregiver by link',
                    style: TextStyle(fontSize: 15.sp)),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                "Caregivers don't need to install the app",
                style: TextStyle(fontSize: 12.sp, color: cs.outline),
              ),
            ),
            SizedBox(height: 32.h),
            Text('Active Caregivers',
                style:
                    TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                children: [
                  Icon(Icons.people_outline_rounded,
                      size: 40.r, color: cs.outlineVariant),
                  SizedBox(height: 8.h),
                  Text(
                    'No caregivers yet',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Invite someone to get started.',
                    style: TextStyle(fontSize: 12.sp, color: cs.outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
