class BloodRequestEntity {
  final String id;
  final String patientName;
  final String hospitalName;
  final String bloodType;
  final int unitsRequired;
  final double latitude;
  final double longitude;
  final String patientPhone;
  final String urgency; 
  final String status; 
  final String createdById;
  final DateTime createdAt;
  final String? acceptedById;
  final DateTime? acceptedAt;

  const BloodRequestEntity({
    required this.id,
    required this.patientName,
    required this.hospitalName,
    required this.bloodType,
    required this.unitsRequired,
    required this.latitude,
    required this.longitude,
    required this.patientPhone,
    required this.urgency,
    required this.status,
    required this.createdById,
    required this.createdAt,
    this.acceptedById,
    this.acceptedAt,
  });

  bool get isUrgent => urgency == 'URGENT' || urgency == 'IMMEDIATE';
  bool get isOpen => status == 'OPEN';
  bool get isInProgress => status == 'IN_PROGRESS';
  bool get isCompleted => status == 'COMPLETED';
}
