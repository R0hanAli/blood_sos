import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../features/authentication/domain/entities/user_entity.dart';
import '../../data/providers/admin_providers.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminUsersController extends StateNotifier<AsyncValue<List<UserEntity>>> {
  final AdminRepository _repository;

  AdminUsersController(this._repository) : super(const AsyncValue.loading()) {
    fetchUsersList();
  }

  Future<void> fetchUsersList() async {
    try {
      final list = await _repository.fetchUsers();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> suspendUserToggle(String userId, bool suspended) async {
    try {
      await _repository.suspendUser(userId, suspended);
      await fetchUsersList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyHospitalToggle(String hospitalId, bool verified) async {
    try {
      await _repository.verifyHospital(hospitalId, verified);
      await fetchUsersList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendBroadcast(String message) async {
    try {
      await _repository.broadcastAnnouncement(message);
    } catch (e) {
      rethrow;
    }
  }
}

final adminUsersControllerProvider =
    StateNotifierProvider<AdminUsersController, AsyncValue<List<UserEntity>>>((
      ref,
    ) {
      final repo = ref.watch(adminRepositoryProvider);
      return AdminUsersController(repo);
    });
