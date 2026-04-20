import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: 4.h),
          Text(
            subtitle!,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
