import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onScanAgain;

  const EmptyStateWidget({super.key, required this.onScanAgain});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'bluetooth_disabled',
                  color: colorScheme.secondary,
                  size: 11.w,
                ),
              ),
            ),
            SizedBox(height: 2.8.h),
            Text(
              'No devices found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Make sure your Bluetooth devices are powered on and nearby.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            SizedBox(height: 3.h),
            OutlinedButton.icon(
              onPressed: onScanAgain,
              icon: CustomIconWidget(
                iconName: 'refresh_rounded',
                color: colorScheme.secondary,
                size: 5.w,
              ),
              label: const Text('Scan Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.secondary,
                side: BorderSide(color: colorScheme.secondary),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.4.h),
                minimumSize: Size(0, 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
