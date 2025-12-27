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
