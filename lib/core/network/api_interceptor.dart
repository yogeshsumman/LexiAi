import 'package:dio/dio.dart';

/// Adds common headers and (optionally) the auth token to every request.
///
/// Extend this later with token refresh / 401-retry logic — the
/// `onError` hook is the single place to do it.
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options
      ..headers['Content-Type'] = 'application/json'
      ..headers['Accept'] = 'application/json'
      ..headers['X-Client'] = 'lexiai-mobile';

    // TODO(security): read the token from secure storage once auth exists.
    // final token = await AuthStorage.readToken();
    // if (token != null) options.headers['Authorization'] = 'Bearer $token';

    super.onRequest(options, handler);
  }
}
