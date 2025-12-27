import 'package:flutter/material.dart';
import '../widgets/navigation_widget.dart';
import '../widgets/auth_widget.dart';
import '../widgets/footer_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavigationWidget(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: AuthWidget(), // Auth UI here
          ),
        ),
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }
}
