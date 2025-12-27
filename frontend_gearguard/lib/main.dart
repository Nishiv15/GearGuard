import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/app_shell.dart';
import 'screens/dashboard_screen.dart';
import 'screens/maintenance_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GearGuard',
      debugShowCheckedModeBanner: false,

      // 🔐 START AT LOGIN
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),

        // 🏠 MAIN SHELL AFTER LOGIN
        '/app': (context) => const AppShell(),

        // 📊 INTERNAL NAV ROUTES
        '/dashboard': (context) => const DashboardScreen(),
        '/maintenance': (context) => const MaintenanceScreen(),
      },

      // 🚨 FALLBACK
      onUnknownRoute: (_) {
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      },
    );
  }
}
