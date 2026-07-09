import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sos/core/services/providers.dart';
import '../../domain/repositories/blood_request_repository.dart';
import '../repositories/blood_request_repository_impl.dart';

final bloodRequestRepositoryProvider = Provider<BloodRequestRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);
  return BloodRequestRepositoryImpl(
    apiClient: apiClient,
    storageService: storageService,
  );
});
