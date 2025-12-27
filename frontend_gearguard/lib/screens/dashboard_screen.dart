import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 PAGE TITLE
          const Text(
            "Dashboard",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 TOP ACTION BAR (NEW + SEARCH)
          Row(
            children: [
              // ✅ NEW BUTTON
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Open create maintenance request modal
                },
                icon: const Icon(Icons.add),
                label: const Text("New"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // ✅ SEARCH BAR
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // 🔹 DASHBOARD CARDS (PLACEHOLDERS AS PER FLOW)
          Row(
            children: const [
              _DashboardCard(
                title: "Critical Equipment",
                count: "4",
                color: Colors.red,
              ),
              SizedBox(width: 16),
              _DashboardCard(
                title: "Technician Load",
                count: "7",
                color: Colors.blue,
              ),
              SizedBox(width: 16),
              _DashboardCard(
                title: "Preventive Due",
                count: "3",
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
