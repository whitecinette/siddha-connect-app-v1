import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:siddha_connect/beatmapping/fetched_location.dart';
import 'package:siddha_connect/beatmapping/repo/beat_mapping_repo.dart';
import 'package:dio/dio.dart';

Dio dio = Dio();

// Provider for BeatMappingRepo
final beatMappingRepoProvider = Provider((ref) => BeatMappingRepo(ref));

class BeatMappingScreen extends ConsumerStatefulWidget {
  @override
  _BeatMappingScreenState createState() => _BeatMappingScreenState();
}

class _BeatMappingScreenState extends ConsumerState<BeatMappingScreen> {
  String _selectedDay = "Mon"; // Default to Monday
  final List<String> _weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  Map<String, List<Map<String, dynamic>>> _weeklySchedule = {};
  String _scheduleId = " ";
  bool _isLoading = false;
  bool _isUpdating = false;

  Map<String, bool> _isUpdatingMap = {}; // Track button states

  @override
  void initState() {
    super.initState();

    // Get the current weekday index (1 = Monday, 7 = Sunday)
    int currentDayIndex = DateTime.now().weekday;

    // Map the weekday index to the corresponding day string
    _selectedDay = _weekDays[currentDayIndex - 1]; // _weekDays starts from "Mon"

    // Fetch the data for the selected day
    _fetchBeatMappingData();
  }

  Future<void> _fetchBeatMappingData() async {
    setState(() => _isLoading = true);
    final response = await ref.read(beatMappingRepoProvider).fetchWeeklyBeatMappingSchedule("SC-TSE0003");
    log("API Response: ${response.toString()}");

    if (response != null && response['data'] != null && response['data'] is List) {
      setState(() {
        var data = response['data'][0]['schedule'];
        // print("data: ${data}");
        log("Trynna: ${response['data']}");
        _weeklySchedule = {
          "Mon": List<Map<String, dynamic>>.from(data["Mon"] ?? []),
          "Tue": List<Map<String, dynamic>>.from(data["Tue"] ?? []),
          "Wed": List<Map<String, dynamic>>.from(data["Wed"] ?? []),
          "Thu": List<Map<String, dynamic>>.from(data["Thu"] ?? []),
          "Fri": List<Map<String, dynamic>>.from(data["Fri"] ?? []),
          "Sat": List<Map<String, dynamic>>.from(data["Sat"] ?? []),
        };
        _scheduleId = response['data'][0]['_id'];
        // print("Schedule id: ${_scheduleId}");
      });
    }
    setState(() => _isLoading = false);
  }


  // Future<void> _updateDealerStatusWithProximity(BuildContext parentContext, String scheduleId, String dealerId) async {
  //   if (!parentContext.mounted) return;
  //
  //   print("Reaching _Update....");
  //   print("Schedule id, dealer id: ${scheduleId}, ${dealerId}");
  //
  //   _showLoadingPopup(parentContext); // Show loading popup
  //
  //   try {
  //     final response = await ref.read(beatMappingRepoProvider).updateDealerStatusWithProximity(scheduleId, dealerId);
  //     log("📌 Dealer status response after fix: $response");
  //
  //     if (response == null) {
  //       log("🚨 API returned null response. This should not happen anymore.");
  //       _showResponsePopup(parentContext, "API returned no response. Please try again.", "N/A", true);
  //       return;
  //     }
  //
  //     bool isError = response.containsKey('error');
  //     String message = response['message'] ?? '❌\n Could not mark done!\n' + response['error'] + '\nDistance: ' + (response['distanceFromDealer'] ?? "No distance available.");
  //     String distance = response.containsKey('distanceFromDealer') ? response['distanceFromDealer'].toString() : "N/A";
  //
  //
  //     _showResponsePopup(parentContext, message, distance, isError);
  //   } catch (e) {
  //     log("❌ Unexpected error in dealer status update: $e");
  //     _showResponsePopup(parentContext, "Something went wrong. Please try again.", "N/A", true);
  //   } finally {
  //     try {
  //       if (parentContext.mounted) {
  //         Future.delayed(Duration(seconds: 10), () {
  //           if (parentContext.mounted) {
  //             Navigator.of(parentContext, rootNavigator: true).pop();
  //           }
  //         });
  //       }
  //     } catch (e) {
  //       log("⚠️ Popup already closed: $e");
  //     }
  //   }
  // }

