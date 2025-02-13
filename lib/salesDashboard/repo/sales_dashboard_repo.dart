import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siddha_connect/utils/api_method.dart';
import 'package:siddha_connect/utils/secure_storage.dart';

final salesRepoProvider =
    Provider.autoDispose((ref) => SalesDashboardRepo(ref: ref));

class SalesDashboardRepo {
  final Ref ref;
  SalesDashboardRepo({required this.ref});

//=============================! Get Sales Dashboard Data !==================================

  getSalesDashboardData(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? position,
      String? name}) async {
    try {
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      String url = urlFormat(ApiUrl.getEmployeeSalesDashboardData, tdFormat,
          dataFormat, firstDate, lastDate, position, name);
      final response = await ApiMethod(url: url, token: token).getDioRequest();
      return response;
    } catch (e) {
      // log(e.toString());
    }
  }
//=============================! Get Sales Dashboard Data BY Employee !==================================

  getSalesDashboardDataByEmployeeName(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? position,
      String? name}) async {
    try {
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      String url = urlFormat(ApiUrl.getEmployeeSalesDashboardDataByName,
          tdFormat, dataFormat, firstDate, lastDate, position, name);
      final response = await ApiMethod(url: url, token: token).getDioRequest();
      return response;
    } catch (e) {
      // log(e.toString());
    }
  }
//=============================! Get Sales Dashboard Data By DealerCode !==================================

  getSalesDashboardDataByDealerCode(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? dealerCode}) async {
    try {
      String url = urlFormatGetDataByDealerCode(
          ApiUrl.getEmployeeSalesDashboardDataByDealerCode,
          tdFormat,
          dataFormat,
          firstDate,
          lastDate,
          dealerCode);
      final response = await ApiMethod(
        url: url,
      ).getDioRequest();
      return response;
    } catch (e) {
      // log(e.toString());
    }
  }

//=============================! Get Segment Wise Data !==================================
  getSegmentAllData(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? position,
      String? name}) async {
    try {
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      String url = urlFormat(ApiUrl.getSegmentData, tdFormat, dataFormat,
          firstDate, lastDate, position, name);
      final response = await ApiMethod(url: url, token: token).getDioRequest();
      return response;
    } catch (e) {
      // log(e.toString());
    }
  }
