import 'package:blood_sos/core/network/api_client.dart';
import 'package:blood_sos/core/services/storage_service.dart';
import '../../domain/entities/donor_entity.dart';
import '../../domain/repositories/donor_repository.dart';
import '../models/donor_model.dart';

class DonorRepositoryImpl implements DonorRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  DonorRepositoryImpl({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  static const String _profileCacheKey = 'cached_donor_profile';

  @override
  Future<DonorEntity> getMyDonorProfile() async {
    try {
      final response = await _apiClient.get('/donors/me');
      final donorData = response.data['data'];

      
      await _storageService.profileBox.put(_profileCacheKey, donorData);

      return DonorModel.fromJson(donorData).toEntity();
    } catch (e) {
      
      if (e is NetworkFailure) {
        final cachedData = _storageService.profileBox.get(_profileCacheKey);
        if (cachedData != null) {
          final Map<String, dynamic> mappedData = Map<String, dynamic>.from(cachedData as Map);
          return DonorModel.fromJson(mappedData).toEntity();
        }
      }
      rethrow;
    }
  }

  @override
  Future<DonorEntity> updateMyDonorProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _apiClient.put('/donors/me', data: updateData);
      final donorData = response.data['data'];

      
      await _storageService.profileBox.put(_profileCacheKey, donorData);

      return DonorModel.fromJson(donorData).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> checkMedicalEligibility({
    required bool hasDiseases,
    required bool hasTattoosRecent,
    required bool hasTravelHistory,
    required bool hasMedications,
  }) async {
    try {
      final response = await _apiClient.post(
        '/donors/me/eligibility',
        data: {
          'hasDiseases': hasDiseases,
          'hasTattoosRecent': hasTattoosRecent,
          'hasTravelHistory': hasTravelHistory,
          'hasMedications': hasMedications,
        },
      );

      
      try {
        await getMyDonorProfile();
      } catch (_) {}

      return Map<String, dynamic>.from(response.data['data'] as Map);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DonorEntity>> searchNearbyDonors({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    String? bloodType,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      };
      if (bloodType != null) {
        queryParameters['bloodType'] = bloodType;
      }

      final response = await _apiClient.get('/donors/search', queryParameters: queryParameters);
      final List listData = response.data['data'] as List;

      return listData
          .map((json) => DonorModel.fromJson(Map<String, dynamic>.from(json as Map)).toEntity())
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
