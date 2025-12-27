import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class NavigationWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Text(
        "GearGuard",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        _navButton(context, "Dashboard", "/app"),
        _navButton(context, "Maintenance", "/maintenance"),

        const SizedBox(width: 12),

        // 🔐 AVATAR DROPDOWN
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'users':
                Navigator.pushNamed(context, '/users');
                break;
              case 'change_password':
                Navigator.pushNamed(context, '/change-password');
                break;
              case 'logout':
                AuthService.logout();
                Navigator.pushReplacementNamed(context, '/login');
                break;
            }
          },
          itemBuilder: (_) {
            final items = <PopupMenuEntry<String>>[];

            if (AuthService.isOwner || AuthService.isManager) {
              items.add(const PopupMenuItem(
                value: 'users',
                child: Text("Users"),
              ));
            } else {
              items.add(const PopupMenuItem(
                value: 'change_password',
                child: Text("Change Password"),
              ));
            }

            items.add(const PopupMenuDivider());
            items.add(const PopupMenuItem(
              value: 'logout',
              child: Text("Logout"),
            ));

            return items;
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navButton(BuildContext context, String title, String route) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
