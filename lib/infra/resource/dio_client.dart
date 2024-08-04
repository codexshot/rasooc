import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/infra/resource/exceptions/exceptions.dart';
import 'package:rasooc/infra/resource/service/navigation_service.dart';
import 'package:rasooc/presentation/pages/auth/login.dart';

class DioClient {
  final Dio _dio;
  final String? baseEndpoint;
  final bool logging;

  DioClient(
    this._dio, {
    this.baseEndpoint,
    this.logging = false,
  }) {
    if (logging) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }

  Future<Response<T>> get<T>(
    String endpoint, {
    Options? options,
    String? fullUrl,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final isconnected = await hasInternetConnection();
      if (!isconnected) {
        throw SocketException("Please check your internet connection");
      }
      final response = await _dio.get<T>(
        fullUrl ?? '$baseEndpoint$endpoint',
        options: options,
        queryParameters: queryParameters,
      );
      return response;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        '$baseEndpoint$endpoint',
        data: data,
        options: options,
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> getJsonBody<T>(Response<T> response) {
    try {
      print(response.data);
      return response.data! as Map<String, dynamic>;
    } on Exception catch (e, stackTrace) {
      debugPrint(stackTrace.toString());
      throw Exception('Bad body format');
    }
  }

  List<dynamic> getJsonBodyList<T>(Response<T> response) {
    try {
      return response.data! as List<dynamic>;
    } on Exception catch (e, stackTrace) {
      debugPrint(stackTrace.toString());
      throw SchemeConsistencyException('Bad body format');
    }
  }

  Exception _handleError(DioError e) {
    final getIt = GetIt.instance;
    final apiResponse = getJsonBody(e.response!);

    print("API RESPONSE $apiResponse");
    final String message = apiResponse["error"];

    switch (e.response!.statusCode) {
      case 500:
        return ApiInternalServerException();
      case 400:
        return BadRequestException(message);
      case 401:
      case 403:
        if (message.toLowerCase().contains("unauthenticated")) {
          getIt<NavigationService>().navigateTo(LoginPage(
            errorMessage: "User session expired.",
          ));
          getIt<SharedPreferenceHelper>().clearAll();
        }
        return UnauthorisedException(message);
      case 404:
        return ResourceNotFoundException(message);
      default:
        // throw FetchDataException(
        //     'Error occurred while communicating with server : ${e.response.statusCode}');
        return ApiException(
          message,
        );
    }
  }

  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
