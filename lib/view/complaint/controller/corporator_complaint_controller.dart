// import 'package:intl/intl.dart';
// import 'package:indapur_team/utils/exported_path.dart';
//
// @lazySingleton
// class CorpComplaintController extends GetxController {
//   final ApiService _apiService = Get.find();
//   final complaintList = [].obs;
//   final complaintDetails = {}.obs;
//   final isLoading = false.obs;
//   final isDetailsLoading = false.obs;
//   final isSendLoading = false.obs;
//   final isDepartmentLoading = false.obs;
//   final isMainLoading = false.obs;
//   final isWardLoading = false.obs;
//
//   //update Complaint
//   final formKey = GlobalKey<FormState>();
//   final descriptionController = TextEditingController();
//   final selectedDepartment = RxnString();
//   final selectedStatus = RxnString();
//   final selectedFilterStatus = RxnString();
//
//   final selectedWard = RxnString();
//   final selectedHOD = RxnString();
//   final selectedFieldOfficer = RxnString();
//   final newAttachments = [].obs;
//   final departmentList = [].obs;
//
//   final wardList = [].obs;
//   final hodList = [].obs;
//   final fieldOfficerList = [].obs;
//   final statusList = [].obs;
//   final complaintType = [].obs;
//
//   final page = 1.obs;
//   final hasNextPage = true.obs;
//   final isMoreLoading = false.obs;
//
//   final showFieldOfficerError = false.obs;
//   final showHODError = false.obs;
//   final showWardError = false.obs;
//   final showDepartmentError = false.obs;
//
//   /// Fetches getComplaintInitial
//   Future<void> getCorpComplaintInitial({bool showLoading = true}) async {
//     if (showLoading) isLoading.value = true;
//     page.value = 1;
//     complaintList.clear();
//     final userId = await LocalStorage.getString('user_id') ?? '';
//
//     try {
//       final res = await _apiService.getCorpComp(
//         userId,
//         page.value.toString(),
//         [selectedDepartmentFilter.value],
//         selectedFilterStatus.value ?? '',
//         selectedType.value ?? '',
//         selectedSource.value ?? '',
//         getDateParam(),
//         getIt<TranslateController>().lang.value == 'mr' ? 'mr' : 'en',
//       );
//       if (res['common']['status'] == true) {
//         final data = res['data'];
//         if (data is Map) {
//           complaintList.value = data['complaints'] ?? [];
//           departments.value = data['department'] ?? [];
//         } else {
//           complaintList.value = data;
//         }
//       }
//     } catch (e) {
//       showToastNormal('Something went wrong. Please try again later.');
//     } finally {
//       if (showLoading) isLoading.value = false;
//     }
//   }
//
//   /// Fetches getComplaintLoadMore
//   Future<void> getCorpComplaintLoadMore() async {
//     isMoreLoading.value = true;
//     final userId = await LocalStorage.getString('user_id') ?? '';
//     try {
//       page.value += 1;
//       final res = await _apiService.getCorpComp(
//         userId,
//         page.value.toString(),
//         [selectedDepartmentFilter.value],
//         selectedFilterStatus.value ?? '',
//         selectedType.value ?? '',
//         selectedSource.value ?? '',
//         getDateParam(),
//         getIt<TranslateController>().lang.value == 'mr' ? 'mr' : 'en',
//       );
//       if (res['common']['status'] == true) {
//         final data = res['data'];
//         final List fetchedPosts;
//         if (data is Map) {
//           fetchedPosts = data['complaints'] ?? [];
//         } else {
//           fetchedPosts = data;
//         }
//
//         if (fetchedPosts.isNotEmpty) {
//           complaintList.addAll(fetchedPosts);
//         } else {
//           hasNextPage.value = false;
//         }
//       }
//
//       // if (res['common']['status'] == true) {
//       //   final List fetchedPosts = res['data'];
//       //   if (fetchedPosts.isNotEmpty) {
//       //     complaintList.addAll(fetchedPosts);
//       //   } else {
//       //     hasNextPage.value = false;
//       //   }
//       // }
//     } catch (e) {
//       showToastNormal('Something went wrong. Please try again later.');
//       // debugPrint("Login error: $e");
//     } finally {
//       isMoreLoading.value = false;
//     }
//   }
// }
