import 'package:indapur_team/common/update_app_new.dart';
import 'package:indapur_team/utils/exported_path.dart';
import 'package:map_camera_flutter/map_camera_flutter.dart';
import 'package:ui_package/ui_package.dart' hide LocalStorage;

@lazySingleton
class DashboardController extends GetxController {
  final ApiService _apiService = Get.find();
  final searchController = TextEditingController();

  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final dashboardData = {}.obs;
  final monthlyData = {}.obs;
  final chartData = [].obs;
  final deadComplaints = [].obs;
  final recentComplaint = [].obs;
  final complaintTypeData = {}.obs;

  Future<void> getDashboard({bool load = true}) async {
    if (load) {
      isLoading.value = true;
    } else {
      isRefreshing.value = true;
    }

    final userId = await LocalStorage.getString('user_id') ?? '';
    final lang = getIt<TranslateController>().lang.value == 'mr' ? 'mr' : 'en';
    try {
      final res = await _apiService.getDashboard(userId, lang);

      if (res['common']['status'] == true) {
        dashboardData.value = res['data'][0] ?? {};
        monthlyData.value = dashboardData['monthly_complaint'] ?? {};
        if (monthlyData.isNotEmpty) setChartData(monthlyData);
        complaintTypeData.value = dashboardData['complaint_type_counts'] ?? {};
        deadComplaints.value = dashboardData['dead_complaints'] ?? [];
        recentComplaint.value = dashboardData['recent_complaint'] ?? [];
        handleUpdate(Platform.isAndroid ? res['android'] : res['ios']);
        final platformData = Platform.isAndroid
            ? res['android'] ?? {}
            : res['ios'] ?? {};

        /// 🔥 Maintenance Check (Unified)
        if (platformData['is_maintenance'] == true) {
          Get.offAll(
            () => MaintenanceScreen(
              message: platformData['maintenance_msg'] ?? '',
              imageAsset: Images.maintenance,
              buttonText: 'Close App',
              buttonBorderColor: AppColors.primary,
              buttonTextColor: AppColors.primary,
            ),
            transition: Transition.rightToLeftWithFade,
          );
        }
        // if (Platform.isAndroid) {
        //   if (res['android']['is_maintenance'] == true) {
        //     Get.offAll(
        //       () => MaintenanceScreen(
        //         message: res['android']['maintenance_msg'] ?? '',
        //         imageAsset: Images.maintenance,
        //       ),
        //       transition: Transition.rightToLeftWithFade,
        //     );
        //   }
        // } else if (Platform.isIOS) {
        //   if (res['ios']['is_maintenance'] == true) {
        //     Get.offAll(
        //       () => Maintenance(msg: res['ios']['maintenance_msg'] ?? ''),
        //       transition: Transition.rightToLeftWithFade,
        //     );
        //   }
        // }
      } else {
        dashboardData.value = {};
        recentComplaint.value = [];
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
    } finally {
      if (load) {
        isLoading.value = false;
      } else {
        isRefreshing.value = false;
      }
    }
  }

  void setChartData(dynamic data) {
    List temp = [];

    data.forEach((month, value) {
      temp.add({
        "month": month,
        "pending": value["pending"]["value"],
        "inProgress": value["in-progress"]["value"],
        "completed": value["completed"]["value"],
        "rejected": value["rejected"]["value"],
      });
    });

    chartData.value = temp.toList();
  }

  double getMaxComplaintCount() {
    double maxValue = 0;

    for (var item in chartData) {
      double total =
          ((item["pending"] ?? 0) +
                  (item["inProgress"] ?? 0) +
                  (item["completed"] ?? 0) +
                  (item["rejected"] ?? 0))
              .toDouble();

      if (total > maxValue) {
        maxValue = total.toDouble();
      }
    }

    return maxValue + 5; // spacing above bars
  }

  int countFromKey(String key) {
    return int.tryParse(dashboardData[key]?.toString() ?? '') ?? 0;
  }

  bool get hasDashboardData =>
      dashboardData.isNotEmpty ||
      recentComplaint.isNotEmpty ||
      countFromKey('total_complaints') > 0;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
