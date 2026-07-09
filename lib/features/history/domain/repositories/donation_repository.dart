import '../entities/donation_entity.dart';

abstract class DonationRepository {
  Future<List<DonationEntity>> getMyDonationHistory();
  Future<DonationEntity> recordDonation(Map<String, dynamic> logData);
}
