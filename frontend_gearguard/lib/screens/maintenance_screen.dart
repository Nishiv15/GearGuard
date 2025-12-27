import 'package:flutter/material.dart';

/// ===================== STATUS =====================
enum MaintenanceStatus {
  inProgress,
  blocked,
  ready,
}

/// ===================== MODEL =====================
class MaintenanceRequest {
  final String subject;
  final String createdBy;
  final String maintenanceFor;
  final String target;
  final String category;
  final String requestDate;
  final String maintenanceType;
  final String team;
  final String technician;
  final String scheduledDate;
  final String duration;
  final int priority;
  final String company;
  final String notes;
  final String instructions;
  final MaintenanceStatus status;

  MaintenanceRequest({
    required this.subject,
    required this.createdBy,
    required this.maintenanceFor,
    required this.target,
    required this.category,
    required this.requestDate,
    required this.maintenanceType,
    required this.team,
    required this.technician,
    required this.scheduledDate,
    required this.duration,
    required this.priority,
    required this.company,
    required this.notes,
    required this.instructions,
    required this.status,
  });
}

/// ===================== SCREEN =====================
class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<MaintenanceRequest> requests = [];

  void _openNewRequestDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _NewRequestDialog(
        onSubmit: (req) {
          setState(() => requests.add(req));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              const Text(
                "Maintenance Requests",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _openNewRequestDialog,
                icon: const Icon(Icons.add),
                label: const Text("New"),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // LIST
          Expanded(
            child: requests.isEmpty
                ? const Center(
                    child: Text(
                      "No maintenance requests yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (_, i) =>
                        _requestCard(requests[i]),
                  ),
          ),
        ],
      ),
    );
  }

  /// ===================== CARD WITH STATUS SIGNAL =====================
  Widget _requestCard(MaintenanceRequest r) {
    final statusColor = _statusColor(r.status);
    final statusText = _statusText(r.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Subject",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),

              // SUBJECT
              Text(
                r.subject,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // META + PRIORITY
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${r.maintenanceFor} • ${r.target} • ${r.category}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      3,
                      (i) => Icon(
                        Icons.diamond,
                        size: 18,
                        color: r.priority >= i + 1
                            ? Colors.black
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // STATUS SIGNAL (TOP RIGHT)
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  statusText,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(MaintenanceStatus status) {
    switch (status) {
      case MaintenanceStatus.inProgress:
        return Colors.blue;
      case MaintenanceStatus.blocked:
        return Colors.red;
      case MaintenanceStatus.ready:
        return Colors.green;
    }
  }

  String _statusText(MaintenanceStatus status) {
    switch (status) {
      case MaintenanceStatus.inProgress:
        return "In Progress";
      case MaintenanceStatus.blocked:
        return "Blocked";
      case MaintenanceStatus.ready:
        return "Ready";
    }
  }
}

/// ===================== NEW REQUEST DIALOG =====================
class _NewRequestDialog extends StatefulWidget {
  final Function(MaintenanceRequest) onSubmit;

  const _NewRequestDialog({required this.onSubmit});

  @override
  State<_NewRequestDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<_NewRequestDialog> {
  final subjectCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final instructionsCtrl = TextEditingController();

  String maintenanceFor = "Equipment";
  String target = "Acer Laptop";
  String maintenanceType = "Corrective";
  int priority = 2;

  final String createdBy = "Mitchell Admin";
  final String team = "Internal Maintenance";
  final String technician = "Aka Foster";
  final String company = "My Company (San Francisco)";

  void _submit() {
    widget.onSubmit(
      MaintenanceRequest(
        subject: subjectCtrl.text,
        createdBy: createdBy,
        maintenanceFor: maintenanceFor,
        target: target,
        category:
            maintenanceFor == "Equipment" ? "Computers" : "Work Center",
        requestDate: "12/18/2025",
        maintenanceType: maintenanceType,
        team: team,
        technician: technician,
        scheduledDate: "12/28/2025 14:30",
        duration: "00:00 hours",
        priority: priority,
        company: company,
        notes: notesCtrl.text,
        instructions: instructionsCtrl.text,

        // 🔹 DEFAULT STATUS
        status: MaintenanceStatus.inProgress,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Maintenance Request"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _input("Subject", subjectCtrl),

            _readOnly("Created By", createdBy),

            _dropdown(
              "Maintenance For",
              ["Equipment", "Work Center"],
              maintenanceFor,
              (v) {
                setState(() {
                  maintenanceFor = v!;
                  target = maintenanceFor == "Equipment"
                      ? "Acer Laptop"
                      : "Assembly Line A";
                });
              },
            ),

            _dropdown(
              maintenanceFor == "Equipment"
                  ? "Equipment"
                  : "Work Center",
              maintenanceFor == "Equipment"
                  ? ["Acer Laptop", "HP Printer"]
                  : ["Assembly Line A", "Packing Unit B"],
              target,
              (v) => setState(() => target = v!),
            ),

            _readOnly(
              "Category",
              maintenanceFor == "Equipment"
                  ? "Computers"
                  : "Work Center",
            ),

            _readOnly("Request Date", "12/18/2025"),

            _radioMaintenanceType(),

            _readOnly("Team", team),
            _readOnly("Technician", technician),
            _readOnly("Scheduled Date", "12/28/2025 14:30"),
            _readOnly("Duration", "00:00 hours"),

            _priority(),

            _readOnly("Company", company),

            _input("Notes", notesCtrl, lines: 3),
            _input("Instructions", instructionsCtrl, lines: 3),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text("Submit"),
        ),
      ],
    );
  }

  // ===================== HELPERS =====================
  Widget _input(String label, TextEditingController c,
      {int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) =>
                DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _readOnly(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _radioMaintenanceType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Maintenance Type"),
        Row(
          children: [
            Radio<String>(
              value: "Corrective",
              groupValue: maintenanceType,
              onChanged: (v) =>
                  setState(() => maintenanceType = v!),
            ),
            const Text("Corrective"),
            Radio<String>(
              value: "Preventive",
              groupValue: maintenanceType,
              onChanged: (v) =>
                  setState(() => maintenanceType = v!),
            ),
            const Text("Preventive"),
          ],
        ),
      ],
    );
  }

  Widget _priority() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Priority"),
          const SizedBox(height: 6),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: List.generate(3, (i) {
                return GestureDetector(
                  onTap: () => setState(() => priority = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.diamond,
                      size: 22,
                      color: priority >= i + 1
                          ? Colors.black
                          : Colors.grey.shade300,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
