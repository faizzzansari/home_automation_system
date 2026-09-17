import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class BluetoothScanButtonWidget extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onScan;
  final int deviceCount;

  const BluetoothScanButtonWidget({
    super.key,
    required this.isScanning,
    required this.onScan,
    required this.deviceCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.cardColor.withOpacity(
          theme.brightness == Brightness.dark ? 0.88 : 0.96,
        ),
        border: Border.all(color: colorScheme.outline.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isScanning ? 'Scanning...' : 'Scan for Devices',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  deviceCount > 0
                      ? '$deviceCount device${deviceCount > 1 ? 's' : ''} found'
                      : 'Tap to discover nearby Bluetooth devices',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: isScanning ? null : onScan,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isScanning
                    ? colorScheme.secondary.withOpacity(0.18)
                    : colorScheme.secondary,
                boxShadow: isScanning
                    ? []
                    : [
                        BoxShadow(
                          color: colorScheme.secondary.withOpacity(0.25),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
              ),
              child: Center(
                child: isScanning
                    ? SizedBox(
                        width: 6.w,
                        height: 6.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.secondary,
                          ),
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'bluetooth_searching_rounded',
                        color: Colors.white,
                        size: 6.w,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
