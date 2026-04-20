import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/features/profile/domain/entities/profile.dart';

class ProfileSwitcher extends StatelessWidget {
  final String name;
  final String initials;
  final List<Profile> profiles;
  final Function(String) onSwitch;

  const ProfileSwitcher({
    super.key,
    required this.name,
    required this.initials,
    required this.profiles,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final otherProfiles = profiles.where((p) => p.name != name).toList();

    return PopupMenuButton<String>(
      onSelected: onSwitch,
      offset: Offset(0, 40.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      itemBuilder: (context) => [
        ...profiles.map((p) => PopupMenuItem(
              value: p.id,
              child: Row(
                children: [
                  _Avatar(initials: p.initials, size: 24.r),
                  SizedBox(width: 12.w),
                  Text(p.name,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: p.name == name ? FontWeight.w800 : FontWeight.w600,
                        color: p.name == name ? cs.primary : cs.onSurface,
                        fontSize: 14.sp,
                      )),
                  if (p.name == name) ...[
                    const Spacer(),
                    Icon(Icons.check_circle_rounded, size: 16.r, color: cs.primary),
                  ],
                ],
              ),
            )),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'add',
          child: Row(
            children: [
              Icon(Icons.add_circle_outline_rounded, size: 20.r, color: cs.secondary),
              SizedBox(width: 12.w),
              Text('Add Member', style: TextStyle(fontFamily: 'Nunito', fontSize: 13.sp)),
            ],
          ),
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Avatar(initials: initials, size: 32.r),
            SizedBox(width: 8.w),
            Text(name, style: tt.labelLarge?.copyWith(color: cs.primary, fontSize: 14.sp)),
            if (otherProfiles.isNotEmpty) ...[
              SizedBox(width: 6.w),
              Container(width: 1, height: 16.h, color: cs.outlineVariant),
              SizedBox(width: 6.w),
              Text(
                otherProfiles.take(1).map((p) => p.name).join(''),
                style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant, fontSize: 11.sp),
              ),
              if (otherProfiles.length > 1)
                Text(' +${otherProfiles.length - 1}',
                    style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant, fontSize: 11.sp)),
            ],
            SizedBox(width: 4.w),
            Icon(Icons.expand_more_rounded, size: 18.r, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  final double size;
  const _Avatar({required this.initials, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: cs.primaryContainer, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: (size * 0.35).sp,
          fontWeight: FontWeight.w700,
          color: cs.onPrimaryContainer,
        ),
      ),
    );
  }
}
