import '../entities/donor_entity.dart';

abstract class DonorRepository {
  Future<DonorEntity> getMyDonorProfile();
  Future<DonorEntity> updateMyDonorProfile(Map<String, dynamic> updateData);
  Future<Map<String, dynamic>> checkMedicalEligibility({
    required bool hasDiseases,
    required bool hasTattoosRecent,
    required bool hasTravelHistory,
    required bool hasMedications,
  });
  Future<List<DonorEntity>> searchNearbyDonors({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    String? bloodType,
  });
}
