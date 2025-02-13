import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siddha_connect/auth/repo/auth_repo.dart';
import 'package:siddha_connect/salesDashboard/screen/sales_dashboard.dart';
import 'package:siddha_connect/utils/navigation.dart';
import 'package:siddha_connect/utils/secure_storage.dart';
import 'package:siddha_connect/auth/screens/status_screen.dart';

final authControllerProvider = Provider.autoDispose((ref) {
  final authRepo = ref.watch(authRepoProvider);

  return AuthController(authRepo: authRepo, ref: ref);
});

class AuthController {
  final Ref ref;
  final AuthRepo authRepo;

  AuthController({required this.authRepo, required this.ref});

  registerController({required Map data}) async {
    try {
      final res = await authRepo.userRegisterRepo(data: data);
      if (res['user']['verified'] == false) {
        ref
            .watch(secureStoargeProvider)
            .writeData(key: 'authToken', value: res['token']);
        navigateTo(const StatusScreen());
      } else {
        ref
            .watch(secureStoargeProvider)
            .writeData(key: 'authToken', value: res['token']);
        navigateTo(const SalesDashboard());
      }
      return res;
    } catch (e) {
      log(e.toString());
    }
  }

  userLogin({required Map data}) async {
    try {
      log("Entering userLogin function");
      final res = await authRepo.userLoginRepo(data: data);

      log("Response received: $res");

      if (res != null &&
          res['message'] == 'User logged in successfully' &&
          res['verified'] == true) {
        log("Token=====${res['token']}");

        if (res['token'] != null) {
          await ref
              .read(secureStoargeProvider)
              .writeData(key: 'authToken', value: "${res['token']}");
        }

        navigateTo(const SalesDashboard());
      } else if (res != null && res['token'] != null) {
        await ref
            .read(secureStoargeProvider)
            .writeData(key: 'authToken', value: "${res['token']}");
        navigateTo(const StatusScreen());
      } else {
        log("Login failed: Response does not contain expected data");
      }

      return res;
    } catch (e, stackTrace) {
      log("Reason: ${e.toString()}");
      log("StackTrace: $stackTrace");
    }
  }


  dealerRegisterController({required Map data}) async {
    try {
      final res = await authRepo.dealerRegisterRepo(data: data);
      if (res['data']['verified'] == false) {
        await ref
            .read(secureStoargeProvider)
            .writeData(key: 'authToken', value: "${res['token']}");
        navigatePushReplacement(const StatusScreen());
        return res;
      } else {
        navigatePushReplacement(const SalesDashboard());
      }
      return res;
    } catch (e) {
      log(e.toString());
    }
  }
}
