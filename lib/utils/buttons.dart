import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siddha_connect/utils/sizes.dart';
import 'common_style.dart';

class OutlinedBtn extends StatelessWidget {
  final String btnName;
  final Function() onPressed;

  const OutlinedBtn({
    super.key,
    required this.btnName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width(context) * 0.9,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          btnName,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class Btn extends StatelessWidget {
  final String? btnName;
  final double? btnHeight, btnWidth, fontSize;
  final Function() onPressed;
  final bool isLoading;

  const Btn({
    super.key,
    this.btnName,
    required this.onPressed,
    this.btnHeight,
    this.btnWidth,
    this.fontSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: btnWidth ?? width(context) * 0.9,
      height: btnHeight ?? 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: AppColor.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColor.whiteColor,
                  strokeWidth: 2,
                ),
              )
            : Text(
                btnName ?? '',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: fontSize ?? 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ),
    );
  }
}

