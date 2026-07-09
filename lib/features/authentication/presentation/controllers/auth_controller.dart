import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/auth_providers.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.loading()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = await _authRepository.getMe();
      state = AsyncValue.data(user);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.login(email, password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String role,
    required String fullName,
    required String phone,
    Map<String, dynamic>? extraDetails,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        role: role,
        fullName: fullName,
        phone: phone,
        extraDetails: extraDetails,
      );
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _authRepository.forgotPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.logout();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserEntity?>>((ref) {
      final authRepo = ref.watch(authRepositoryProvider);
      return AuthController(authRepo);
    });
