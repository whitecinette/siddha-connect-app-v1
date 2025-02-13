import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siddha_connect/profile/screen/dealerProfile/get_dealer_profile.dart';
import 'package:siddha_connect/profile/screen/employeeProfile/employ_profile.dart';
import 'package:siddha_connect/utils/navigation.dart';
import 'package:siddha_connect/utils/providers.dart';
import 'common_style.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealer = ref.watch(dealerRoleProvider);

    return AppBar(
      foregroundColor: AppColor.whiteColor,
      backgroundColor: AppColor.primaryColor,
      titleSpacing: 0,
      centerTitle: false,
      title: SvgPicture.asset("assets/images/logo.svg"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              dealer == "dealer"
                  ? navigateTo(const ProfileScreen())
                  : navigateTo(const EmployProfile());
            },
            onLongPress: () {},
            child: SvgPicture.asset(
              "assets/images/profile.svg",
              height: 28,
              width: 28,
            ),
          ),
        ),
      ],
    );
  }
}
