import 'package:flutter/material.dart';
import 'widgets/auth_widget.dart';

void main() {
  runApp(const GearGuardApp());
}

class GearGuardApp extends StatelessWidget {
  const GearGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GearGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: AuthWidget(),
      ),
    );
  }
}
