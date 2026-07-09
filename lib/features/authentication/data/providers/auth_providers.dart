import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sos/core/services/providers.dart';
import '../../domain/repositories/auth_repository.dart';
import '../repositories/auth_repository_impl.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthRepositoryImpl(
    apiClient: apiClient,
    storageService: storageService,
  );
});
