import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/donation_providers.dart';
import '../../domain/entities/donation_entity.dart';
import '../../domain/repositories/donation_repository.dart';

class DonationHistoryController
    extends StateNotifier<AsyncValue<List<DonationEntity>>> {
  final DonationRepository _repository;

  DonationHistoryController(this._repository)
    : super(const AsyncValue.loading()) {
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      final list = await _repository.getMyDonationHistory();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<DonationEntity> logDonationRecord(Map<String, dynamic> logData) async {
    try {
      final record = await _repository.recordDonation(logData);
      await fetchHistory();
      return record;
    } catch (e) {
      rethrow;
    }
  }
}

final donationHistoryControllerProvider =
    StateNotifierProvider<
      DonationHistoryController,
      AsyncValue<List<DonationEntity>>
    >((ref) {
      final repo = ref.watch(donationRepositoryProvider);
      return DonationHistoryController(repo);
    });
