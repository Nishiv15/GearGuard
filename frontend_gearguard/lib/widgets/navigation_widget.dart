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
      actions: [
        if (showMenu) ..._menuItems(),
        const SizedBox(width: 8),
        _profileMenu(context),
        const SizedBox(width: 16),
      ],
    );
  }

  /// 🔹 NAVIGATION ITEMS
  List<Widget> _menuItems() {
    return [
      _navItem("Dashboard", 0),
      _navItem("Maintenance", 1),
      _navItem("Calendar", -1),
      _navItem("Equipment", -1),
      _navItem("Reporting", -1),
      _navItem("Teams", -1),
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

  /// 👤 AVATAR WITH LOGOUT DROPDOWN
  Widget _profileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under, // ✅ below avatar
      offset: const Offset(0, 8), // ✅ spacing
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onSelected: (value) {
        if (value == 'logout') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
        }
      },
      icon: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.person,
          color: Colors.black,
        ),
      ),
      itemBuilder: (context) => const [
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 18),
              SizedBox(width: 8),
              Text("Logout"),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
