import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../../domain/entities/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: false,
        backgroundColor: cs.surface,
        elevation: 0,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded && state.notifications.isNotEmpty) {
                return TextButton(
                  onPressed: () => context.read<NotificationCubit>().clearAll(),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationError) {
            return Center(child: Text(state.message));
          } else if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return _buildEmptyState(context);
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return _NotificationTile(notification: notification);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 64.r,
              color: cs.primary,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              'When you get reminders or alerts, they will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final timeStr = DateFormat('MMM d, h:mm a').format(notification.timestamp);

    return InkWell(
      onTap: () {
        context.read<NotificationCubit>().markRead(notification.id);
        // Handle payload if needed
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: notification.isRead
              ? cs.surfaceContainerLow
              : cs.primaryContainer.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: notification.isRead
                ? cs.outlineVariant.withValues(alpha: 0.3)
                : cs.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: _getIconBackground(cs),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(),
                size: 20.r,
                color: _getIconColor(cs),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16.sp,
                            fontWeight: notification.isRead
                                ? FontWeight.w700
                                : FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: cs.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (notification.type) {
      case 'reminder':
        return Icons.alarm_rounded;
      case 'alert':
        return Icons.warning_amber_rounded;
      case 'refill':
        return Icons.replay_circle_filled_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getIconColor(ColorScheme cs) {
    switch (notification.type) {
      case 'reminder':
        return Colors.blue.shade700;
      case 'alert':
        return Colors.red.shade700;
      case 'refill':
        return Colors.orange.shade700;
      default:
        return cs.primary;
    }
  }

  Color _getIconBackground(ColorScheme cs) {
    switch (notification.type) {
      case 'reminder':
        return Colors.blue.withValues(alpha: 0.12);
      case 'alert':
        return Colors.red.withValues(alpha: 0.12);
      case 'refill':
        return Colors.orange.withValues(alpha: 0.12);
      default:
        return cs.primaryContainer.withValues(alpha: 0.4);
    }
  }
}
