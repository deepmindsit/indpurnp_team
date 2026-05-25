import 'package:indapur_team/utils/exported_path.dart';

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

  // void pickImage(ImageSource source) async {
  //   isLoading(true);
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(
  //     source: source,
  //     imageQuality: 50,
  //   );
  //   if (image != null) {
  //     File? img = File(image.path);
  //     final details = await getDetails();
  //     Map<String, dynamic> data = {
  //       'path': img,
  //       'from': 'camera',
  //       'latLng': details['latLng'] ?? '',
  //       'userLocation': details['userLocation'] ?? '',
  //       'dateTime': details['dateTime'] ?? '',
  //     };
  //     imageList.add(data);
  //     imageFile = img;
  //   }
  //   isLoading(false);
  // }
  //
  // void pickPdf() async {
  //   isLoading(true);
  //   FilePickerResult? result = await FilePicker.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );
  //   if (result != null) {
  //     File file = File(result.files.single.path!);
  //     Map<String, dynamic> data = {'path': file, 'from': 'pdf'};
  //     imageList.add(data);
  //   }
  //   isLoading(false);
  // }

  // Future<void> showOptions() async {
  //   return await Get.dialog(
  //     AlertDialog(
  //       backgroundColor: Colors.white,
  //       surfaceTintColor: Colors.white,
  //       title: const Text('Choose option'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           ListTile(
  //             leading: const Icon(Icons.camera_alt),
  //             title: const Text('Take a photo'),
  //             onTap: () async {
  //               Get.back();
  //               pickImage(ImageSource.camera);
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.image_outlined),
  //             title: const Text('Take from Gallery'),
  //             onTap: () async {
  //               Get.back();
  //               pickImage(ImageSource.gallery);
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.insert_drive_file),
  //             title: const Text('Choose file'),
  //             onTap: () async {
  //               Get.back();
  //               pickPdf();
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> getComplaintType(String deptId) async {
    isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getCompType(
        userId,
        deptId,
        getIt<TranslateController>().lang.value == 'mr' ? 'mr' : 'en',
      );

      print('getComplaintType');
      print(res);
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
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getWardList(
        userId,
        getIt<TranslateController>().lang.value == 'mr' ? 'mr' : 'en',
      );
      print('getWardList');
      print(res);
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

      print('userId======>$userId');
      print('deptId======>$deptId');
      print(
        'selectedType.value.toString()======>${selectedType.value.toString()}',
      );
      print(
        'landMarkController.text======>${landMarkController.text.toString()}',
      );
      print('selectedWard.text======>${selectedWard.value.toString()}');
      print(
        'descriptionController.text======>${descriptionController.text.toString()}',
      );
      print('latLng.text======>${latLng.value.toString()}');
      final res = await _apiService.addCorpComplaint(
        userId,
        deptId,
        selectedType.value.toString(),
        landMarkController.text.trim(),
        selectedWard.value.toString(),
        descriptionController.text.trim(),
        latLng.value,
        '',
        '',
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
      showToastNormal('Something went wrong. Please try again later.');
    } finally {
      isAddLoading.value = false;
    }
  }

  resetForm() {
    attachmentList.clear();
    latLng.value = '';
    selectedWard.value = '';
    selectedType.value = '';
    landMarkController.clear();
    descriptionController.clear();
  }

  // Future<Map<String, String>> getDetails() async {
  //   String latLng = '';
  //   String userLocation = '';
  //   String dateTime = '';
  //
  //   final position = await _getCurrentPosition();
  //   if (position != null) {
  //     latLng = 'Lat: ${position.latitude}, Long: ${position.longitude}';
  //     final placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );
  //     if (placemarks.isNotEmpty) {
  //       final p = placemarks.first;
  //       userLocation =
  //       '${p.name}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}';
  //     }
  //     dateTime = DateFormat('dd MMM yyyy hh:mm a').format(DateTime.now());
  //   }
  //
  //   return {'latLng': latLng, 'userLocation': userLocation, 'dateTime': dateTime};
  // }
  //
  // Future<Position?> _getCurrentPosition() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied ||
  //         permission == LocationPermission.deniedForever) {
  //       Get.snackbar('Permission Denied', 'Location access is required.');
  //       return null;
  //     }
  //   }
  //   final LocationSettings locationSettings = LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //     distanceFilter: 100,
  //   );
  //   return await Geolocator.getCurrentPosition(
  //     locationSettings: locationSettings,
  //   );
  // }
}
