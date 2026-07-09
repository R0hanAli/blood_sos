import '../../../../features/authentication/domain/entities/user_entity.dart';

abstract class AdminRepository {
  Future<List<UserEntity>> fetchUsers();
  Future<void> suspendUser(String userId, bool suspend);
  Future<void> verifyHospital(String hospitalId, bool verify);
  Future<void> broadcastAnnouncement(String message);
}
