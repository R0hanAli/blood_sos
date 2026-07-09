import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sos/core/services/providers.dart';
import '../../domain/repositories/donation_repository.dart';
import '../repositories/donation_repository_impl.dart';

final donationRepositoryProvider = Provider<DonationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);
  return DonationRepositoryImpl(
    apiClient: apiClient,
    storageService: storageService,
  );
});
