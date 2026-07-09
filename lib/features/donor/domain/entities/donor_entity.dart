class DonorEntity {
  final String id;
  final String userId;
  final String fullName;
  final String phone;
  final String bloodGroup;
  final int age;
  final String gender;
  final double weight;
  final String city;
  final double latitude;
  final double longitude;
  final bool medicalEligibility;
  final DateTime? lastDonationDate;
  final bool availabilityStatus;
  final String? profilePhoto;
  final int donationCount;
  final DateTime? nextEligibleDate;
  final double? distance;

  const DonorEntity({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.bloodGroup,
    required this.age,
    required this.gender,
    required this.weight,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.medicalEligibility,
    this.lastDonationDate,
    required this.availabilityStatus,
    this.profilePhoto,
    required this.donationCount,
    this.nextEligibleDate,
    this.distance,
  });

  
  int get daysUntilEligible {
    if (nextEligibleDate == null) return 0;
    final difference = nextEligibleDate!.difference(DateTime.now()).inDays;
    return difference > 0 ? difference : 0;
  }

  bool get isCurrentlyEligible {
    if (!medicalEligibility) return false;
    return daysUntilEligible == 0;
  }
}
