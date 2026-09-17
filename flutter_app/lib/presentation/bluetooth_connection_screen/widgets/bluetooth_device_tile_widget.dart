import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class BluetoothDeviceTileWidget extends StatelessWidget {
  final Map<String, dynamic> device;
  final bool isConnected;
  final String signalStrength;
  final VoidCallback onConnect;

  const BluetoothDeviceTileWidget({
    super.key,
    required this.device,
    required this.isConnected,
    required this.signalStrength,
    required this.onConnect,
  });

  String _iconForType(String type) {
    switch (type) {
      case 'hub':
        return 'router';
      case 'light':
        return 'lightbulb_outline';
      case 'fan':
        return 'air';
      default:
        return 'devices_other';
    }
  }

  Color _signalColor(String strength) {
    switch (strength) {
      case 'Strong':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String type = device['type'] as String;
    final String name = device['name'] as String;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(
          theme.brightness == Brightness.dark ? 0.88 : 0.96,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isConnected
              ? colorScheme.secondary.withOpacity(0.35)
              : colorScheme.outline.withOpacity(0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? 0.14 : 0.04,
            ),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: isConnected
                    ? colorScheme.secondary.withOpacity(0.12)
                    : colorScheme.secondary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _iconForType(type),
                  color: isConnected
                      ? colorScheme.secondary
                      : colorScheme.onSurfaceVariant,
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
                  SizedBox(height: 0.3.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'signal_cellular_alt',
                        color: _signalColor(signalStrength),
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        signalStrength,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _signalColor(signalStrength),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            ElevatedButton(
              onPressed: onConnect,
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnected
                    ? colorScheme.error
                    : colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                minimumSize: Size(16.w, 4.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isConnected ? 'Disconnect' : 'Connect',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
