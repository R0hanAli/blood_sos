import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_service.dart';
import 'socket_service.dart';
import '../network/api_client.dart';


final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden in ProviderScope in main()');
});

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(storageServiceProvider);
  return ApiClient(dio, storage);
});

final socketServiceProvider = Provider<SocketService>((ref) {
  
  return SocketService('http://localhost:3000');
});
