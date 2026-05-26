import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:indapur_team/utils/exported_path.dart';
import 'package:intl/intl.dart';

@lazySingleton
class AddCorpComplaintController extends GetxController {
  final ApiService _apiService = Get.find();
  final isDeptLoading = false.obs;
  final isLoading = false.obs;
  final isAddLoading = false.obs;
  final isWardLoading = false.obs;
  final departmentList = [].obs;
  final complaintTypeList = [].obs;
  final wardList = [].obs;
  final latLng = ''.obs;
  final isPageLoading = false.obs;

  Future<void> loadInitialData(String deptId) async {
    try {
      isPageLoading.value = true;
      resetForm();
      await Future.wait([getComplaintType(deptId), getWardList()]);
    } finally {
      isPageLoading.value = false;
    }
  }

  Future<void> getDepartment() async {
    isDeptLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getTeamDept(
        userId,
        getIt<TranslateController>().lang.value == 'mr' ? 'mr' : 'en',
      );
      if (res['common']['status'] == true) {
        departmentList.value = res['data'] ?? [];
      }
    } catch (e) {
      // debugPrint("Login error: $e");
    } finally {
      isDeptLoading.value = false;
    }
  }

  final formKey = GlobalKey<FormState>();
  final selectedWard = RxnString();
  final selectedType = RxnString();

  final landMarkController = TextEditingController();
  final descriptionController = TextEditingController();

  final attachmentList = [].obs;

  Future<void> getComplaintType(String deptId) async {
    isLoading.value = true;
    complaintTypeList.clear();
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getCompType(
        userId,
        deptId,
        getIt<TranslateController>().lang.value == 'mr' ? 'mr' : 'en',
      );
      if (res['common']['status'] == true) {
        complaintTypeList.value = res['data'] ?? [];
      }
    } catch (e) {
      // showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getWardList() async {
    isWardLoading.value = true;
    wardList.clear();

    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getWardList(
        userId,
        getIt<TranslateController>().lang.value == 'mr' ? 'mr' : 'en',
      );
      if (res['common']['status'] == true) {
        wardList.value = res['data'] ?? [];
      }
    } catch (e) {
      // showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isWardLoading.value = false;
    }
  }

  Future<void> addComplaint(String deptId) async {
    isAddLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final docs = await prepareDocuments(attachmentList);
      final details = await getDetails();
      final res = await _apiService.addCorpComplaint(
        userId,
        deptId,
        selectedType.value.toString(),
        landMarkController.text.trim(),
        selectedWard.value.toString(),
        descriptionController.text.trim(),
        details['latLng'] ?? '',
        details['userLocation'] ?? '',
        details['dateTime'] ?? '',
        attachment: docs,
      );
      if (res['common']['status'] == true) {
        showToastNormal(res['common']['message']);
        Get.back();
        Get.offAllNamed(Routes.mainScreen);
        resetForm();
      } else {
        showToastNormal(res['common']['message'] ?? '');
      }
    } catch (e) {
      debugPrint("Login error: $e");
      showToastNormal('Something went wrong. Please try again later.');
    } finally {
      isAddLoading.value = false;
    }
  }

  void resetForm() {
    attachmentList.clear();
    complaintTypeList.clear();
    latLng.value = '';
    selectedWard.value = '';
    selectedType.value = '';
    landMarkController.clear();
    descriptionController.clear();
  }

  Future<Map<String, String>> getDetails() async {
    String latLng = '';
    String userLocation = '';
    String dateTime = '';

    final position = await _getCurrentPosition();
    if (position != null) {
      latLng = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        userLocation =
            '${p.name}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}';
      }
      dateTime = DateFormat('dd MMM yyyy hh:mm a').format(DateTime.now());
    }

    return {
      'latLng': latLng,
      'userLocation': userLocation,
      'dateTime': dateTime,
    };
  }

  Future<Position?> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar('Permission Denied', 'Location access is required.');
        return null;
      }
    }
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }
}
