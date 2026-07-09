import 'package:blood_sos/core/services/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/blood_request_providers.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../../domain/repositories/blood_request_repository.dart';

class BloodRequestController
    extends StateNotifier<AsyncValue<List<BloodRequestEntity>>> {
  final BloodRequestRepository _repository;
  final Ref _ref;

  BloodRequestController(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    fetchOpenRequests();
    _subscribeToSocketEvents();
  }

  Future<void> fetchOpenRequests({String? bloodType}) async {
    try {
      final requests = await _repository.getBloodRequests(
        status: 'OPEN',
        bloodType: bloodType,
      );
      state = AsyncValue.data(requests);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void _subscribeToSocketEvents() {
    final socketService = _ref.read(socketServiceProvider);
    socketService.onEmergencyRequestReceived = (data) {
      state.whenData((currentList) {
        try {
          final newRequest = _parseSocketRequest(data);
          if (!currentList.any((r) => r.id == newRequest.id)) {
            state = AsyncValue.data([newRequest, ...currentList]);
          }
        } catch (_) {}
      });
    };

    socketService.onRequestAcceptedReceived = (data) {
      fetchOpenRequests();
    };

    socketService.onRequestStatusUpdatedReceived = (data) {
      fetchOpenRequests();
    };
  }

  BloodRequestEntity _parseSocketRequest(Map<String, dynamic> data) {
    return BloodRequestEntity(
      id: data['id'] ?? '',
      patientName: data['patientName'] ?? '',
      hospitalName: data['hospitalName'] ?? '',
      bloodType: data['bloodType'] ?? '',
      unitsRequired: data['unitsRequired'] ?? 1,
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      patientPhone: data['patientPhone'] ?? '',
      urgency: data['urgency'] ?? 'NORMAL',
      status: data['status'] ?? 'OPEN',
      createdById: data['createdById'] ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      acceptedById: data['acceptedById'],
      acceptedAt: data['acceptedAt'] != null
          ? DateTime.tryParse(data['acceptedAt'] as String)
          : null,
    );
  }

  Future<BloodRequestEntity> createRequest(
    Map<String, dynamic> requestData,
  ) async {
    try {
      final result = await _repository.createBloodRequest(requestData);
      await fetchOpenRequests();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<BloodRequestEntity> acceptRequest(String requestId) async {
    try {
      final result = await _repository.acceptBloodRequest(requestId);
      await fetchOpenRequests();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<BloodRequestEntity> updateStatus(
    String requestId,
    String status,
  ) async {
    try {
      final result = await _repository.updateRequestStatus(requestId, status);
      await fetchOpenRequests();
      return result;
    } catch (e) {
      rethrow;
    }
  }
}

final bloodRequestControllerProvider =
    StateNotifierProvider<
      BloodRequestController,
      AsyncValue<List<BloodRequestEntity>>
    >((ref) {
      final repo = ref.watch(bloodRequestRepositoryProvider);
      return BloodRequestController(repo, ref);
    });
