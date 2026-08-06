import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/error/app_exception.dart';
import '../core/logger/app_logger.dart';
import '../core/network/http_status_codes.dart';

/// Base class for every GetX controller.
///
/// Provides:
/// - `isLoading` / `error` reactive state for [BaseView]
/// - [run] — safe API execution with typed error mapping + optional loader
/// - [runGuarded] — fire-and-forget variant for background calls
/// - Snackbar helpers for user feedback
class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  /// Execute a request, map failures to friendly messages and expose the
  /// result. Set [showLoader] to false for background/refresh calls.
  Future<T?> run<T>(
    Future<T> Function() request, {
    bool showLoader = true,
  }) async {
    if (showLoader) {
      isLoading.value = true;
    }
    error.value = null;

    try {
      final T result = await request();
      return result;
    } on DioException catch (e) {
      final AppException mapped = mapDioException(e);
      error.value = mapped.message;
      debugPrint(
        'API Error -> ${e.response?.statusCode} | ${e.requestOptions.uri}',
      );
      return null;
    } on AppException catch (e) {
      error.value = e.message;
      return null;
    } catch (e) {
      error.value = ErrorMessages.generic;
      talker.handle(e, StackTrace.current, 'Unexpected error');
      return null;
    } finally {
      if (showLoader) {
        isLoading.value = false;
      }
    }
  }

  /// Like [run] but without returning the result — for void-style calls.
  Future<void> runGuarded(
    Future<void> Function() request, {
    bool showLoader = true,
    VoidCallback? onError,
  }) async {
    await run<void>(request, showLoader: showLoader);
    if (error.value != null) {
      onError?.call();
    }
  }

  /// Map a raw Dio error to a user-readable [AppException].
  AppException mapDioException(DioException e) {
    final int? code = e.response?.statusCode;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return AppException(ErrorMessages.timeout, isNetworkError: true);
      case DioExceptionType.connectionError:
        return AppException(ErrorMessages.noInternet, isNetworkError: true);
      case DioExceptionType.cancel:
        return const AppException(ErrorMessages.generic);
      case DioExceptionType.badCertificate:
        return const AppException(ErrorMessages.generic);
      case DioExceptionType.badResponse:
        break;
      case DioExceptionType.unknown:
        return AppException(ErrorMessages.generic, isNetworkError: true);
    }

    switch (code) {
      case HttpStatusCodes.unauthorized:
        return AppException(ErrorMessages.unauthorized, statusCode: code);
      case HttpStatusCodes.forbidden:
        return AppException(ErrorMessages.forbidden, statusCode: code);
      case HttpStatusCodes.notFound:
        return AppException(ErrorMessages.notFound, statusCode: code);
      case HttpStatusCodes.internalServerError:
      case HttpStatusCodes.badGateway:
      case HttpStatusCodes.serviceUnavailable:
      case HttpStatusCodes.gatewayTimeout:
        return AppException(ErrorMessages.server, statusCode: code);
      default:
        final String? serverMessage = _messageFromResponse(e.response?.data);
        return AppException(
          serverMessage ?? ErrorMessages.generic,
          statusCode: code,
        );
    }
  }

  String? _messageFromResponse(dynamic data) {
    if (data is Map<String, dynamic> && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }

  /// Override in subclasses to re-run the primary fetch (pulled by
  /// [BaseView]'s retry button).
  void retry() {}

  void clearError() => error.value = null;

  void showSnack(String message, {bool isError = false}) {
    final ColorScheme scheme = Theme.of(Get.context!).colorScheme;
    Get.snackbar(
      isError ? 'Something went wrong' : 'LexiAI',
      message,
      backgroundColor: isError ? scheme.error : scheme.primary,
      colorText: isError ? Colors.white : scheme.onPrimary,
      borderRadius: 14,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    );
  }
}
