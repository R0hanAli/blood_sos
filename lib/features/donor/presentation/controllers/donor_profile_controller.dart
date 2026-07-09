import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/donor_providers.dart';
import '../../domain/entities/donor_entity.dart';
import '../../domain/repositories/donor_repository.dart';

class DonorProfileController extends StateNotifier<AsyncValue<DonorEntity?>> {
  final DonorRepository _donorRepository;

  DonorProfileController(this._donorRepository)
    : super(const AsyncValue.loading()) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final donor = await _donorRepository.getMyDonorProfile();
      state = AsyncValue.data(donor);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updateData) async {
    state = const AsyncValue.loading();
    try {
      final updatedDonor = await _donorRepository.updateMyDonorProfile(
        updateData,
      );
      state = AsyncValue.data(updatedDonor);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<Map<String, dynamic>> checkEligibility({
    required bool hasDiseases,
    required bool hasTattoosRecent,
    required bool hasTravelHistory,
    required bool hasMedications,
  }) async {
    try {
      final result = await _donorRepository.checkMedicalEligibility(
        hasDiseases: hasDiseases,
        hasTattoosRecent: hasTattoosRecent,
        hasTravelHistory: hasTravelHistory,
        hasMedications: hasMedications,
      );
      await fetchProfile();
      return result;
    } catch (e) {
      rethrow;
    }
  }
}

final donorProfileControllerProvider =
    StateNotifierProvider<DonorProfileController, AsyncValue<DonorEntity?>>((
      ref,
    ) {
      final repo = ref.watch(donorRepositoryProvider);
      return DonorProfileController(repo);
    });
