import 'package:flutter/material.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Maintenance Requests",
              style:
                  TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: const [
                _Column("New"),
                _Column("In Progress"),
                _Column("Repaired"),
                _Column("Scrap"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Column extends StatelessWidget {
  final String title;
  const _Column(this.title);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Text(title,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Expanded(
                child: Center(child: Text("No Requests")))
          ],
        ),
      ),
    );
  }
}
