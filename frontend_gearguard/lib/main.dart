import 'package:flutter/material.dart';
import 'widgets/navigation_widget.dart';
import 'widgets/footer_widget.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const TestLayoutScreen(),
    );
  }
}

class TestLayoutScreen extends StatelessWidget {
  const TestLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavigationWidget(),
      body: Center(
        child: Text(
          "Body Content Area",
          style: TextStyle(fontSize: 22),
        ),
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }
}
