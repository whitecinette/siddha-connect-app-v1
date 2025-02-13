import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siddha_connect/utils/message.dart';

import '../../utils/api_method.dart';

final attendenceRepoProvider =
    Provider.autoDispose((ref) => AttendenceRepo(ref: ref));

class AttendenceRepo {
  final Ref ref;
  AttendenceRepo({required this.ref});

  getGeoTagInfomation({String? dealerCode}) async {
    try {
      final response = await ApiMethod(
              url:
                  "${ApiUrl.getUpdatedGeoTagForEmployee}?dealerCode=$dealerCode")
          .getDioRequest();

      log("getGeoTagInfomation=====>>>>>>>$response");
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  dealerGeoTag({required Map data}) async {
    log("Data123====>>>>!!!!!!!!!$data");
    try {
      final response =
          await ApiMethod(url: ApiUrl.updateDealerGeoTagForEmployee)
              .putDioRequest(data: data);

      if (response['success'] == true) {
        showSnackBarMsg(response['message'], color: Colors.green);
      } else {
        showSnackBarMsg("Something went wrong");
      }

      log("Profile123456=====>>>>>>>$response");
      return response;
    } catch (e) {
      log(e.toString());
    }
  }
}
