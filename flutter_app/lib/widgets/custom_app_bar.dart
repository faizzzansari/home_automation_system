import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant { home, bluetooth, splash }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CustomAppBarVariant variant;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.variant = CustomAppBarVariant.home,
    this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBackPressed,
  });

  static const Color _homeAccent = Color(0xFF6366F1);
  static const Color _bluetoothAccent = Color(0xFF0EA5E9);

  @override
  Size get preferredSize => const Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.appBarTheme.backgroundColor ?? colorScheme.surface;
    final titleColor = colorScheme.onSurface;
    final subtitleColor = colorScheme.onSurfaceVariant;
    final borderColor = colorScheme.outline.withOpacity(0.5);
    final actionBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

    return AppBar(
      backgroundColor: bgColor,
      surfaceTintColor: bgColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: titleColor,
                size: 20,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : leading,
      titleSpacing: 16,
      title: _buildTitle(context, titleColor: titleColor, isDark: isDark),
      actions: _buildActions(
        context,
        actionBg: actionBg,
        borderColor: borderColor,
        subtitleColor: subtitleColor,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: borderColor),
      ),
    );
  }

  Widget? _buildTitle(
    BuildContext context, {
    required Color titleColor,
    required bool isDark,
  }) {
    switch (variant) {
      case CustomAppBarVariant.home:
        return Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _homeAccent.withOpacity(isDark ? 0.22 : 0.14),
                    _bluetoothAccent.withOpacity(isDark ? 0.18 : 0.10),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.home_rounded,
                color: _homeAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title ?? 'Smart Home',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        );

      case CustomAppBarVariant.bluetooth:
        return Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _bluetoothAccent.withOpacity(isDark ? 0.18 : 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.bluetooth_rounded,
                color: _bluetoothAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title ?? 'Bluetooth Setup',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        );

      case CustomAppBarVariant.splash:
        return null;
    }
  }

  List<Widget>? _buildActions(
    BuildContext context, {
    required Color actionBg,
    required Color borderColor,
    required Color subtitleColor,
  }) {
    if (actions != null) return actions;

    switch (variant) {
      case CustomAppBarVariant.home:
        return [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: actionBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: IconButton(
              icon: Icon(
                Icons.bluetooth_searching_rounded,
                color: subtitleColor,
                size: 22,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, '/bluetooth-connection-screen'),
              tooltip: 'Bluetooth Setup',
            ),
          ),
          const SizedBox(width: 8),
        ];

      case CustomAppBarVariant.bluetooth:
        return [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: actionBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: IconButton(
              icon: Icon(Icons.close_rounded, color: subtitleColor, size: 22),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Close',
            ),
          ),
          const SizedBox(width: 8),
        ];

      case CustomAppBarVariant.splash:
        return null;
    }
  }
}
