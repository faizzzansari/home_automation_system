import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class ScanButtonWidget extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onScan;

  const ScanButtonWidget({
    super.key,
    required this.isScanning,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton.icon(
        onPressed: isScanning ? null : onScan,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          disabledBackgroundColor: colorScheme.secondary.withOpacity(0.5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: isScanning
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : CustomIconWidget(
                iconName: 'bluetooth_searching',
                color: Colors.white,
                size: 5.w,
              ),
        label: Text(
          isScanning ? 'Scanning...' : 'Scan for Devices',
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
