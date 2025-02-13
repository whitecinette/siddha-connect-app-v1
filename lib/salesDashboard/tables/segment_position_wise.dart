import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/dashboard_options.dart';
import '../../utils/common_style.dart';
import '../../utils/responsive.dart';
import '../component/dashboard_small_btn.dart';
import '../component/radio.dart';
import '../repo/sales_dashboard_repo.dart';

final positionWiseSegmentDataProvider = FutureProvider.autoDispose((ref) async {
  final options = ref.watch(selectedOptionsProvider);
  final getPositionSegmentData =
      await ref.watch(salesRepoProvider).getSegmentPositionWiseData(
            tdFormat: options.tdFormat,
            dataFormat: options.dataFormat,
            firstDate: options.firstDate,
            lastDate: options.lastDate,
            name: options.name,
            position: options.position!.toUpperCase(),
          );
  return getPositionSegmentData;
});

final getSalesDataSegmentWiseForEmployee =
    FutureProvider.autoDispose((ref) async {
  final options = ref.watch(selectedOptionsProvider);
  final getPositionSegmentData = await ref
      .watch(salesRepoProvider)
      .getSalesDataSegmetWiseForEmployes(
          tdFormat: options.tdFormat,
          dataFormat: options.dataFormat,
          firstDate: options.firstDate,
          lastDate: options.lastDate,
          dealerCode: options.dealerCode);
  return getPositionSegmentData;
});

class SegmentTablePositionWise extends ConsumerWidget {
  const SegmentTablePositionWise({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption2 = ref.watch(selectedOption2Provider);
    final selectedPosition = ref.watch(selectedPositionProvider);
    final segmentData = selectedPosition == "DEALER"
        ? ref.watch(getSalesDataSegmentWiseForEmployee)
        : ref.watch(positionWiseSegmentDataProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final columnSpacing = screenWidth / 12;
    return segmentData.when(
      data: (data) {
        if (data == null || data['columns'] == null || data['data'] == null) {
          return const Center(child: Text('No data available.'));
        }

        final columns = data['columns'] ?? [];
        final rows = data['data'] ?? [];
        return Theme(
          data: Theme.of(context).copyWith(
            dividerTheme: const DividerThemeData(
              color: Colors.white,
            ),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2.2,
            child: DataTable2(
              headingRowHeight: 50,
              dividerThickness: 2.5,
              columnSpacing: columnSpacing,
              fixedTopRows: 2,
              horizontalMargin: 0,
              bottomMargin: 5,
              fixedLeftColumns: 1,
              fixedColumnsColor: const Color(0xffEEEEEE),
              fixedCornerColor: const Color(0xffD9D9D9),
              showBottomBorder: true,
              minWidth: Responsive.isTablet(context) ? 1200.w : 2000.w,
              headingRowColor: WidgetStateColor.resolveWith(
                (states) => const Color(0xffD9D9D9),
              ),
              columns: [
                for (var column in columns)
                  DataColumn(
                    label: GestureDetector(
                      onTap: () {
                        // log("Show Filter");
                      },
                      child: Center(
                        child: Text(
                          column ?? 'Unknown',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: tableTitleStyle(context),
                        ),
                      ),
                    ),
                  ),
              ],
              rows: List.generate(rows.length, (index) {
                final row = rows[index] ?? {};

                return DataRow(
                  color: WidgetStateColor.resolveWith(
                    (states) => const Color(0xffEEEEEE),
                  ),
                  cells: [
                      for (var column in columns)
                    DataCell(
                        Center(
                          child: Text(
                            row[column]?.toString() ?? '',
                            style: tableRowStyle(context),
                            textAlign: TextAlign.center,
                          ),))
                  ],
                );
              }),
            ),
          ),
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text("Something Went Wrong"),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 150),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColor.primaryColor,
          ),
        ),
      ),
    );
  }
}

tableTitleStyle(BuildContext context) {
  return GoogleFonts.lato(
      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold));
}

tableRowStyle(BuildContext context) {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 14,
        fontWeight:
            Responsive.isMobile(context) ? FontWeight.w400 : FontWeight.w500),
  );
}
