import 'dart:developer';
import '../../../utils/api_method.dart';
import 'package:siddha_connect/utils/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siddha_connect/utils/location_helper.dart';
import 'package:geolocator/geolocator.dart';

class BeatMappingRepo {
  final ProviderRef ref;

  BeatMappingRepo(this.ref);

  Future<dynamic> fetchWeeklyBeatMappingSchedule(String userCode) async {
    try {
      log("entering");

      // Retrieve token
      String? token = await ref.read(secureStoargeProvider).readData('authToken'); // Get the stored token
      print("Token: ${token}");
      if (token == null) {
        log("No token found, authentication required.");
        return {"error": "Unauthorized"};
      }

      // Define headers with Authorization
      Map<String, String> headers = {
        "Authorization": "$token", // Attach token
        "Content-Type": "application/json"
      };

      final response = await ApiMethod(
        url: ApiUrl.getWeeklyBeatMapping,
        token: token, // Pass token directly
      ).getDioRequest();

      log("API URL: ${ApiUrl.getWeeklyBeatMapping}$userCode");
      log("API Response: ${response.toString()}");
      return response;
    } catch (e) {
      log("Error fetching data: $e");
    }
  }

  Future<dynamic> updateDealerStatus(String scheduleId, String dealerId, String status, double? latitude, double? longitude) async {
    try {
      final response = await ApiMethod(
        url: "${ApiUrl.updateDealerStatus}$scheduleId/dealer/$dealerId/status",
      ).putDioRequest(data: {"status": status});

      log("Dealer status update response: ${response.toString()}");
      return response;
    } catch (e) {
      log("Error updating dealer status: $e");
    }
  }

  Future<dynamic> updateDealerStatusWithProximity(String scheduleId, String dealerId) async {
    try {
      print("Reaching the update func");
      print("Schedule Id, Dealer Id :D ${scheduleId}, ${dealerId}");

      // Get user location
      Position? position = await LocationHelper.getUserLocation();
      if (position == null) {
        return {"error": "Could not get user location"};
      }

      double latitude = position.latitude;
      double longitude = position.longitude;
      log("lat, long: ${latitude}, ${longitude}");

      String finalUrl = "${ApiUrl.storeLocation}/$scheduleId/dealer/$dealerId/status-proximity";

      // Logging the full API URL
      log("API URL: $finalUrl");

      final response = await ApiMethod(
        url: finalUrl,
      ).putDioRequest(data: {
        "employeeLat": latitude, // Default latitude
        "employeeLong": longitude, // Default longitude
        "status": "done" // Default status
      });

      log("Dealer status with proximity update response: ${response.toString()}");
      return response;
    } catch (e) {
      log("Error updating dealer status with proximity: $e");
      return {"error": e.toString()}; // Return an error response
    }
  }


}
