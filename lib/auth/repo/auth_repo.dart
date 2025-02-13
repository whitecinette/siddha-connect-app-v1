import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siddha_connect/utils/api_method.dart';
import 'package:siddha_connect/utils/message.dart';

import '../../utils/secure_storage.dart';

final authRepoProvider = Provider.autoDispose((ref) => AuthRepo(ref));

class AuthRepo {
  final Ref ref;
  AuthRepo(this.ref);

  userRegisterRepo({required Map data}) async {
    try {
      final response =
          await ApiMethod(url: ApiUrl.userRegister).postDioRequest(data: data);
      return response;
    } on DioException catch (e) {
      showSnackBarMsg("${e.response?.data['message']}", color: Colors.red);
    }
  }

  userLoginRepo({required Map data}) async {
    try {
      log("Request Data: $data");
      log("API URL: ${ApiUrl.userLogin}"); // Log the full URL

      final response =
      await ApiMethod(url: ApiUrl.userLogin).postDioRequest(data: data);

      log("Response Data: $response"); // Log response
      return response;
    } on DioException catch (e) {
      log("Dio Error: ${e.message}");
      log("Dio Response: ${e.response?.data}");
      log("Dio Stack Trace: ${e.stackTrace}");

      showSnackBarMsg("${e.response?.data['error'] ?? 'Something went wrong'}",
          color: Colors.red);
    }
  }


  dealerRegisterRepo({required Map data}) async {
    try {
      final response = await ApiMethod(url: ApiUrl.dealerRegister)
          .postDioRequest(data: data);
      return response;
    } on DioException catch (e) {
      showSnackBarMsg("${e.response?.data['error']}", color: Colors.red);
      return null;
    }
  }

  isDealerVerified() async {
    try {
      final token =
          await ref.watch(secureStoargeProvider).readData('authToken');
      final response =
          await ApiMethod(url: ApiUrl.isDealerVerified, token: "Bearer $token")
              .getDioRequest();
      return response;
    } catch (e) {
      log(e.toString());
    }
  }
}
