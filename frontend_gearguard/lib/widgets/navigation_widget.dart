import 'package:flutter/material.dart';

class NavigationWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black, // ✅ Black navbar
      elevation: 0,
      title: const Text(
        "GearGuard",
        style: TextStyle(
          color: Colors.white, // ✅ White text
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white, // ✅ White icons
      ),
      actions: [
        _navItem("Dashboard"),
        _navItem("Equipment"),
        _navItem("Maintenance"),
        _navItem("Calendar"),
        const SizedBox(width: 12),
        const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: Colors.black),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _navItem(String title) {
    return TextButton(
      onPressed: () {},
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white, // ✅ White menu text
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
