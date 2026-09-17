import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/device_card_widget.dart';

class HomeScreenInitialPage extends StatefulWidget {
  const HomeScreenInitialPage({super.key});

  @override
  State<HomeScreenInitialPage> createState() => _HomeScreenInitialPageState();
}

class _HomeScreenInitialPageState extends State<HomeScreenInitialPage>
    with SingleTickerProviderStateMixin {
  bool _isRefreshing = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFF0EA5E9);
  static const Color successColor = Color(0xFF10B981);

  final List<Map<String, dynamic>> _devices = [
    {
      'id': 1,
      'name': 'Tube Light',
      'iconName': 'light_outlined',
      'isOn': false,
      'color': const Color(0xFF6366F1),
    },
    {
      'id': 2,
      'name': 'Bulb 1',
      'iconName': 'lightbulb_outline',
      'isOn': true,
      'color': const Color(0xFF0EA5E9),
    },
    {
      'id': 3,
      'name': 'Bulb 2',
      'iconName': 'lightbulb_outline',
      'isOn': false,
      'color': const Color(0xFF10B981),
    },
    {
      'id': 4,
      'name': 'Fan',
      'iconName': 'air',
      'isOn': true,
      'color': const Color(0xFFF59E0B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  void _toggleDevice(int id) {
    HapticFeedback.lightImpact();
    setState(() {
      final idx = _devices.indexWhere((d) => d['id'] == id);
      if (idx != -1) {
        _devices[idx]['isOn'] = !(_devices[idx]['isOn'] as bool);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final activeCount = _devices.where((d) => d['isOn'] as bool).length;

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
            onPressed: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed('/bluetooth-connection-screen'),
            tooltip: 'Bluetooth Setup',
          ),
          SizedBox(width: 1.w),
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
              top: -5.h,
              left: -8.w,
              child: Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primaryColor.withOpacity(isDark ? 0.14 : 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8.h,
              right: -6.w,
              child: Container(
                width: 35.w,
                height: 35.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      secondaryColor.withOpacity(isDark ? 0.12 : 0.06),
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
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: primaryColor,
                    backgroundColor: theme.cardColor,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.cardColor.withOpacity(
                                    isDark ? 0.84 : 0.96,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: colorScheme.outline.withOpacity(
                                      0.45,
                                    ),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                        isDark ? 0.16 : 0.05,
                                      ),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (bounds) =>
                                              const LinearGradient(
                                                colors: [
                                                  primaryColor,
                                                  secondaryColor,
                                                ],
                                              ).createShader(bounds),
                                          child: Text(
                                            '$activeCount / ${_devices.length}',
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          'Devices Active',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            primaryColor.withOpacity(0.12),
                                            secondaryColor.withOpacity(0.10),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: CustomIconWidget(
                                        iconName: 'devices_rounded',
                                        color: primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.2.h),
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [primaryColor, secondaryColor],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.5.w),
                                  Text(
                                    'My Devices',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    child: Container(
                                      key: ValueKey(activeCount),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                        vertical: 0.7.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: successColor.withOpacity(0.10),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '$activeCount active',
                                        style: TextStyle(
                                          color: successColor,
                                          fontSize: 10.5.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4.w,
                                mainAxisSpacing: 2.h,
                                childAspectRatio: 0.90,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final device = _devices[index];
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(
                                milliseconds: 300 + index * 80,
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
                                iconName: device['iconName'] as String,
                                isOn: device['isOn'] as bool,
                                accentColor: device['color'] as Color,
                                onToggle: (bool value) =>
                                    _toggleDevice(device['id'] as int),
                              ),
                            );
                          }, childCount: _devices.length),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 2.h)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
