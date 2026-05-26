import 'package:indapur_team/utils/exported_path.dart';
import '../../../utils/color.dart' as c;

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final controller = getIt<ComplaintController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      final navController = getIt<NavigationController>();
      if (!navController.fromDashboard.value) {
        controller.resetFilters(false);
      }
      controller.getComplaintInitial();
      controller.getCorporatorComplaintInitial();
      controller.getDepartmentFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Complaints',
        showBackButton: false,
        titleSpacing: null,
        actions: [
          if (getIt<UserService>().rollId.value == '9')
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.departmentScreen);
              },
              icon: HugeIcon(icon: HugeIcons.strokeRoundedAdd01),
            ),
          IconButton(
            onPressed: () {
              Get.bottomSheet(isScrollControlled: true, ComplaintFilter());
            },
            icon: HugeIcon(icon: HugeIcons.strokeRoundedFilter),
          ),
        ],
      ),
      body: Obx(
        () => getIt<UserService>().rollId.value != '9'
            ? AllComplaint()
            : DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        onTap: (index) {
                          controller.selectedTab.value = index;

                          if (index == 0) {
                            controller.resetFilters(false);
                            controller.getComplaintInitial();
                          } else {
                            controller.resetFilters(false);
                            controller.getCorporatorComplaintInitial();
                          }
                        },
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: c.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black87,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
                          Tab(text: "All Complaints"),
                          Tab(text: "My Complaints"),
                        ],
                      ),
                    ),

                    Expanded(
                      child: TabBarView(
                        children: [
                          AllComplaint(),
                          CorporatorComplaint(),
                          // _buildMyComplaint(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Widget _buildAllComplaint() {
  //   return Obx(() {
  //     final complaints = controller.complaintList;
  //
  //     if (controller.isLoading.isTrue) {
  //       return _buildShimmer();
  //     }
  //
  //     if (complaints.isEmpty) {
  //       return _buildEmptyState();
  //     }
  //     return NotificationListener<ScrollNotification>(
  //       onNotification: (scrollNotification) {
  //         if (scrollNotification is ScrollEndNotification &&
  //             scrollNotification.metrics.pixels ==
  //                 scrollNotification.metrics.maxScrollExtent) {
  //           controller.getComplaintLoadMore();
  //         }
  //         return true;
  //       },
  //       child: SingleChildScrollView(
  //         child: Column(
  //           spacing: 10,
  //           children: [
  //             LiveList.options(
  //               shrinkWrap: true,
  //               physics: BouncingScrollPhysics(),
  //               options: LiveOptions(
  //                 delay: Duration.zero,
  //                 showItemInterval: Duration(milliseconds: 100),
  //                 showItemDuration: Duration(milliseconds: 250),
  //                 reAnimateOnVisibility: false,
  //               ),
  //               itemCount: complaints.length,
  //               itemBuilder: (context, index, animation) {
  //                 final ticket = complaints[index];
  //                 return FadeTransition(
  //                   opacity: animation,
  //                   child: SlideTransition(
  //                     position: Tween<Offset>(
  //                       begin: Offset(0, 0.1),
  //                       end: Offset.zero,
  //                     ).animate(animation),
  //                     child: GestureDetector(
  //                       onTap: () => Get.toNamed(
  //                         Routes.complaintDetails,
  //                         arguments: {'id': ticket['id'].toString()},
  //                       ),
  //                       child: ComplaintCard(
  //                         title: ticket['department'] ?? 'N/A',
  //                         location:
  //                             ticket['complaint_type'].toString().isNotEmpty
  //                             ? ticket['complaint_type']?.toString() ?? 'N/A'
  //                             : 'N/A',
  //                         date: ticket['created_at'] ?? 'N/A',
  //                         status: ticket['status'] ?? 'N/A',
  //                         statusColor: ticket['status_color'] ?? Colors.grey,
  //                         ticketNo: ticket['code'] ?? '',
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //             complaints.isEmpty ? const SizedBox() : buildLoader(),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }
  //
  // Widget buildLoader() {
  //   if (controller.isMoreLoading.value) {
  //     return Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: LoadingWidget(color: c.primaryColor),
  //     );
  //   } else if (!controller.hasNextPage.value) {
  //     return const Padding(
  //       padding: EdgeInsets.all(8.0),
  //       child: Center(child: Text('No more data')),
  //     );
  //   }
  //   return const SizedBox.shrink();
  // }
  //
  // Widget _buildEmptyState() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Image.asset(
  //           'assets/images/no_complaint_found.png',
  //           width: Get.width * 0.6,
  //         ),
  //         SizedBox(height: 16.sp),
  //         const Text(
  //           'No Complaints!',
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black,
  //           ),
  //         ),
  //         SizedBox(height: 8.sp),
  //         const Text(
  //           'You don\'t have any Complaints yet.',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.grey,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildShimmer() {
  //   return ListView.builder(
  //     itemCount: 6,
  //     shrinkWrap: true,
  //     physics: BouncingScrollPhysics(),
  //     itemBuilder: (context, index) {
  //       return Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
  //         child: Shimmer.fromColors(
  //           baseColor: Colors.grey.shade300,
  //           highlightColor: Colors.grey.shade100,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(16.r),
  //             ),
  //             padding: EdgeInsets.all(12.w),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 /// Title and status shimmer
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Container(width: 180.w, height: 16.h, color: Colors.grey),
  //                     Container(width: 60.w, height: 20.h, color: Colors.grey),
  //                   ],
  //                 ),
  //                 SizedBox(height: 6.h),
  //
  //                 /// Location and Date shimmer
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Container(width: 100.w, height: 12.h, color: Colors.grey),
  //                     Container(width: 80.w, height: 12.h, color: Colors.grey),
  //                   ],
  //                 ),
  //
  //                 SizedBox(height: 12.h),
  //                 Divider(height: 16.h, thickness: 0.5.h),
  //
  //                 /// Ticket No and icon row
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Container(width: 120.w, height: 12.h, color: Colors.grey),
  //                     Container(width: 20.w, height: 20.h, color: Colors.grey),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
