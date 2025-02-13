import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:math';

// Function to calculate distance using the Haversine formula
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371000; // Earth radius in meters
  double dLat = (lat2 - lat1) * (pi / 180);
  double dLon = (lon2 - lon1) * (pi / 180);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * (pi / 180)) * cos(lat2 * (pi / 180)) *
          sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return R * c; // Distance in meters
}

// Function to update dealer status
Future<void> _updateDealerStatus(String scheduleId, String dealerId, String status) async {
  const String apiUrl = "https://your-api-url.com/updateStatus"; // Replace with your actual API URL

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "scheduleId": scheduleId,
        "dealerId": dealerId,
        "status": status,
      }),
    );

    if (response.statusCode == 200) {
      debugPrint("Dealer status updated successfully.");
    } else {
      debugPrint("Failed to update dealer status. Status Code: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("Error updating dealer status: $e");
  }
}
