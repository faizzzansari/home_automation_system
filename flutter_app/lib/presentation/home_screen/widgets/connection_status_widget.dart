import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ConnectionStatusWidget extends StatefulWidget {
  final bool isCloudMode;

  const ConnectionStatusWidget({super.key, required this.isCloudMode});

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.65,
      end: 1.0,
    ).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color dotColor = widget.isCloudMode
        ? const Color(0xFF10B981)
        : const Color(0xFF0EA5E9);

    final String label = widget.isCloudMode ? 'Cloud Mode' : 'Bluetooth Mode';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.6.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: dotColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _pulseAnimation,
            child: Container(
              width: 2.2.w,
              height: 2.2.w,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: dotColor.withOpacity(0.35),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 1.6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.8.sp,
              color: dotColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
