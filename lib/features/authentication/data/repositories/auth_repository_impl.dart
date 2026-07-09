import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:blood_sos/core/network/api_client.dart';
import 'package:blood_sos/core/services/storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthRepositoryImpl({
    firebase.FirebaseAuth? firebaseAuth,
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance,
        _apiClient = apiClient,
        _storageService = storageService;

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      bool firebaseAvailable = false;
      try {
        firebaseAvailable = Firebase.apps.isNotEmpty;
      } catch (_) {}

      if (!firebaseAvailable) {
        // Fallback local mock mode
        final mockToken = 'mock-token-$email';
        await _storageService.saveAuthToken(mockToken);
        final userEntity = await getMe();
        await _storageService.saveUserRole(userEntity.role.key);
        return userEntity;
      }

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const AuthFailure('Failed to sign in. User credentials empty.');
      }

      final token = await user.getIdToken();
      if (token == null) {
        throw const AuthFailure('Session token acquisition failed.');
      }

      await _storageService.saveAuthToken(token);
      final userEntity = await getMe();
      await _storageService.saveUserRole(userEntity.role.key);

      return userEntity;
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapFirebaseError(e.code));
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Authentication request failed: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String role,
    required String fullName,
    required String phone,
    Map<String, dynamic>? extraDetails,
  }) async {
    try {
      bool firebaseAvailable = false;
      try {
        firebaseAvailable = Firebase.apps.isNotEmpty;
      } catch (_) {}

      if (!firebaseAvailable) {
        // Fallback local mock mode
        final mockToken = 'mock-token-$email';
        await _storageService.saveAuthToken(mockToken);
        final response = await _apiClient.post(
          '/auth/register',
          data: {
            'role': role,
            'fullName': fullName,
            'phone': phone,
            ...?extraDetails,
          },
        );

        if (response.statusCode != 201) {
          await _storageService.clearAll();
          throw ServerFailure(response.data['message'] ?? 'Database synchronization failed.');
        }

        final registeredUser = UserModel.fromJson(response.data['data']).toEntity();
        await _storageService.saveUserRole(registeredUser.role.key);
        return registeredUser;
      }

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const AuthFailure('Failed to create account. Credential empty.');
      }

      final token = await user.getIdToken();
      if (token == null) {
        throw const AuthFailure('Registration token extraction failed.');
      }

      await _storageService.saveAuthToken(token);

      final response = await _apiClient.post(
        '/auth/register',
        data: {
          'role': role,
          'fullName': fullName,
          'phone': phone,
          ...?extraDetails,
        },
      );

      if (response.statusCode != 201) {
        await user.delete();
        await _storageService.clearAll();
        throw ServerFailure(response.data['message'] ?? 'Database synchronization failed.');
      }

      final registeredUser = UserModel.fromJson(response.data['data']).toEntity();
      await _storageService.saveUserRole(registeredUser.role.key);

      return registeredUser;
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapFirebaseError(e.code));
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Registration request failed: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> getMe() async {
    try {
      final response = await _apiClient.get('/auth/me');
      final userModel = UserModel.fromJson(response.data['data']);
      return userModel.toEntity();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Failed to fetch profile: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapFirebaseError(e.code));
    } catch (e) {
      throw ServerFailure('Forgot password dispatch failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
    await _storageService.clearAll();
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> updateData) async {
    try {
      await _apiClient.put('/auth/profile', data: updateData);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Profile update dispatch failed: ${e.toString()}');
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user record matching these credentials exists.';
      case 'wrong-password':
        return 'Invalid password provided.';
      case 'email-already-in-use':
        return 'The email is already registered to another account.';
      case 'weak-password':
        return 'The password is too weak. Must be at least 6 characters.';
      case 'network-request-failed':
        return 'Network connection lost. Please try again.';
      default:
        return 'Firebase authentication error ($code).';
    }
  }
}
