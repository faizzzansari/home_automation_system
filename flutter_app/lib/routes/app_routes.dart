import 'package:flutter/material.dart';
import '../presentation/bluetooth_connection_screen/bluetooth_connection_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_screen/home_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String bluetoothConnection = '/bluetooth-connection-screen';
  static const String splash = '/splash-screen';
  static const String home = '/home-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    bluetoothConnection: (context) => const BluetoothConnectionScreen(),
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    // TODO: Add your other routes here
  };
}
