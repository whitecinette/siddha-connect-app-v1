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

    return Scaffold(
      appBar: AppBar(
        title: Text("Beat Mapping"),
        actions: [
          TextButton(
            onPressed: _fetchBeatMappingData,
            child: Text("Refresh Data", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 80,
            color: Colors.grey.shade200,
            child: ListView.builder(
              itemCount: _weekDays.length,
              itemBuilder: (context, index) {
                String day = _weekDays[index];
                return GestureDetector(
                  onTap: () => setState(() => _selectedDay = day),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    color: _selectedDay == day ? Colors.blue : Colors.transparent,
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedDay == day ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Today's Date: $currentDate",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  if (_isLoading) Center(child: CircularProgressIndicator()),
                  Expanded(
                    child: _weeklySchedule[_selectedDay]?.isEmpty ?? true
                        ? Center(
                      child: Text("No Shops Found", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                    )
                        : ListView.builder(
                      itemCount: _weeklySchedule[_selectedDay]?.length ?? 0,
                      itemBuilder: (context, index) {
                        var shop = _weeklySchedule[_selectedDay]?[index];
                        // print("Shop: ${shop}");
                        return Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 3)],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(shop?["dealerCode"] ?? "N/A")),
                              Expanded(child: Text(shop?["dealerName"] ?? "Unknown")),
                              // Expanded(
                              //   child: ElevatedButton(
                              //     onPressed: _isUpdatingMap ? null : () async {  // Disable button when loading
                              //       setState(() => _isUpdatingMap = true); // Start loader
                              //
                              //       final locationService = BeatMappingLocationService(ref);
                              //       try {
                              //         await locationService.getLocation();
                              //         final coordinates = ref.read(beatMappingCoordinatesProvider);
                              //
                              //         await _updateDealerStatusWithProximity(
                              //             context,
                              //             _scheduleId ?? "",
                              //             shop?["_id"] ?? ""
                              //         );
                              //       } catch (e) {
                              //         _showResponsePopup(context, "Failed to get location: $e", "N/A", true);
                              //       } finally {
                              //         setState(() => _isUpdating = false); // Stop loader
                              //       }
                              //     },
                              //     child: _isUpdating
                              //         ? SizedBox(
                              //       width: 20,
                              //       height: 20,
                              //       child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              //     )
                              //         : Text("Mark"),
                              //   ),
                              // ),
                              Expanded(
                              child: ElevatedButton(
                              onPressed: (shop?["status"] == "done" || (_isUpdatingMap[shop?["_id"]] ?? false))
                              ? null
                                  : () => _updateDealerStatusWithProximity(context, _scheduleId, shop?["_id"] ?? ""),
                              child: (_isUpdatingMap[shop?["_id"]] ?? false)
                              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : Text("Mark"),
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