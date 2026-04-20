import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeEmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const HomeEmptyState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.medication_rounded, size: 64.r, color: cs.primary),
            ),
            SizedBox(height: 20.h),
            Text(
              'No medicines yet',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add your first medicine to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 28.h),
            SizedBox(
              width: double.infinity,
              height: 60.h,
              child: FilledButton.icon(
                onPressed: onAdd,
                icon: Icon(Icons.add_rounded, size: 28.r),
                label: Text(
                  'Add your first medicine',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
