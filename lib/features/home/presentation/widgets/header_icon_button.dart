import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final String? tooltip;
  final VoidCallback onPressed;

  const HeaderIconButton({
    super.key,
    required this.icon,
    required this.background,
    required this.onPressed,
    this.iconColor = Colors.white,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 24.r),
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.all(10.r),
        constraints: BoxConstraints(minWidth: 44.r, minHeight: 44.r),
      ),
    );
  }
}
