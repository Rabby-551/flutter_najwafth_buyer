import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import '../config/app_config.dart';
import '../session/session_expiry_controller.dart';
import '../storage/key_value_storage.dart';
import '../storage/storage_providers.dart';
import 'api_client.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.development();
});

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(keyValueStorageProvider);
  Future<bool>? refreshTokenRequest;

  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      headers: const {Headers.acceptHeader: Headers.jsonContentType},
    ),
  );

  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) {
        final token = storage.readString('buyer_access_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        if (kDebugMode) {
          _printLine(
            '[API][REQ] ${options.method} ${options.baseUrl}${options.path}',
          );
          _printLine('[API][REQ][HEADERS] ${_redactedHeaders(options.headers)}');
          _printLine('[API][REQ][QUERY] ${options.queryParameters}');
          _printLine('[API][REQ][BODY]\n${_readable(options.data)}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          _printLine(
            '[API][RES] ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}',
          );
          _printLine('[API][RES][BODY]\n${_readable(response.data)}');
        }
        handler.next(response);
      },
      onError: (error, handler) async {
        if (kDebugMode) {
          _printLine(
            '[API][ERR] ${error.response?.statusCode} ${error.requestOptions.method} ${error.requestOptions.path}',
          );
          _printLine('[API][ERR][MESSAGE] ${error.message}');
          _printLine('[API][ERR][BODY]\n${_readable(error.response?.data)}');
        }
        if (_isExpiredSessionError(
          error,
          storage.readString('buyer_access_token'),
        )) {
          final refreshed = await (refreshTokenRequest ??=
              _refreshSessionToken(config: config, storage: storage));
          refreshTokenRequest = null;

          if (refreshed) {
            try {
              error.requestOptions.headers['Authorization'] =
                  'Bearer ${storage.readString('buyer_access_token')}';
              final response = await dio.fetch<dynamic>(error.requestOptions);
              handler.resolve(response);
              return;
            } on DioException catch (retryError) {
              if (_isExpiredSessionError(
                retryError,
                storage.readString('buyer_access_token'),
              )) {
                await _clearExpiredSession(storage);
                ref.read(sessionExpiryProvider.notifier).notifyExpired();
              }
              handler.next(retryError);
              return;
            }
          }

          await _clearExpiredSession(storage);
          ref.read(sessionExpiryProvider.notifier).notifyExpired();
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

bool _isExpiredSessionError(DioException error, String? token) {
  if (token == null || token.isEmpty) {
    return false;
  }

  final path = error.requestOptions.path;
  if (path.startsWith('/auth/login') ||
      path.startsWith('/auth/register') ||
      path.startsWith('/auth/refresh-token')) {
    return false;
  }

  final statusCode = error.response?.statusCode;
  if (statusCode == 401) {
    return true;
  }

  final message = _responseMessage(error.response?.data).toLowerCase();
  return message.contains('token') &&
      (message.contains('expired') ||
          message.contains('invalid') ||
          message.contains('jwt'));
}

Future<bool> _refreshSessionToken({
  required AppConfig config,
  required KeyValueStorage storage,
}) async {
  final refreshToken = storage.readString('buyer_refresh_token');
  if (refreshToken == null || refreshToken.isEmpty) {
    return false;
  }

  try {
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        headers: const {Headers.acceptHeader: Headers.jsonContentType},
      ),
    );

    final response = await refreshDio.post<dynamic>(
      '/auth/refresh-token',
      data: {'refreshToken': refreshToken},
    );

    final data = response.data;
    final payload = data is Map ? data['data'] : null;
    if (payload is! Map) {
      return false;
    }

    final accessToken = (payload['accessToken'] ?? '').toString();
    final nextRefreshToken = (payload['refreshToken'] ?? '').toString();
    if (accessToken.isEmpty || nextRefreshToken.isEmpty) {
      return false;
    }

    await storage.writeString('buyer_access_token', accessToken);
    await storage.writeString('buyer_refresh_token', nextRefreshToken);
    await storage.writeBool('buyer_is_authenticated', true);
    return true;
  } on Object {
    return false;
  }
}

Future<void> _clearExpiredSession(KeyValueStorage storage) async {
  await storage.writeBool('buyer_is_authenticated', false);
  await storage.remove('buyer_access_token');
  await storage.remove('buyer_refresh_token');
  await storage.remove('buyer_user_id');
  await storage.remove('buyer_role');
}

String _responseMessage(dynamic data) {
  if (data is Map && data['message'] != null) {
    return data['message'].toString();
  }
  return data?.toString() ?? '';
}

Map<String, dynamic> _redactedHeaders(Map<String, dynamic> headers) {
  return headers.map((key, value) {
    if (key.toLowerCase() == 'authorization') {
      return MapEntry(key, _redactAuthorization(value));
    }
    return MapEntry(key, value);
  });
}

String _redactAuthorization(Object? value) {
  final header = value?.toString() ?? '';
  if (!header.toLowerCase().startsWith('bearer ')) {
    return '***';
  }

  final token = header.substring(7);
  if (token.length <= 12) {
    return 'Bearer ***';
  }

  return 'Bearer ${token.substring(0, 6)}...${token.substring(token.length - 6)}';
}

void _printLine(String message) {
  debugPrint('$message\n');
}

String _readable(dynamic value) {
  if (value == null) {
    return 'null';
  }

  if (value is FormData) {
    final fields = value.fields.map((e) => '${e.key}: ${e.value}').toList();
    final files = value.files
        .map((e) => '${e.key}: ${e.value.filename ?? 'file'}')
        .toList();
    return 'FormData{\n  fields: $fields,\n  files: $files\n}';
  }

  if (value is Map || value is List) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(value);
  }

  return value.toString();
}
