import 'package:dio/dio.dart';

import 'app_exception.dart';

final class AppFailure {
  const AppFailure({
    required this.message,
    this.code,
    this.statusCode,
    this.cause,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final int? statusCode;
  final Object? cause;
  final StackTrace? stackTrace;

  factory AppFailure.fromObject(Object error, [StackTrace? stackTrace]) {
    if (error is AppFailure) {
      return error;
    }

    if (error is AppException) {
      return AppFailure(
        message: error.message,
        code: error.code,
        cause: error.cause,
        stackTrace: error.stackTrace ?? stackTrace,
      );
    }

    if (error is DioException) {
      return AppFailure(
        message: _messageFromDio(error),
        code: error.type.name,
        statusCode: error.response?.statusCode,
        cause: error,
        stackTrace: error.stackTrace,
      );
    }

    return AppFailure(
      message: 'Something went wrong. Please try again.',
      cause: error,
      stackTrace: stackTrace,
    );
  }

  static String _messageFromDio(DioException error) {
    final responseMessage = error.response?.data;
    if (responseMessage is Map && responseMessage['message'] is String) {
      return responseMessage['message'] as String;
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout => 'Connection timed out.',
      DioExceptionType.sendTimeout => 'Request timed out.',
      DioExceptionType.receiveTimeout => 'Response timed out.',
      DioExceptionType.badCertificate => 'Unable to verify the server.',
      DioExceptionType.badResponse => 'The server returned an error.',
      DioExceptionType.cancel => 'Request was cancelled.',
      DioExceptionType.connectionError => 'No internet connection.',
      DioExceptionType.unknown => 'Something went wrong. Please try again.',
    };
  }
}
