import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:blood_sos/core/network/api_client.dart';
import 'package:blood_sos/core/services/storage_service.dart';
import 'package:blood_sos/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:blood_sos/features/authentication/domain/entities/user_role.dart';

class FakeFirebaseAuth implements firebase.FirebaseAuth {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Fake implementations for testing assertions without external network dependencies
class FakeStorageService implements StorageService {
  String? cachedToken;
  String? cachedRole;
  
  @override
  Future<void> saveAuthToken(String token) async {
    cachedToken = token;
  }
  
  @override
  Future<String?> getAuthToken() async {
    return cachedToken;
  }
  
  @override
  Future<void> deleteAuthToken() async {
    cachedToken = null;
  }
  
  @override
  Future<void> saveUserRole(String role) async {
    cachedRole = role;
  }
  
  @override
  String? getUserRole() => cachedRole;
  
  @override
  Future<void> saveThemeMode(bool isDarkMode) async {}
  
  @override
  bool getThemeMode() => false;
  
  @override
  Box get profileBox => throw UnimplementedError();
  @override
  Box get requestsBox => throw UnimplementedError();
  @override
  Box get hospitalsBox => throw UnimplementedError();
  @override
  Box get notificationsBox => throw UnimplementedError();

  @override
  Future<void> clearAll() async {
    cachedToken = null;
    cachedRole = null;
  }
}

class FakeApiClient implements ApiClient {
  bool getMeCalled = false;
  Map<String, dynamic>? mockResponse;
  
  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    if (path == '/auth/me') {
      getMeCalled = true;
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {
          'status': 'success',
          'data': mockResponse ?? {
            'uid': 'test-123',
            'email': 'donor@sos.com',
            'role': 'DONOR',
            'status': 'ACTIVE',
            'profile': {
              'fullName': 'John Doe',
              'phone': '12345678'
            }
          }
        },
      );
    }
    throw UnimplementedError('Endpoint $path not implemented in mock.');
  }

  @override
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    if (path == '/auth/register') {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 201,
        data: {
          'status': 'success',
          'data': {
            'uid': 'test-123',
            'email': 'donor@sos.com',
            'role': 'DONOR',
            'status': 'ACTIVE',
            'profile': {
              'fullName': 'John Doe',
              'phone': '12345678'
            }
          }
        },
      );
    }
    throw UnimplementedError('Endpoint $path not implemented in mock.');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('AuthRepository Unit Tests', () {
    late FakeStorageService fakeStorage;
    late FakeApiClient fakeApiClient;
    late AuthRepositoryImpl authRepository;

    setUp(() {
      fakeStorage = FakeStorageService();
      fakeApiClient = FakeApiClient();
      
      // Initialize implementation with a null Firebase reference (we mock network requests at the API Client layer)
      authRepository = AuthRepositoryImpl(
        firebaseAuth: FakeFirebaseAuth(), 
        apiClient: fakeApiClient,
        storageService: fakeStorage,
      );
    });

    test('getMe matches response fields and returns UserEntity', () async {
      final user = await authRepository.getMe();

      expect(user.uid, equals('test-123'));
      expect(user.email, equals('donor@sos.com'));
      expect(user.role, equals(UserRole.donor));
      expect(fakeApiClient.getMeCalled, isTrue);
    });

    test('logout clears StorageService keys', () async {
      await fakeStorage.saveAuthToken('dummy-token');
      await fakeStorage.saveUserRole('DONOR');
      
      await authRepository.logout();

      expect(await fakeStorage.getAuthToken(), isNull);
      expect(fakeStorage.getUserRole(), isNull);
    });
  });
}