//=============================! Get Segment Position Wise Data !==================================

  getSegmentPositionWiseData(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? name,
      String? position}) async {
    try {
      final token = await ref.read(secureStoargeProvider).readData('authToken');

      String url = name == "All"
          ? urlFormatTse(ApiUrl.getSegmentPositionWise, tdFormat, dataFormat,
              firstDate, lastDate, position, name)
          : urlFormatSubordinatesNames(
              "${ApiUrl.getSegmentSubordinateWise}$name",
              tdFormat,
              dataFormat,
              firstDate,
              lastDate);
      final response = await ApiMethod(url: url, token: token).getDioRequest();
      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

//=============================! Get Channel Wise Data !==================================
  getChannelWiseData(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? position,
      String? name}) async {
    try {
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      String url = urlFormat(ApiUrl.getChannelData, tdFormat, dataFormat,
          firstDate, lastDate, position, name);
      final response = await ApiMethod(url: url, token: token).getDioRequest();
      return response;
    } catch (e) {
      // log(e.toString());
    }
  }

//=============================! Get Channel Position Wise Data !==================================
  getChannelPositionWiseData(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? position,
      String? name}) async {
    try {
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      String url = name == "All"
          ? urlFormatTse(ApiUrl.getChannelPositionWise, tdFormat, dataFormat,
              firstDate, lastDate, position, name)
          : urlFormatSubordinatesNames(
              "${ApiUrl.getChannelSubordinateWise}$name",
              tdFormat,
              dataFormat,
              firstDate,
              lastDate);
      final response = await ApiMethod(url: url, token: token).getDioRequest();
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//=============================! Get Model Wise Data !===========================

  getModelWiseData(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? name,
      String? position}) async {
    try {
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      String url = urlFormatTse(ApiUrl.getModelData, tdFormat, dataFormat,
          firstDate, lastDate, position, name);
      final response = await ApiMethod(url: url, token: token).getDioRequest();
      return response;
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }

//=============================! Get Model Position Wise Data !===========================

  getModelPositionWiseData(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? position,
      String? name}) async {
    try {
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      String url = name == "All"
          ? urlFormatTse(ApiUrl.getModelPositionWise, tdFormat, dataFormat,
              firstDate, lastDate, position, name)
          : urlFormatSubordinatesNames("${ApiUrl.getModelSubordinateWise}$name",
              tdFormat, dataFormat, firstDate, lastDate);
      final response = await ApiMethod(url: url, token: token).getDioRequest();
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//=============================! Get Dealer Model Wise Data !===========================
  getDealerModelWiseData(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? name,
      String? position}) async {
    try {
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      String url = urlFormatTse(ApiUrl.getDealerModelData, tdFormat, dataFormat,
          firstDate, lastDate, position, name);
      final response = await ApiMethod(url: url, token: token).getDioRequest();
      return response;
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }

//=============================! Get All Subordinates !===========================

  getAllSubordinates() async {
    try {
      String subordinateUrl = ApiUrl.getAllSubordinates;
      final token = await ref.read(secureStoargeProvider).readData('authToken');

      final response =
          await ApiMethod(url: subordinateUrl, token: token).getDioRequest();
      return response;
    } catch (e) {
      log("Error in getAllSubordinates: $e");
      return null;
    }
  }

//=============================! Get Dealer Segment Data !=====================================
  getDealerSegmetData({
    String? startDate,
    String? endDate,
    String? dataFormat,
    String? dealerCode,
    String? tdFormat,
  }) async {
    try {
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      String url = dealerSegmentUrl(ApiUrl.getDealerSegmentData, startDate,
          endDate, dataFormat, dealerCode, tdFormat);
      final response =
          await ApiMethod(url: url, token: "Bearer $token").getDioRequest();
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//=============================! Get Dealer Dashboard Data !=====================================
  getDealerDashboardData({
    String? startDate,
    String? endDate,
    String? dataFormat,
    String? dealerCode,
    String? tdFormat,
  }) async {
    try {
      String url = dealerSegmentUrl(ApiUrl.getDealerDashboardData, startDate,
          endDate, dataFormat, dealerCode, tdFormat);
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      final response =
          await ApiMethod(url: url, token: "Bearer $token").getDioRequest();
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//=============================! Get Dealer Channel Data !=====================================

  getDealerChannelData({
    String? startDate,
    String? endDate,
    String? dataFormat,
    String? dealerCode,
    String? tdFormat,
  }) async {
    try {
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      String url = dealerSegmentUrl(ApiUrl.getDealerChannelData, startDate,
          endDate, dataFormat, dealerCode, tdFormat);
      final response =
          await ApiMethod(url: url, token: "Bearer $token").getDioRequest();
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//=============================! Get DealerListData !=====================================

  getDealerListForEmployeeData({
    String? startDate,
    String? endDate,
    String? dataFormat,
    String? dealerCategory,
    String? tdFormat,
  }) async {
    try {
      log("StartDate$startDate, EndDate$endDate, DataFormat$dataFormat, DealerCategory$dealerCategory, TD Foramat$tdFormat");
      final token = await ref.read(secureStoargeProvider).readData('authToken');
      String url = dealerForEmployeeUrl(ApiUrl.getDealerListForEmployeesData,
          startDate, endDate, dataFormat, dealerCategory, tdFormat);
      log("URl:$url");
      final response =
          await ApiMethod(url: url, token: "$token").getDioRequest();
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  getSalesDataSegmetWiseForEmployes(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? dealerCode}) async {
    try {
      String url = urlFormatGetDataByDealerCode(
          ApiUrl.getSegmentDataByDealerCode,
          tdFormat,
          dataFormat,
          firstDate,
          lastDate,
          dealerCode);
      final response = await ApiMethod(url: url).getDioRequest();
      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  getSalesDataChannelWiseForEmployes(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? dealerCode}) async {
    try {
      String url = urlFormatGetDataByDealerCode(
          ApiUrl.getSalesDataChannelWiseForEmployee,
          tdFormat,
          dataFormat,
          firstDate,
          lastDate,
          dealerCode);
      final response = await ApiMethod(url: url).getDioRequest();
      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  getSalesDataModelWiseForEmployes(
      {String? tdFormat,
      String? dataFormat,
      String? firstDate,
      String? lastDate,
      String? dealerCode}) async {
    try {
      String url = urlFormatGetDataByDealerCode(
          ApiUrl.getSalesDataModelWiseForEmployee,
          tdFormat,
          dataFormat,
          firstDate,
          lastDate,
          dealerCode);
      final response = await ApiMethod(url: url).getDioRequest();
      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}

//================================! URL Format !==============================

String dealerForEmployeeUrl(String baseUrl, String? startDate, String? endDate,
    String? dataFormat, String? dealerCategory, String? tdFormat) {
  String url = baseUrl;

  Map<String, String?> queryParams = {
    'start_date': startDate,
    'end_date': endDate,
    'data_format': dataFormat,
    'td_format': tdFormat,
    'dealer_category': dealerCategory,
  };

  String queryString = queryParams.entries
      .where((entry) => entry.value != null)
      .map((entry) => '${entry.key}=${entry.value}')
      .join('&');

  if (queryString.isNotEmpty) {
    url += '?$queryString';
  }

  return url;
}

String dealerSegmentUrl(String baseUrl, String? startDate, String? endDate,
    String? dataFormat, String? dealerCode, String? tdFormat) {
  String url = baseUrl;

  Map<String, String?> queryParams = {
    'start_date': startDate,
    'end_date': endDate,
    'data_format': dataFormat,
    'td_format': tdFormat,
    'dealer_code': dealerCode,
  };

  String queryString = queryParams.entries
      .where((entry) => entry.value != null)
      .map((entry) => '${entry.key}=${entry.value}')
      .join('&');

  if (queryString.isNotEmpty) {
    url += '?$queryString';
  }

  return url;
}

String urlFormat(
  String baseUrl,
  String? tdFormat,
  String? dataFormat,
  String? firstDate,
  String? lastDate,
  String? position,
  String? name,
) {
  String url = baseUrl;
  List<String> params = [];

  if (tdFormat != null) {
    params.add('td_format=$tdFormat');
  }
  if (dataFormat != null) {
    params.add('data_format=$dataFormat');
  }
  if (firstDate != null) {
    params.add('start_date=$firstDate');
  }
  if (lastDate != null) {
    params.add('end_date=$lastDate');
  }
  if (position != null) {
    params.add('position_category=$position');
  }
  if (name != null) {
    params.add('name=$name');
  }

  if (params.isNotEmpty) {
    url += '?${params.join('&')}';
  }

  return url;
}

String urlFormatTse(
    String baseUrl,
    String? tdFormat,
    String? dataFormat,
    String? firstDate,
    String? lastDate,
    String? position,
    String? name // Added 'name' here
    ) {
  String url = baseUrl;

  Map<String, String?> queryParams = {
    'td_format': tdFormat,
    'start_date': firstDate,
    'end_date': lastDate,
    'data_format': dataFormat,
    if (position != null)
      'position_category': position, // Added position to 'position_category'
  };

  String queryString = queryParams.entries
      .where((entry) => entry.value != null)
      .map((entry) => '${entry.key}=${entry.value}')
      .join('&');

  if (queryString.isNotEmpty) {
    url += '?$queryString';
  }

  return url;
}

String urlFormatGetDataByDealerCode(
    String baseUrl,
    String? tdFormat,
    String? dataFormat,
    String? firstDate,
    String? lastDate,
    String? dealerCode // Added dealerCode
    ) {
  String url = baseUrl;

  Map<String, String?> queryParams = {
    'td_format': tdFormat,
    'start_date': firstDate,
    'end_date': lastDate,
    'data_format': dataFormat,
    if (dealerCode != null)
      'dealerCode': dealerCode // Added dealerCode to queryParams
  };

  String queryString = queryParams.entries
      .where((entry) => entry.value != null)
      .map((entry) => '${entry.key}=${entry.value}')
      .join('&');

  if (queryString.isNotEmpty) {
    url += '?$queryString';
  }

  return url;
}

String urlFormatSubordinatesNames(String baseUrl, String? tdFormat,
    String? dataFormat, String? firstDate, String? lastDate) {
  String url = baseUrl;

  Map<String, String?> queryParams = {
    'td_format': tdFormat,
    'start_date': firstDate,
    'end_date': lastDate,
    'data_format': dataFormat,
  };

  String queryString = queryParams.entries
      .where((entry) => entry.value != null)
      .map((entry) => '${entry.key}=${entry.value}')
      .join('&');

  if (queryString.isNotEmpty) {
    url += '?$queryString';
  }

  return url;
}
