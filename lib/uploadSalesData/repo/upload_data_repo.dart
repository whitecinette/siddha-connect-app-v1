import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siddha_connect/utils/api_method.dart';
import '../../salesDashboard/screen/sales_dashboard.dart';
import '../../utils/message.dart';
import '../../utils/navigation.dart';

final salesDataUploadRepoProvider = Provider.autoDispose((ref) {
  return SalesDataUploadRepo();
});

class SalesDataUploadRepo {
  salesDataUpload({required File file}) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
        ),
      });
      final response = await ApiMethod(url: ApiUrl.uploadSalesData)
          .postDioFormData(data: formData);
      if (response == "Data inserted into database") {
        showSnackBarMsg(
          "Sales Data Upload Successfully",
          color: Colors.green,
        );
        navigatePushReplacement(const SalesDashboard());
      } else {
        showSnackBarMsg(
          "Something went wrong",
          color: Colors.red,
        );
        navigatePushReplacement(const SalesDashboard());
      }

      return response;
    } catch (e) {
      log("responseErrorr=>>>>$e");
    }
  }

  modelDataUpload({required File file}) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
        ),
      });
      final response = await ApiMethod(url: ApiUrl.uploadModelData)
          .postDioFormData(data: formData);
      if (response == "Model Data inserted into database!") {
        showSnackBarMsg("Model Data Upload Successfully", color: Colors.green);
        navigatePushReplacement(const SalesDashboard());
      } else {
        showSnackBarMsg("Something went wrong", color: Colors.red);
        navigatePushReplacement(const SalesDashboard());
      }
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  channelTargetUpload({required File file}) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
        ),
      });
      final response = await ApiMethod(url: ApiUrl.uploadChannelTargets)
          .putDioFormData(data: formData);
      if (response == "Targets inserted/updated in the database!") {
        showSnackBarMsg("Channel Target Data Upload Successfully",
            color: Colors.green);
        navigatePushReplacement(const SalesDashboard());
      } else {
        showSnackBarMsg("Something went wrong", color: Colors.red);
        navigatePushReplacement(const SalesDashboard());
      }
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  segmentTargetUpload({required File file}) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
        ),
      });
      final response = await ApiMethod(url: ApiUrl.uploadSegmentTargets)
          .putDioFormData(data: formData);
      if (response == "Targets inserted/updated in the database!") {
        showSnackBarMsg("Segment Target Data Upload Successfully",
            color: Colors.green);
        navigatePushReplacement(const SalesDashboard());
      } else {
        showSnackBarMsg("Something went wrong", color: Colors.red);
        navigatePushReplacement(const SalesDashboard());
      }
      return response;
    } catch (e) {
      log(e.toString());
    }
  }
}
