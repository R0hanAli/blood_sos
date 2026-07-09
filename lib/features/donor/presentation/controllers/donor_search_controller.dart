import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/donor_providers.dart';
import '../../domain/entities/donor_entity.dart';
import '../../domain/repositories/donor_repository.dart';

class DonorSearchController
    extends StateNotifier<AsyncValue<List<DonorEntity>>> {
  final DonorRepository _repository;

  DonorSearchController(this._repository) : super(const AsyncValue.data([]));

  Future<void> searchDonors({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    String? bloodType,
  }) async {
    state = const AsyncValue.loading();
    try {
      final donors = await _repository.searchNearbyDonors(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        bloodType: bloodType,
      );
      state = AsyncValue.data(donors);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final donorSearchControllerProvider =
    StateNotifierProvider<DonorSearchController, AsyncValue<List<DonorEntity>>>(
      (ref) {
        final repo = ref.watch(donorRepositoryProvider);
        return DonorSearchController(repo);
      },
    );
