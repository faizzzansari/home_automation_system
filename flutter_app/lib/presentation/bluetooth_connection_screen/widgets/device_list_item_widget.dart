import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class DeviceListItemWidget extends StatelessWidget {
  final Map<String, dynamic> device;
  final bool isConnecting;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const DeviceListItemWidget({
    super.key,
    required this.device,
    required this.isConnecting,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isConnected = device['isConnected'] == true;
    final int signalStrength = device['signal'] is int ? device['signal'] : 0;
    final String name = device['name']?.toString() ?? 'Unknown Device';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(
          theme.brightness == Brightness.dark ? 0.88 : 0.96,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConnected
              ? Colors.green.withOpacity(0.35)
              : colorScheme.outline.withOpacity(0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? 0.14 : 0.05,
            ),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 11.w,
            height: 11.w,
            decoration: BoxDecoration(
              color: isConnected
                  ? Colors.green.withOpacity(0.12)
                  : colorScheme.secondary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'bluetooth_rounded',
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
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 0.4.h),
                Row(
                  children: [
                    _buildSignalIcon(signalStrength),
                    SizedBox(width: 1.2.w),
                    Text(
                      _signalLabel(signalStrength),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isConnected) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.35.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Connected',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          isConnecting
              ? SizedBox(
                  width: 5.8.w,
                  height: 5.8.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.secondary,
                  ),
                )
              : isConnected
              ? TextButton(
                  onPressed: onDisconnect,
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 0.9.h,
                    ),
                    minimumSize: Size(0, 5.5.h),
                  ),
                  child: Text('Disconnect', style: TextStyle(fontSize: 10.sp)),
                )
              : ElevatedButton(
                  onPressed: onConnect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.5.w,
                      vertical: 0.9.h,
                    ),
                    minimumSize: Size(0, 5.5.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Connect', style: TextStyle(fontSize: 10.sp)),
                ),
        ],
      ),
    );
  }

  Widget _buildSignalIcon(int strength) {
    final color = strength > 70
        ? Colors.green
        : strength > 40
        ? Colors.orange
        : Colors.red;

    return CustomIconWidget(
      iconName: strength > 70
          ? 'signal_wifi_4_bar'
          : strength > 40
          ? 'network_wifi_2_bar'
          : 'network_wifi_1_bar',
      color: color,
      size: 4.2.w,
    );
  }

  String _signalLabel(int strength) {
    if (strength > 70) return 'Strong';
    if (strength > 40) return 'Medium';
    return 'Weak';
  }
}
