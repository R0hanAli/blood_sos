import 'package:flutter_test/flutter_test.dart';
import 'package:blood_sos/core/network/api_client.dart';
import 'package:blood_sos/core/services/storage_service.dart';
import 'package:blood_sos/features/blood_request/data/repositories/blood_request_repository_impl.dart';

// Fake implementations for simulating Hive cache and API calls
class FakeHiveBox implements Box {
  final Map<dynamic, dynamic> _data = {};

  @override
  Future<void> put(dynamic key, dynamic value) async {
    _data[key] = value;
  }

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) {
    return _data[key] ?? defaultValue;
  }

  @override
  Future<int> clear() async {
    final count = _data.length;
    _data.clear();
    return count;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeStorageService implements StorageService {
  final _requestsBox = FakeHiveBox();

  @override
  Box get requestsBox => _requestsBox;

  @override
  Box get profileBox => throw UnimplementedError();
  @override
  Box get hospitalsBox => throw UnimplementedError();
  @override
  Box get notificationsBox => throw UnimplementedError();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeApiClient implements ApiClient {
  bool getRequestsCalled = false;
  bool createRequestCalled = false;
  List<dynamic>? mockResponseList;

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    if (path == '/requests') {
      getRequestsCalled = true;
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {
          'status': 'success',
          'data': mockResponseList ?? [
            {
              'id': 'req-123',
              'patientName': 'Jane Doe',
              'hospitalName': 'General Hospital',
              'bloodType': 'B+',
              'unitsRequired': 2,
              'latitude': 42.3601,
              'longitude': -71.0589,
              'patientPhone': '5551234',
              'urgency': 'URGENT',
              'status': 'OPEN',
              'createdById': 'user-456',
              'createdAt': '2026-07-03T12:00:00Z',
              'acceptedById': null,
              'acceptedAt': null
            }
          ]
        },
      );
    }
    throw UnimplementedError('Endpoint $path not implemented in mock.');
  }

  @override
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    if (path == '/requests') {
      createRequestCalled = true;
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 201,
        data: {
          'status': 'success',
          'data': {
            'id': 'req-999',
            'patientName': data['patientName'] ?? 'New Patient',
            'hospitalName': data['hospitalName'] ?? 'Community Clinic',
            'bloodType': data['bloodType'] ?? 'AB-',
            'unitsRequired': data['unitsRequired'] ?? 1,
            'latitude': data['latitude'] ?? 0.0,
            'longitude': data['longitude'] ?? 0.0,
            'patientPhone': data['patientPhone'] ?? '5550000',
            'urgency': data['urgency'] ?? 'NORMAL',
            'status': 'OPEN',
            'createdById': 'user-111',
            'createdAt': '2026-07-03T12:30:00Z',
            'acceptedById': null,
            'acceptedAt': null
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
  group('BloodRequestRepository Unit Tests', () {
    late FakeStorageService fakeStorage;
    late FakeApiClient fakeApiClient;
    late BloodRequestRepositoryImpl repository;

    setUp(() {
      fakeStorage = FakeStorageService();
      fakeApiClient = FakeApiClient();
      repository = BloodRequestRepositoryImpl(
        apiClient: fakeApiClient,
        storageService: fakeStorage,
      );
    });

    test('getBloodRequests fetches lists from network and caches in Hive', () async {
      final list = await repository.getBloodRequests();

      expect(list.length, equals(1));
      expect(list.first.id, equals('req-123'));
      expect(list.first.patientName, equals('Jane Doe'));
      expect(fakeApiClient.getRequestsCalled, isTrue);

      // Verify list has cached to Hive
      final cached = fakeStorage.requestsBox.get('cached_blood_requests');
      expect(cached, isNotNull);
      expect(cached is List, isTrue);
      expect(cached.first['patientName'], equals('Jane Doe'));
    });

    test('createBloodRequest invokes endpoint post and returns entity', () async {
      final req = await repository.createBloodRequest({
        'patientName': 'New Patient',
        'hospitalName': 'Community Clinic',
        'bloodType': 'AB-',
        'unitsRequired': 1,
        'patientPhone': '5550000',
      });

      expect(req.id, equals('req-999'));
      expect(req.patientName, equals('New Patient'));
      expect(fakeApiClient.createRequestCalled, isTrue);
    });
  });
}
