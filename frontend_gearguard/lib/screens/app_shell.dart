import 'package:flutter/material.dart';
import '../widgets/navigation_widget.dart';
import '../widgets/footer_widget.dart';
import 'dashboard_screen.dart';
import 'maintenance_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardScreen(),
    MaintenanceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationWidget(
        showMenu: true,
        selectedIndex: selectedIndex,
        onItemTap: (i) => setState(() => selectedIndex = i),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: const FooterWidget(), // ✅ Footer added
    );
  }
}
