import 'package:blood_sos/core/network/api_client.dart';
import 'package:blood_sos/core/services/storage_service.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../../domain/repositories/blood_request_repository.dart';
import '../models/blood_request_model.dart';

class BloodRequestRepositoryImpl implements BloodRequestRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  BloodRequestRepositoryImpl({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  static const String _requestsCacheKey = 'cached_blood_requests';

  @override
  Future<BloodRequestEntity> createBloodRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await _apiClient.post('/requests', data: requestData);
      final data = response.data['data'];
      return BloodRequestModel.fromJson(data).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BloodRequestEntity>> getBloodRequests({String status = 'OPEN', String? bloodType}) async {
    try {
      final Map<String, dynamic> queryParameters = {'status': status};
      if (bloodType != null) {
        queryParameters['bloodType'] = bloodType;
      }

      final response = await _apiClient.get('/requests', queryParameters: queryParameters);
      final List listData = response.data['data'] as List;

      
      await _storageService.requestsBox.put(_requestsCacheKey, listData);

      return listData
          .map((json) => BloodRequestModel.fromJson(Map<String, dynamic>.from(json as Map)).toEntity())
          .toList();
    } catch (e) {
      if (e is NetworkFailure) {
        final cached = _storageService.requestsBox.get(_requestsCacheKey);
        if (cached != null && cached is List) {
          return cached
              .map((json) => BloodRequestModel.fromJson(Map<String, dynamic>.from(json as Map)).toEntity())
              .toList();
        }
      }
      rethrow;
    }
  }

  @override
  Future<BloodRequestEntity> acceptBloodRequest(String requestId) async {
    try {
      final response = await _apiClient.post('/requests/$requestId/accept');
      final data = response.data['data'];
      return BloodRequestModel.fromJson(data).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BloodRequestEntity> updateRequestStatus(String requestId, String status) async {
    try {
      final response = await _apiClient.put('/requests/$requestId/status', data: {'status': status});
      final data = response.data['data'];
      return BloodRequestModel.fromJson(data).toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
