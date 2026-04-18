import 'package:indapur_team/utils/exported_path.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: Routes.splash, page: () => SplashScreen()),
    GetPage(name: Routes.login, page: () => LoginScreen()),
    GetPage(name: Routes.mainScreen, page: () => NavigationScreen()),
    GetPage(name: Routes.complaintDetails, page: () => ComplaintDetails()),
    GetPage(name: Routes.updateComplaint, page: () => UpdateComplaint()),
    GetPage(name: Routes.editProfile, page: () => EditProfile()),
    GetPage(name: Routes.helpSupport, page: () => HelpSupport()),
    GetPage(name: Routes.deleteAccount, page: () => DeleteAccount()),
    GetPage(name: Routes.notificationList, page: () => NotificationList()),
  ];
}
