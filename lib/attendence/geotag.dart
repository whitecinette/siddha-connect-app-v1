import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siddha_connect/attendence/repo/attendence_repo.dart';

import '../extraction/components/dealer_dropdown.dart';
import '../extraction/screens/data_upload_form.dart';
import '../utils/common_style.dart';
import '../utils/cus_appbar.dart';
import '../utils/sizes.dart';
import 'attendence_screen.dart';
import 'location_service.dart';

class GeoTagScreen extends ConsumerWidget {
  const GeoTagScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getLetLong = ref.watch(coordinatesProvider);
    final locationMessage = ref.watch(locationMessageProvider);
    final address = ref.watch(addressProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final dealerList = ref.watch(getDealerListProvider);
    final selectedDealer = ref.watch(selectedDealerProvider);

    log("Latitude and Longitude ${getLetLong['latitude'].runtimeType}");
    return dealerList.when(
      data: (data) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(),
          body: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSizedBox(10.0),

                DealerDropDown(data: data),
                // Text(
                //   "",
                //   style: GoogleFonts.lato(
                //       fontWeight: FontWeight.w600, fontSize: 22.sp),
                // ),
                heightSizedBox(10.0),
                const SizedBox(height: 20),
                isLoading
                    ? const SpinKitThreeBounce(
                        color: AppColor.primaryColor,
                        size: 28,
                      )
                    : Row(
                        children: [
                          Flexible(
                            child: Text(
                              address,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final locationService = LocationService(ref);
                              locationService.getLocation();
                            },
                            icon: const Icon(
                              Icons.refresh,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          bottomNavigationBar: SubmitButton(
            latitude: getLetLong['latitude']!,
            longitude: getLetLong['longitude']!,
          ),
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text("Something went wrong"),
      ),
      loading: () => const Center(
        child: SpinKitCircle(
          color: AppColor.primaryColor,
        ),
      ),
    );
  }
}

class SubmitButton extends ConsumerWidget {
  final double latitude, longitude;

  const SubmitButton({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () {
          final dealer = ref.read(selectedDealerProvider);

          if (dealer != null) {
            ref.read(attendenceRepoProvider).dealerGeoTag(data: {
              'dealerCode': dealer['BUYER CODE'],
              'latitude': latitude,
              'longitude': longitude
            });
          } else {
            // Handle the case when dealer is null
            print("Dealer is null");
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            foregroundColor: Colors.white,
            overlayColor: Colors.white,
            elevation: 2,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shadowColor: Colors.grey),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.login),
            widthSizedBox(8.0),
            Text(
              'Submit',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
