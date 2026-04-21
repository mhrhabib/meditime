import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';

class NextDoseBanner extends StatefulWidget {
  final Medicine medicine;
  final DateTime scheduledDateTime;
  final VoidCallback onTake;

  const NextDoseBanner({
    super.key,
    required this.medicine,
    required this.scheduledDateTime,
    required this.onTake,
  });

  @override
  State<NextDoseBanner> createState() => _NextDoseBannerState();
}

class _NextDoseBannerState extends State<NextDoseBanner> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _countdownLabel() {
    final diff = widget.scheduledDateTime.difference(DateTime.now());
    if (diff.isNegative) return 'now';
    final minutes = diff.inMinutes;
    if (minutes < 1) return 'in under a minute';
    if (minutes < 60) return 'in $minutes min';
    final hours = diff.inHours;
    final remMin = minutes - hours * 60;
    if (remMin == 0) return 'in $hours hr';
    return 'in $hours hr $remMin min';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final time = TimeOfDay.fromDateTime(widget.scheduledDateTime).format(context);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primary,
            cs.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.25),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_rounded,
                  color: Colors.white.withValues(alpha: 0.9), size: 20.r),
              SizedBox(width: 6.w),
              Text(
                'Next dose $time · ${_countdownLabel()}',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            widget.medicine.name,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 52.h,
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.onTake,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: cs.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              icon: Icon(Icons.check_rounded, size: 24.r),
              label: Text(
                'TAKE NOW',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
