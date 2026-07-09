import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:blood_sos/core/services/storage_service.dart';
import 'package:blood_sos/core/errors/failures.dart';

export 'package:dio/dio.dart';
export 'package:blood_sos/core/errors/failures.dart';

class ApiClient {
  final Dio _dio;
  final StorageService _storageService;

  ApiClient(this._dio, this._storageService) {
    if (kIsWeb) {
      _dio.options.baseUrl = 'http://localhost:3000/api';
    } else {
      _dio.options.baseUrl = defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:3000/api'
          : 'http://localhost:3000/api';
    } 
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storageService.getAuthToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        final failure = _handleDioError(e);
        return handler.next(DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: failure,
        ));
      },
    ));
  }

  Dio get dio => _dio;

  
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw e.error is Failure ? e.error as Failure : ServerFailure(e.message ?? 'Server connection error');
    }
  }

  
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw e.error is Failure ? e.error as Failure : ServerFailure(e.message ?? 'Server connection error');
    }
  }

  
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw e.error is Failure ? e.error as Failure : ServerFailure(e.message ?? 'Server connection error');
    }
  }

  
  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw e.error is Failure ? e.error as Failure : ServerFailure(e.message ?? 'Server connection error');
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Server connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const NetworkFailure('Failed to connect to the server. Check your connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        String errorMessage = 'Something went wrong';
        
        if (responseData != null && responseData is Map) {
          errorMessage = responseData['message'] ?? errorMessage;
        }

        if (statusCode == 401) {
          return AuthFailure(errorMessage);
        } else if (statusCode == 403) {
          return const AuthFailure('Access denied: You are not authorized.');
        } else if (statusCode == 400) {
          return ValidationFailure(errorMessage);
        }
        return ServerFailure('Server Error ($statusCode): $errorMessage');
      default:
        return const ServerFailure('An unexpected error occurred. Please contact support.');
    }
  }
}
