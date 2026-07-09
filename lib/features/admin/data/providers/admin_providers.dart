import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sos/core/services/providers.dart';
import '../../domain/repositories/admin_repository.dart';
import '../repositories/admin_repository_impl.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminRepositoryImpl(apiClient: apiClient);
});
