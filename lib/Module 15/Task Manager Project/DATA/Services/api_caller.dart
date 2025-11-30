import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Controllers/auth_controller.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/login_page.dart';
import 'package:m_ten_to_inf/app.dart';

class ApiCaller {
  static final Logger _logger = Logger();

  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url);

      Response response = await get(
        uri,
        headers: {'token': AuthController.accessToken ?? ''},
      );

      _logResponse(url, response);

      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        //success
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
          isSuccess: true,
          responseCode: statusCode,
          responseData: decodedData,
          errorMessage: '',
        );
      } else if (statusCode == 401) {
        await _moveToLogin();
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: null,
          errorMessage: 'Unauthorized'
        );
      } else {
        //failed
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decodedData,
          errorMessage: decodedData['data'],
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<ApiResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, body: body);

      Response response = await post(
        uri,
        headers: {
          'content-type': 'application/json',
          'token': AuthController.accessToken ?? '',
        },
        body: jsonEncode(body),
      );

      _logResponse(url, response);

      final int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        //success
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
          isSuccess: true,
          responseCode: statusCode,
          responseData: decodedData,
          errorMessage: '',
        );
      } else if (statusCode == 401) {
        await _moveToLogin();
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: null,
          errorMessage: 'Unauthorized'
        );
      } else {
        //failed
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decodedData,
          errorMessage: decodedData['data'].toString(),
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  static void _logRequest(String url, {Map<String, dynamic>? body}) {
    _logger.i(
      'URL => $url\n'
      'Request Body: $body',
    );
  }

  static void _logResponse(String url, Response response) {
    _logger.i(
      'URL => $url\n'
      'Status Code: ${response.statusCode}\n'
      'Body: ${response.body}',
    );
  }

  static Future<void> _moveToLogin() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
      TaskManagerApp.navigator.currentContext!,
      LoginPage.name,
      (predicate) => false,
    );
  }
}

class ApiResponse {
  final bool isSuccess;
  final int responseCode;
  final dynamic responseData;
  final String? errorMessage;

  ApiResponse({
    required this.isSuccess,
    required this.responseCode,
    required this.responseData,
    this.errorMessage = 'Something went wrong!',
  });
}
