import 'package:blood_sos/core/network/api_client.dart';
import '../../../../features/authentication/domain/entities/user_entity.dart';
import '../../../../features/authentication/data/models/user_model.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final ApiClient _apiClient;

  AdminRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<UserEntity>> fetchUsers() async {
    try {
      final response = await _apiClient.get('/admin/users');
      final List listData = response.data['data'] as List;

      return listData
          .map((json) => UserModel.fromJson(Map<String, dynamic>.from(json as Map)).toEntity())
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> suspendUser(String userId, bool suspend) async {
    try {
      await _apiClient.post(
        '/admin/users/$userId/suspend',
        data: {'suspended': suspend},
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyHospital(String hospitalId, bool verify) async {
    try {
      await _apiClient.post(
        '/admin/hospitals/$hospitalId/verify',
        data: {'verified': verify},
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> broadcastAnnouncement(String message) async {
    try {
      await _apiClient.post(
        '/admin/broadcast',
        data: {'message': message},
      );
    } catch (e) {
      rethrow;
    }
  }
}
