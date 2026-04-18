// import 'package:indapur_team/common/app_under_maintainance.dart';
// import 'package:indapur_team/utils/exported_path.dart';
//
// @injectable
// class NetworkController extends GetxController {
//   final _connectionChecker = InternetConnectionChecker.instance;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _connectionChecker.onStatusChange.listen(_updateConnectionStatus);
//   }
//
//   void _updateConnectionStatus(InternetConnectionStatus status) async {
//     if (status == InternetConnectionStatus.disconnected) {
//       if (!(Get.isDialogOpen ?? false)) {
//         showNoInternetDialog();
//       }
//     } else {
//       if (Get.isDialogOpen ?? false) {
//         Get.back(); // Close the dialog
//       }
//
//       // Check for maintenance if internet comes back
//       await checkMaintenance();
//     }
//   }
// }
//
// Future<void> checkMaintenance() async {
//   try {
//     var profileData = await getIt<ProfileController>().getProfile2();
//     if (profileData['android']['is_maintenance'] == true) {
//       Get.offAll(
//         () => Maintenance(msg: profileData['android']['maintenance_msg'] ?? ''),
//         transition: Transition.rightToLeftWithFade,
//       );
//     }
//   } catch (_) {
//     // handle error
//   }
// }
