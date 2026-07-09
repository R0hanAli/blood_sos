import 'package:blood_sos/core/network/api_client.dart';
import 'package:blood_sos/core/services/storage_service.dart';
import '../../domain/entities/donation_entity.dart';
import '../../domain/repositories/donation_repository.dart';
import '../models/donation_model.dart';

class DonationRepositoryImpl implements DonationRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  DonationRepositoryImpl({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  static const String _donationsCacheKey = 'cached_donations_history';

  @override
  Future<List<DonationEntity>> getMyDonationHistory() async {
    try {
      final response = await _apiClient.get('/donations/me');
      final List listData = response.data['data'] as List;

      
      await _storageService.requestsBox.put(_donationsCacheKey, listData);

      return listData
          .map((json) => DonationModel.fromJson(Map<String, dynamic>.from(json as Map)).toEntity())
          .toList();
    } catch (e) {
      if (e is NetworkFailure) {
        final cached = _storageService.requestsBox.get(_donationsCacheKey);
        if (cached != null && cached is List) {
          return cached
              .map((json) => DonationModel.fromJson(Map<String, dynamic>.from(json as Map)).toEntity())
              .toList();
        }
      }
      rethrow;
    }
  }

  @override
  Future<DonationEntity> recordDonation(Map<String, dynamic> logData) async {
    try {
      final response = await _apiClient.post('/donations', data: logData);
      final data = response.data['data'];
      return DonationModel.fromJson(data).toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
