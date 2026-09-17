import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/device_card_widget.dart';
import '../../core/services/bluetooth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const Color primaryPurple = Color(0xFF6C63FF);
  static const Color softBlue = Color(0xFF4A90E2);
  static const Color mint = Color(0xFF2EC4B6);
  static const Color amber = Color(0xFFFFB547);

  final List<Map<String, dynamic>> _devices = [
    {
      'id': 1,
      'name': 'Tube Light',
      'icon': 'light_outlined',
      'isOn': false,
      'color': const Color(0xFF6C63FF),
    },
    {
      'id': 2,
      'name': 'Bulb 1',
      'icon': 'lightbulb_outline',
      'isOn': false,
      'color': const Color(0xFF4A90E2),
    },
    {
      'id': 3,
      'name': 'Bulb 2',
      'icon': 'lightbulb',
      'isOn': false,
      'color': const Color(0xFF2EC4B6),
    },
    {
      'id': 4,
      'name': 'Fan',
      'icon': 'air',
      'isOn': false,
      'color': const Color(0xFFFFB547),
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _toggleDevice(int index, bool value) {
    debugPrint("Bluetooth Connected: ${BluetoothService().isConnected}");
    setState(() {
      _devices[index]['isOn'] = value;
    });

    if (BluetoothService().isConnected) {
      final deviceId = _devices[index]['id'];

      if (deviceId == 1) {
        BluetoothService().sendCommand(value ? "ON1\n" : "OFF1\n");
      } else if (deviceId == 2) {
        BluetoothService().sendCommand(value ? "ON2\n" : "OFF2\n");
      } else if (deviceId == 3) {
        BluetoothService().sendCommand(value ? "ON3\n" : "OFF3\n");
      } else if (deviceId == 4) {
        BluetoothService().sendCommand(value ? "ON4\n" : "OFF4\n");
      }
    }
  }

  int get _activeDevicesCount =>
      _devices.where((d) => d['isOn'] as bool).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.home,
        title: 'Smart Home',
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'bluetooth_searching_rounded',
              color: colorScheme.onSurfaceVariant,
              size: 22,
            ),
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/bluetooth-connection-screen');
            },
            tooltip: 'Bluetooth Setup',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
                    Color(0xFF0F172A),
                    Color(0xFF111827),
                    Color(0xFF0B1220),
                    Color(0xFF0F172A),
                  ]
                : const [
                    Color(0xFFF8FAFC),
                    Color(0xFFF1F5F9),
                    Color(0xFFEEF4FF),
                    Color(0xFFF8FAFC),
                  ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -8.h,
              left: -10.w,
              child: Container(
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primaryPurple.withOpacity(isDark ? 0.14 : 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10.h,
              right: -8.w,
              child: Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      softBlue.withOpacity(isDark ? 0.12 : 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow(theme),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [primaryPurple, softBlue],
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'My Devices',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 3.w,
                                mainAxisSpacing: 2.h,
                                childAspectRatio: 1.0,
                              ),
                          itemCount: _devices.length,
                          itemBuilder: (context, index) {
                            final device = _devices[index];
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(
                                milliseconds: 400 + index * 100,
                              ),
                              curve: Curves.easeOutBack,
                              builder: (context, value, child) =>
                                  Transform.scale(
                                    scale: value,
                                    child: Opacity(
                                      opacity: value.clamp(0.0, 1.0),
                                      child: child,
                                    ),
                                  ),
                              child: DeviceCardWidget(
                                deviceName: device['name'] as String,
                                iconName: device['icon'] as String,
                                isOn: device['isOn'] as bool,
                                accentColor: device['color'] as Color,
                                onToggle: (value) =>
                                    _toggleDevice(index, value),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.9.h),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(isDark ? 0.84 : 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.45),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.18 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [primaryPurple, softBlue],
                ).createShader(bounds),
                child: Text(
                  '$_activeDevicesCount / ${_devices.length}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Devices Active',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryPurple.withOpacity(0.12),
                  softBlue.withOpacity(0.10),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: CustomIconWidget(
              iconName: 'devices_rounded',
              color: primaryPurple,
              size: 7.w,
            ),
          ),
        ],
      ),
    );
  }
}
