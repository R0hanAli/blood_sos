import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blood_sos/main.dart';
import 'package:blood_sos/core/services/providers.dart';
import 'package:blood_sos/core/services/storage_service.dart';
import 'package:blood_sos/core/errors/failures.dart';
import 'package:blood_sos/features/authentication/domain/repositories/auth_repository.dart';
import 'package:blood_sos/features/authentication/data/providers/auth_providers.dart';
import 'package:blood_sos/features/authentication/domain/entities/user_entity.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<UserEntity> getMe() async {
    // Return empty or throw Failure to represent logged-out state in test
    throw const AuthFailure('No active session.');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('App boots and renders splash screen placeholder', (WidgetTester tester) async {
    // Inject mock local storage preferences values
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    const secureStorage = FlutterSecureStorage();
    final storageService = StorageService(prefs, secureStorage);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        ],
        child: const MyApp(),
      ),
    );

    // Settle GoRouter navigation routing to '/'
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify that our SplashScreen is successfully rendered
    expect(find.text('BloodSOS'), findsOneWidget);
  });
}
