class DonationEntity {
  final String id;
  final String donorId;
  final String donorName;
  final String bloodType;
  final int units;
  final String hospitalId;
  final String hospitalName;
  final String patientName;
  final DateTime date;
  final String certificateCode;
  final String status; 

  const DonationEntity({
    required this.id,
    required this.donorId,
    required this.donorName,
    required this.bloodType,
    required this.units,
    required this.hospitalId,
    required this.hospitalName,
    required this.patientName,
    required this.date,
    required this.certificateCode,
    required this.status,
  });
}
