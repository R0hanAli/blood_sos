import 'package:flutter/foundation.dart';
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
  // Match the same server URL as the REST client
  final String socketUrl;
  if (kIsWeb) {
    socketUrl = 'http://localhost:3000';
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    socketUrl = 'http://192.168.1.4:3000'; // same LAN IP as api_client.dart
  } else {
    socketUrl = 'http://localhost:3000';
  }
  return SocketService(socketUrl);
});
