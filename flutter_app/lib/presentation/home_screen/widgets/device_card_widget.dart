import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class DeviceCardWidget extends StatefulWidget {
  final String deviceName;
  final String iconName;
  final bool isOn;
  final Color accentColor;
  final ValueChanged<bool> onToggle;

  const DeviceCardWidget({
    super.key,
    this.deviceName = 'Device',
    this.iconName = 'devices',
    this.isOn = false,
    required this.accentColor,
    required this.onToggle,
  });

  @override
  State<DeviceCardWidget> createState() => _DeviceCardWidgetState();
}

class _DeviceCardWidgetState extends State<DeviceCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _pulseAnimation = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    if (widget.isOn) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant DeviceCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOn && !oldWidget.isOn) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isOn && oldWidget.isOn) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Stack(
              children: [
                if (widget.isOn)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, _) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: widget.accentColor.withOpacity(
                                  0.16 * _pulseAnimation.value,
                                ),
                                blurRadius: 24,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(3.5.w),
                  decoration: BoxDecoration(
                    color: theme.cardColor.withOpacity(isDark ? 0.88 : 0.98),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: widget.isOn
                          ? widget.accentColor.withOpacity(0.24)
                          : colorScheme.outline.withOpacity(0.45),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.16 : 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    gradient: widget.isOn
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.accentColor.withOpacity(
                                isDark ? 0.18 : 0.10,
                              ),
                              theme.cardColor.withOpacity(isDark ? 0.92 : 1.0),
                            ],
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 13.w,
                            height: 13.w,
                            decoration: BoxDecoration(
                              color: widget.isOn
                                  ? widget.accentColor.withOpacity(0.12)
                                  : (isDark
                                        ? Colors.white.withOpacity(0.06)
                                        : const Color(0xFFF1F5F9)),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: widget.iconName,
                                color: widget.isOn
                                    ? widget.accentColor
                                    : colorScheme.onSurfaceVariant,
                                size: 6.2.w,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Transform.scale(
                            scale: 0.82,
                            child: Switch(
                              value: widget.isOn,
                              onChanged: (val) {
                                HapticFeedback.lightImpact();
                                widget.onToggle(val);
                              },
                              activeColor: widget.accentColor,
                              activeTrackColor: widget.accentColor.withOpacity(
                                0.35,
                              ),
                              inactiveThumbColor: isDark
                                  ? colorScheme.onSurfaceVariant
                                  : Colors.white,
                              inactiveTrackColor: colorScheme.outline
                                  .withOpacity(0.55),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        widget.deviceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.8.sp,
                        ),
                      ),
                      SizedBox(height: 0.7.h),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.isOn
                                  ? widget.accentColor
                                  : colorScheme.onSurfaceVariant.withOpacity(
                                      0.5,
                                    ),
                            ),
                          ),
                          SizedBox(width: 1.5.w),
                          Text(
                            widget.isOn ? 'Active' : 'Off',
                            style: TextStyle(
                              color: widget.isOn
                                  ? widget.accentColor
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.5.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
