import '../entities/blood_request_entity.dart';

abstract class BloodRequestRepository {
  Future<BloodRequestEntity> createBloodRequest(Map<String, dynamic> requestData);
  Future<List<BloodRequestEntity>> getBloodRequests({String status = 'OPEN', String? bloodType});
  Future<BloodRequestEntity> acceptBloodRequest(String requestId);
  Future<BloodRequestEntity> updateRequestStatus(String requestId, String status);
}