  Future<void> _updateDealerStatusWithProximity(BuildContext parentContext, String scheduleId, String dealerId) async {
    if (!parentContext.mounted) return;

    print("Reaching _Update....");
    print("Schedule id, dealer id: ${scheduleId}, ${dealerId}");

    setState(() {
      _isUpdatingMap[dealerId] = true; // Mark only this button as updating
    });

    _showLoadingPopup(parentContext); // Show loading popup

    try {
      final response = await ref.read(beatMappingRepoProvider).updateDealerStatusWithProximity(scheduleId, dealerId);
      log("📌 Dealer status response after fix: $response");

      if (response == null) {
        log("🚨 API returned null response. This should not happen anymore.");
        _showResponsePopup(parentContext, "API returned no response. Please try again.", "N/A", true);
        return;
      }

      bool isError = response.containsKey('error');
      String message = response['message'] ?? '❌\n Could not mark done!\n' + response['error'] + '\nDistance: ' + (response['distanceFromDealer'] ?? "No distance available.");
      String distance = response.containsKey('distanceFromDealer') ? response['distanceFromDealer'].toString() : "N/A";

      if (!isError) {
        // ✅ Update dealer status in `_weeklySchedule`
        setState(() {
          for (var dealer in _weeklySchedule[_selectedDay] ?? []) {
            if (dealer["_id"] == dealerId) {
              dealer["status"] = "done"; // Update status in the UI
            }
          }
        });
      }

      _showResponsePopup(parentContext, message, distance, isError);
    } catch (e) {
      log("❌ Unexpected error in dealer status update: $e");
      _showResponsePopup(parentContext, "Something went wrong. Please try again.", "N/A", true);
    } finally {
      setState(() {
        _isUpdatingMap[dealerId] = false; // Reset only this button
      });

      try {
        if (parentContext.mounted) {
          Future.delayed(Duration(seconds: 10), () {
            if (parentContext.mounted) {
              Navigator.of(parentContext, rootNavigator: true).pop();
            }
          });
        }
      } catch (e) {
        log("⚠️ Popup already closed: $e");
      }
    }
  }

  Future<dynamic> putDioRequest({required String url, required Map<String, dynamic> data}) async {
    try {
      final response = await dio.put(url, data: data);

      log("✅ Dio Response: ${response.data}");

      return response.data;  // ✅ Return response normally

    } on DioException catch (dioError) {
      log("❌ DioException caught: Status Code: ${dioError.response?.statusCode}");

      // ✅ Ensure error response is returned properly
      if (dioError.response != null && dioError.response?.data is Map<String, dynamic>) {
        return dioError.response!.data; // 🔥 This is the fix!
      }

      return {"error": "Unknown error occurred.", "distanceFromDealer": "N/A"};  // Default error message
    }
  }

  void _showLoadingPopup(BuildContext parentContext) {
    // showDialog(
    //   context: parentContext,
    //   barrierDismissible: false, // Prevents accidental closing
    //   builder: (BuildContext dialogContext) {
    //     return AlertDialog(
    //       content: Row(
    //         children: [
    //           CircularProgressIndicator(),
    //           SizedBox(width: 15),
    //           Text("Updating dealer status..."),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }


  void _showResponsePopup(BuildContext parentContext, String message, String distance, bool isError) {
    if (!parentContext.mounted) return;

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            isError ? "Error" : "Success",
            style: TextStyle(color: isError ? Colors.red : Colors.green),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message, // Show actual API message
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              if (!isError && distance != "N/A")
                Text(
                  "Distance from Dealer: $distance",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLocationPopup(BuildContext context, String location, String scheduleId, String dealerId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Current Location"),
          content: Text(location),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog first

                // Pass parent context (widget context) to avoid "context no longer valid" issue
                await _updateDealerStatusWithProximity(context, scheduleId, dealerId);
              },
              child: Text("OK"),
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());
    int currentDayIndex = DateTime.now().weekday; // Get current weekday index

    return Scaffold(
      appBar: AppBar(
        title: Text("Beat Mapping", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFFF5F5F5))),
        backgroundColor: Color(0xFF003F91),
        actions: [
          TextButton(
            onPressed: _fetchBeatMappingData,
            child: Text("Refresh Data", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 90,
            decoration: BoxDecoration(
              color:  Color(0xFF005BB5),
              boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5)],
            ),
            child: ListView.builder(
              itemCount: _weekDays.length,
              itemBuilder: (context, index) {
                String day = _weekDays[index];
                String dayInitial = day.substring(0, 1).toUpperCase();
                return GestureDetector(
                  onTap: () => setState(() => _selectedDay = day),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: _selectedDay == day ? Color(0xFFD8EAFB) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        dayInitial,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _selectedDay == day ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Today's Date: $currentDate",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  if (_isLoading) Center(child: CircularProgressIndicator(color: Colors.teal)),
                  Expanded(
                    child: _weeklySchedule[_selectedDay]?.isEmpty ?? true
                        ? Center(
                      child: Text(
                        "No Shops Found",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _weeklySchedule[_selectedDay]?.length ?? 0,
                      itemBuilder: (context, index) {
                        var shop = _weeklySchedule[_selectedDay]?[index];

                        bool isToday = DateTime.now().weekday == currentDayIndex;
                        bool isDisabled = !isToday; // Disable marking for non-current days

                        return Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.shade400, blurRadius: 6, offset: Offset(2, 2)),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Text(
                                    shop?["dealerCode"] ?? "N/A",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF003F91)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  shop?["dealerName"] ?? "Unknown",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xFF333333)),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: (shop?["status"] == "done" || (_isUpdatingMap[shop?["_id"]] ?? false) || isDisabled)
                                      ? null
                                      : () => _updateDealerStatusWithProximity(context, _scheduleId, shop?["_id"] ?? ""),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: shop?["status"] == "done" ? Color(0xFF28C76F) : Color(0xFFFF6B3B),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: (_isUpdatingMap[shop?["_id"]] ?? false)
                                      ? SizedBox(width: 8, height: 8, child: CircularProgressIndicator(strokeWidth: 0.5,))
                                      :  Text(shop?["status"] == "done" ? "Done" : "Mark", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
