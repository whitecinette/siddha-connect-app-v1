import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siddha_connect/utils/common_style.dart';
import '../../salesDashboard/screen/sales_dashboard.dart';
import '../../utils/buttons.dart';
import '../../utils/cus_appbar.dart';
import '../../utils/drawer.dart';
import '../../utils/navigation.dart';
import '../../utils/sizes.dart';
import '../repo/upload_data_repo.dart';
import 'upload_sales_data.dart';

class UploadSegmentTarget extends ConsumerWidget {
  const UploadSegmentTarget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: const CustomAppBar(),
      drawer: const CusDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopBarHeading(title: "Segment Target Upload"),
              UploadContainer(isLoading: isLoading),
              heightSizedBox(30.0),
              Btn(
                btnName: "Upload",
                onPressed: () async {
                  final filePath = ref.read(filePathProvider);
                  if (filePath != null) {
                    ref.read(isLoadingProvider.notifier).state = true;
                    try {
                      await ref
                          .read(salesDataUploadRepoProvider)
                          .segmentTargetUpload(
                            file: File(filePath),
                          );
                      if (!ref.read(isCancelRequestedProvider)) {
                        // navigatePushReplacement(SalesDashboard());
                      }
                    } catch (e) {
                      // Handle the error
                    } finally {
                      ref.read(isLoadingProvider.notifier).state = false;
                      ref.read(filePathProvider.notifier).state = null;
                      ref.read(fileNameProvider.notifier).state = null;
                    }
                  } else {
                    showErrorDialog(
                      message: 'No file selected. Please upload a .csv file.',
                      context: context,
                    );
                  }
                },
              ),
              heightSizedBox(10.0),
              Text(
                "OR",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff7F7F7F),
                  ),
                ),
              ),
              heightSizedBox(10.0),
              OutlinedBtn(
                btnName: "Cancel",
                onPressed: () {
                  if (!isLoading) {
                    navigatePushReplacement(const SalesDashboard());
                  } else {
                    ref.read(isCancelRequestedProvider.notifier).state = true;
                    ref.read(isLoadingProvider.notifier).state = false;
                    // Navigator.pop(context);
                  }
                },
              ),
              heightSizedBox(20.0),
              const Divider(indent: 50.0, endIndent: 50.0)
            ],
          ),
        ),
      ),
    );
  }
}

class TopBarHeading extends StatelessWidget {
  final String title;
  final String? src;
  const TopBarHeading({
    super.key,
    required this.title,
    this.src,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          src ?? "assets/images/dashboard.svg",
          height: 25,
          width: 25,
        ),
        widthSizedBox(10.0),
        Text(
          title,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
