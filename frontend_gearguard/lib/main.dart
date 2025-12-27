import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/app_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GearGuard',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/app': (context) => const AppShell(),
      },
    );
  }
}
