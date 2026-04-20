import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarStrip extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  const CalendarStrip({super.key, required this.onDateSelected});

  @override
  State<CalendarStrip> createState() => _CalendarStripState();
}

class _CalendarStripState extends State<CalendarStrip> {
  DateTime _selectedDate = DateTime.now();
  late final ScrollController _scrollController;

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          3 * 80.w,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final days = List.generate(
      14,
      (i) => today.subtract(const Duration(days: 3)).add(Duration(days: i)),
    );

    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected = DateUtils.isSameDay(date, _selectedDate);
          final isToday = DateUtils.isSameDay(date, today);

          return GestureDetector(
            onTap: () {
              setState(() => _selectedDate = date);
              widget.onDateSelected(date);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 68.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: isSelected ? cs.primary : cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? cs.primary
                      : (isToday
                          ? cs.primary.withValues(alpha: 0.5)
                          : cs.outlineVariant.withValues(alpha: 0.4)),
                  width: isToday && !isSelected ? 2.w : 1.w,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.3),
                          blurRadius: 10.r,
                          offset: Offset(0, 4.h),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdays[date.weekday - 1],
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.9)
                          : cs.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : cs.onSurface,
                      height: 1,
                    ),
                  ),
                  if (isToday && !isSelected) ...[
                    SizedBox(height: 4.h),
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
