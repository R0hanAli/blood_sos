import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sos/core/services/providers.dart';
import '../../domain/repositories/donor_repository.dart';
import '../repositories/donor_repository_impl.dart';

final donorRepositoryProvider = Provider<DonorRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);
  return DonorRepositoryImpl(
    apiClient: apiClient,
    storageService: storageService,
  );
});
