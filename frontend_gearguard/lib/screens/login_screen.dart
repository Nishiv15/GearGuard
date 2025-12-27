import 'package:flutter/material.dart';
import '../widgets/navigation_widget.dart';
import '../widgets/auth_widget.dart';
import '../widgets/footer_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationWidget(
        showMenu: false,
        selectedIndex: 0,
        onItemTap: (_) {},
      ),
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: AuthWidget(),
          ),
        ),
      ),
      bottomNavigationBar: const FooterWidget(),
    );
  }
}