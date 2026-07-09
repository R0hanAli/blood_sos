import 'package:flutter_test/flutter_test.dart';
import 'package:blood_sos/core/network/api_client.dart';
import 'package:blood_sos/core/services/storage_service.dart';
import 'package:blood_sos/features/donor/data/repositories/donor_repository_impl.dart';

// Fake implementations for simulating API responses and Hive box behaviors
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
  final _profileBox = FakeHiveBox();

  @override
  Box get profileBox => _profileBox;

  @override
  Box get requestsBox => throw UnimplementedError();
  @override
  Box get hospitalsBox => throw UnimplementedError();
  @override
  Box get notificationsBox => throw UnimplementedError();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeApiClient implements ApiClient {
  bool getDonorCalled = false;
  bool updateDonorCalled = false;
  Map<String, dynamic>? mockResponse;

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    if (path == '/donors/me') {
      getDonorCalled = true;
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {
          'status': 'success',
          'data': mockResponse ?? {
            'id': 'donor-123',
            'userId': 'user-123',
            'fullName': 'Alice Smith',
            'phone': '98765432',
            'bloodGroup': 'A-',
            'age': 30,
            'gender': 'Female',
            'weight': 62.5,
            'city': 'Boston',
            'latitude': 42.3601,
            'longitude': -71.0589,
            'medicalEligibility': true,
            'lastDonationDate': null,
            'availabilityStatus': true,
            'donationCount': 2,
            'nextEligibleDate': null
          }
        },
      );
    }
    throw UnimplementedError('Endpoint $path not implemented in mock.');
  }

  @override
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    if (path == '/donors/me') {
      updateDonorCalled = true;
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {
          'status': 'success',
          'data': {
            'id': 'donor-123',
            'userId': 'user-123',
            'fullName': data['fullName'] ?? 'Alice Smith',
            'phone': data['phone'] ?? '98765432',
            'bloodGroup': 'A-',
            'age': 30,
            'gender': 'Female',
            'weight': 62.5,
            'city': 'Boston',
            'latitude': 42.3601,
            'longitude': -71.0589,
            'medicalEligibility': true,
            'lastDonationDate': null,
            'availabilityStatus': true,
            'donationCount': 2,
            'nextEligibleDate': null
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
  group('DonorRepository Unit Tests', () {
    late FakeStorageService fakeStorage;
    late FakeApiClient fakeApiClient;
    late DonorRepositoryImpl donorRepository;

    setUp(() {
      fakeStorage = FakeStorageService();
      fakeApiClient = FakeApiClient();
      donorRepository = DonorRepositoryImpl(
        apiClient: fakeApiClient,
        storageService: fakeStorage,
      );
    });

    test('getMyDonorProfile fetches from network and caches in Hive', () async {
      final donor = await donorRepository.getMyDonorProfile();

      expect(donor.id, equals('donor-123'));
      expect(donor.fullName, equals('Alice Smith'));
      expect(fakeApiClient.getDonorCalled, isTrue);

      // Verify it has cached in Hive
      final cached = fakeStorage.profileBox.get('cached_donor_profile');
      expect(cached, isNotNull);
      expect(cached['fullName'], equals('Alice Smith'));
    });

    test('updateMyDonorProfile updates on network and modifies Hive cache', () async {
      await donorRepository.updateMyDonorProfile({'fullName': 'Alice Changed'});

      expect(fakeApiClient.updateDonorCalled, isTrue);

      final cached = fakeStorage.profileBox.get('cached_donor_profile');
      expect(cached['fullName'], equals('Alice Changed'));
    });
  });
}
