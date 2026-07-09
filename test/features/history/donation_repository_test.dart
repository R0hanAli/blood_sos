import 'package:flutter_test/flutter_test.dart';
import 'package:blood_sos/core/network/api_client.dart';
import 'package:blood_sos/core/services/storage_service.dart';
import 'package:blood_sos/features/history/data/repositories/donation_repository_impl.dart';

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
  bool getDonationsCalled = false;
  bool recordDonationCalled = false;
  List<dynamic>? mockResponseList;

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    if (path == '/donations/me') {
      getDonationsCalled = true;
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {
          'status': 'success',
          'data': mockResponseList ?? [
            {
              'id': 'don-123',
              'donorId': 'user-123',
              'donorName': 'Alice Smith',
              'bloodType': 'A-',
              'units': 1,
              'hospitalId': 'hosp-456',
              'hospitalName': 'General Hospital',
              'patientName': 'Jane Doe',
              'date': '2026-07-03T12:00:00Z',
              'certificateCode': 'CERT-SOS-12345',
              'status': 'VERIFIED'
            }
          ]
        },
      );
    }
    throw UnimplementedError('Endpoint $path not implemented in mock.');
  }

  @override
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    if (path == '/donations') {
      recordDonationCalled = true;
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 201,
        data: {
          'status': 'success',
          'data': {
            'id': 'don-999',
            'donorId': 'user-123',
            'donorName': 'Alice Smith',
            'bloodType': 'A-',
            'units': data['units'] ?? 1,
            'hospitalId': 'hosp-456',
            'hospitalName': 'General Hospital',
            'patientName': data['patientName'] ?? 'General Bank',
            'date': '2026-07-03T12:30:00Z',
            'certificateCode': 'CERT-SOS-99999',
            'status': 'VERIFIED'
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
  group('DonationRepository Unit Tests', () {
    late FakeStorageService fakeStorage;
    late FakeApiClient fakeApiClient;
    late DonationRepositoryImpl repository;

    setUp(() {
      fakeStorage = FakeStorageService();
      fakeApiClient = FakeApiClient();
      repository = DonationRepositoryImpl(
        apiClient: fakeApiClient,
        storageService: fakeStorage,
      );
    });

    test('getMyDonationHistory fetches histories from network and caches in Hive', () async {
      final list = await repository.getMyDonationHistory();

      expect(list.length, equals(1));
      expect(list.first.id, equals('don-123'));
      expect(list.first.donorName, equals('Alice Smith'));
      expect(fakeApiClient.getDonationsCalled, isTrue);

      // Verify list has cached to Hive
      final cached = fakeStorage.requestsBox.get('cached_donations_history');
      expect(cached, isNotNull);
      expect(cached is List, isTrue);
      expect(cached.first['donorName'], equals('Alice Smith'));
    });

    test('recordDonation invokes endpoint post and returns entity', () async {
      final req = await repository.recordDonation({
        'donorPhone': '12345678',
        'units': 1,
        'patientName': 'Jane Doe',
      });

      expect(req.id, equals('don-999'));
      expect(req.patientName, equals('Jane Doe'));
      expect(fakeApiClient.recordDonationCalled, isTrue);
    });
  });
}
