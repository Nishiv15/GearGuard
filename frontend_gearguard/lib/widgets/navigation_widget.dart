import 'package:flutter/material.dart';

class NavigationWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final bool showMenu;
  final int? selectedIndex;
  final Function(int)? onItemTap;

  const NavigationWidget({
    super.key,
    this.showMenu = true,
    this.selectedIndex,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: const Text(
        "GearGuard",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: showMenu ? _menuItems() : [],
    );
  }

  List<Widget> _menuItems() {
    return [
      _navItem("Dashboard", 0),
      _navItem("Maintenance", 1),
      _navItem("Calendar", -1),
      _navItem("Equipment", -1),
      _navItem("Reporting", -1),
      _navItem("Teams", -1),
      const SizedBox(width: 12),
      const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: Colors.black),
      ),
      const SizedBox(width: 16),
    ];
  }

  Widget _navItem(String title, int index) {
    return TextButton(
      onPressed: index == -1 ? null : () => onItemTap?.call(index),
      child: Text(
        title,
        style: TextStyle(
          color: index == selectedIndex
              ? Colors.white
              : Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
