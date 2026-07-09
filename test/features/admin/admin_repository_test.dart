import 'package:flutter_test/flutter_test.dart';
import 'package:blood_sos/core/network/api_client.dart';
import 'package:blood_sos/features/admin/data/repositories/admin_repository_impl.dart';

class FakeApiClient implements ApiClient {
  bool fetchUsersCalled = false;
  bool suspendUserCalled = false;
  bool verifyHospitalCalled = false;
  bool broadcastAnnouncementCalled = false;

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    if (path == '/admin/users') {
      fetchUsersCalled = true;
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {
          'status': 'success',
          'data': [
            {
              'uid': 'user-123',
              'email': 'donor@sos.com',
              'role': 'donor',
              'status': 'ACTIVE',
              'profile': {
                'fullName': 'Alice Smith',
                'isSuspended': false,
              }
            },
            {
              'uid': 'hosp-456',
              'email': 'city@hosp.com',
              'role': 'hospital',
              'status': 'ACTIVE',
              'profile': {
                'fullName': 'City Hospital',
                'isVerified': true,
              }
            }
          ]
        },
      );
    }
    throw UnimplementedError();
  }

  @override
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    if (path.startsWith('/admin/users/') && path.endsWith('/suspend')) {
      suspendUserCalled = true;
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {'status': 'success'},
      );
    }
    if (path.startsWith('/admin/hospitals/') && path.endsWith('/verify')) {
      verifyHospitalCalled = true;
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {'status': 'success'},
      );
    }
    if (path == '/admin/broadcast') {
      broadcastAnnouncementCalled = true;
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {'status': 'success'},
      );
    }
    throw UnimplementedError();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('AdminRepository Unit Tests', () {
    late FakeApiClient fakeApiClient;
    late AdminRepositoryImpl repository;

    setUp(() {
      fakeApiClient = FakeApiClient();
      repository = AdminRepositoryImpl(apiClient: fakeApiClient);
    });

    test('fetchUsers queries admin users list and maps entries', () async {
      final list = await repository.fetchUsers();

      expect(list.length, equals(2));
      expect(list.first.email, equals('donor@sos.com'));
      expect(list.last.email, equals('city@hosp.com'));
      expect(fakeApiClient.fetchUsersCalled, isTrue);
    });

    test('suspendUser invokes suspension endpoint', () async {
      await repository.suspendUser('user-123', true);
      expect(fakeApiClient.suspendUserCalled, isTrue);
    });

    test('verifyHospital invokes verify endpoint', () async {
      await repository.verifyHospital('hosp-456', true);
      expect(fakeApiClient.verifyHospitalCalled, isTrue);
    });

    test('broadcastAnnouncement invokes broadcast endpoint', () async {
      await repository.broadcastAnnouncement('Critical notice message');
      expect(fakeApiClient.broadcastAnnouncementCalled, isTrue);
    });
  });
}
