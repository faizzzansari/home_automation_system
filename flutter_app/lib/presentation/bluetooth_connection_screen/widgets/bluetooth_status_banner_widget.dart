import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class BluetoothStatusBannerWidget extends StatelessWidget {
  final bool isConnected;
  final String? connectedDeviceName;
  final VoidCallback onDisconnect;

  const BluetoothStatusBannerWidget({
    super.key,
    required this.isConnected,
    this.connectedDeviceName,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isConnected
            ? Colors.green.withOpacity(0.10)
            : theme.cardColor.withOpacity(
                theme.brightness == Brightness.dark ? 0.82 : 0.95,
              ),
        border: Border.all(
          color: isConnected
              ? Colors.green.withOpacity(0.35)
              : colorScheme.outline.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected
                  ? Colors.green.withOpacity(0.12)
                  : colorScheme.secondary.withOpacity(0.10),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: isConnected
                    ? 'bluetooth_connected_rounded'
                    : 'bluetooth_disabled_rounded',
                color: isConnected ? Colors.green : colorScheme.secondary,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConnected ? 'Connected' : 'Not Connected',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isConnected ? Colors.green : colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isConnected && connectedDeviceName != null)
                  Text(
                    connectedDeviceName!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                if (!isConnected)
                  Text(
                    'Scan and connect to a device',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
