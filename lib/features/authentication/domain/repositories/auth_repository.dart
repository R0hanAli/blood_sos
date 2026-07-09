import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register({
    required String email,
    required String password,
    required String role,
    required String fullName,
    required String phone,
    Map<String, dynamic>? extraDetails,
  });
  Future<UserEntity> getMe();
  Future<void> forgotPassword(String email);
  Future<void> logout();
  Future<void> updateProfile(Map<String, dynamic> updateData);
}
