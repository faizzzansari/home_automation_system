import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './presentation/bluetooth_connection_screen/bluetooth_connection_screen.dart';
import './presentation/home_screen/home_screen.dart';
import './presentation/splash_screen/splash_screen.dart';
import './theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Smart Home Controller',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: '/splash-screen',
          routes: {
            '/splash-screen': (context) => const SplashScreen(),
            '/home-screen': (context) => const HomeScreen(),
            '/bluetooth-connection-screen': (context) =>
                const BluetoothConnectionScreen(),
          },
        );
      },
    );
  }
}
