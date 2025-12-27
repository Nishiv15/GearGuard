import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.black,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "© 2025 GearGuard",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 24),
          Text(
            "Privacy Policy",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 16),
          Text(
            "Terms of Service",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
