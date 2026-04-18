import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:indapur_team/utils/exported_path.dart';

class ComplaintDetails extends StatefulWidget {
  const ComplaintDetails({super.key});

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  final controller = getIt<ComplaintController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      final complaintId = Get.arguments['id'].toString();
      controller.getComplaintDetails(complaintId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: CustomAppBar(
        title: 'Complaint Details',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 22.w),
            onPressed: () {
              final complaintId = Get.arguments['id'].toString();
              controller.getComplaintDetails(complaintId);
            },
          ),
        ],
      ),
      body: Obx(() {
        final complaints = controller.complaintDetails;

        if (controller.isDetailsLoading.isTrue) {
          return LoadingWidget(color: primaryColor);
        }

        if (complaints.isEmpty) {
          return Center(
            child: TranslatedText(
              title: "No details available",
              fontSize: 14.sp,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            final complaintId = Get.arguments['id'].toString();
            await controller.getComplaintDetails(complaintId);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeaderSection(),
                    SizedBox(height: 16.h),
                    _buildDescriptionCard(),

                    SizedBox(height: 16.h),
                    _buildDetailsCard(),
                    SizedBox(height: 16.h),
                    if ((controller.complaintDetails['attachments'] as List)
                        .isNotEmpty)
                      _buildAttachmentsSection(),
                    SizedBox(height: 16.h),
                    if ((controller.complaintDetails['comments'] as List)
                        .isNotEmpty)
                      _buildUpdatesSection(),
                    SizedBox(height: 80.h),
                  ]),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(
        () => controller.complaintDetails.isNotEmpty
            ? _buildUpdateFAB()
            : SizedBox(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeaderSection() {
    return Hero(
      tag: 'complaint-${controller.complaintDetails['id']}',
      child: Material(
        type: MaterialType.transparency,
        child: GlassCard(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TranslatedText(
                    title:
                        controller.complaintDetails['department']?.toString() ??
                        '-',
                    textAlign: TextAlign.start,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    maxLines: 2,
                  ),
                ),
                StatusBadge(
                  status: controller.complaintDetails['status'].toString(),
                  color:
                      int.tryParse(
                        controller.complaintDetails['status_color']
                                ?.toString() ??
                            '',
                      ) ??
                      0xFF898989,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedIdVerified,
                  size: 18.w,
                  color: Colors.grey,
                ),
                SizedBox(width: 8.w),
                TranslatedText(
                  title:
                      "Track ID: ${controller.complaintDetails['code']?.toString() ?? 'N/A'}",
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendar03,
                  size: 18.w,
                  color: Colors.grey,
                ),
                SizedBox(width: 8.w),
                TranslatedText(
                  title:
                      "Created: ${formatDate2(controller.complaintDetails['created_on_date']).toString()}",
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    if (controller.complaintDetails['description'].toString().isEmpty) {
      return SizedBox();
    }
    return GlassCard(
      children: [
        Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedDocumentValidation,
              size: 20.w,
              color: primaryColor,
            ),
            SizedBox(width: 8.w),
            TranslatedText(
              title: "Description",
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        CustomText(
          title: controller.complaintDetails['description']?.toString() ?? '-',
          fontSize: 14.sp,
          textAlign: TextAlign.start,
          maxLines: 5,
        ),
        _buildDescription(),
      ],
    );
  }

  Widget _buildDescription() {
    final description = controller.complaintDetails['description'] ?? '';
    if (description.length < 150) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        showMoreData(description);
      },
      child: const Padding(
        padding: EdgeInsets.all(3.0),
        child: Text(
          'Read More',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return GlassCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                  size: 20.w,
                  color: primaryColor,
                ),
                SizedBox(width: 8.w),
                TranslatedText(
                  title: "Complaint Details",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            _buildLatLong(),
            // GestureDetector(
            //   onTap: () {
            //     launchURL('tel:${controller.complaintDetails['phone']}');
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(8.w),
            //     decoration: BoxDecoration(
            //       color: Colors.grey.withValues(alpha: 0.15),
            //       shape: BoxShape.circle,
            //     ),
            //     child: HugeIcon(
            //       icon: HugeIconsStrokeRounded.call,
            //       color: primaryColor,
            //       size: 16,
            //     ),
            //   ),
            // ),
          ],
        ),
        _buildComplainantField(),
        _buildDetailItem(
          icon: HugeIcons.strokeRoundedNewOffice,
          label: "Department",
          value: controller.complaintDetails['department']?.toString() ?? 'N/A',
        ),
        _buildDetailItem(
          icon: HugeIcons.strokeRoundedLocation10,
          label: "Ward",
          value: controller.complaintDetails['ward']?.toString() ?? '-',
        ),
        _buildDetailItem(
          icon: HugeIcons.strokeRoundedLocation10,
          label: "Complaint Type",
          value:
              controller.complaintDetails['complaint_type']?.toString() ??
              'N/A',
        ),

        _buildHodField(),
        _buildFieldOfficer(),
        _buildDetailItem(
          icon: HugeIcons.strokeRoundedShieldUser,
          label: "Source",
          value: controller.complaintDetails['source']?.toString() ?? 'N/A',
        ),
      ],
    );
  }

  Widget _buildLatLong() {
    final latLng = controller.complaintDetails['lat_long'].toString();
    if (latLng.isEmpty || latLng == 'null') return SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        openMap(controller.complaintDetails['lat_long']);
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: HugeIcon(
          icon: HugeIconsStrokeRounded.location01,
          color: primaryColor,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildComplainantField() {
    final number = controller.complaintDetails['phone'].toString();
    return _buildDetailItem(
      icon: HugeIcons.strokeRoundedUser02,
      label: "Complainant",
      value: controller.complaintDetails['name']?.toString() ?? '',
      showEdit: number.isNotEmpty,
      onEdit: () {
        launchURL('tel:${controller.complaintDetails['phone']}');
      },
    );
  }

  Widget _buildHodField() {
    final roleId = getIt<UserService>().rollId.value;
    final number =
        controller.complaintDetails['hod_contact_number']?.toString() ?? '';
    return _buildDetailItem(
      icon: HugeIcons.strokeRoundedUserAdd02,
      label: "HOD",
      value: controller.complaintDetails['hod_name']?.toString() ?? '',
      showEdit: roleId == '9' || roleId == '3' || roleId == '1' || roleId == '5'
          ? number.isNotEmpty
          : false,
      onEdit: () {
        launchURL('tel:${controller.complaintDetails['hod_contact_number']}');
      },
    );
  }

  Widget _buildFieldOfficer() {
    final roleId = getIt<UserService>().rollId.value;

    final number =
        controller.complaintDetails['field_contact_number']?.toString() ?? '';
    return _buildDetailItem(
      icon: HugeIcons.strokeRoundedShieldUser,
      label: "Field Officer",
      value: controller.complaintDetails['field_name']?.toString() ?? 'N/A',
      showEdit: roleId == '9' || roleId == '3' || roleId == '1' || roleId == '4'
          ? number.isNotEmpty
          : false,
      onEdit: () {
        launchURL('tel:${controller.complaintDetails['field_contact_number']}');
      },
    );
  }

  Widget _buildDetailItem({
    required dynamic icon,
    required String label,
    required String value,
    bool showEdit = false,
    VoidCallback? onEdit,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(icon: icon, size: 20.w, color: Colors.grey),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  title: label == 'HOD' ? 'एचओडी' : label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2.h),
                CustomText(
                  title: capitalize(value),
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          if (showEdit)
            GestureDetector(
              onTap: onEdit ?? () {},
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: HugeIconsStrokeRounded.call,
                  color: primaryColor,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return AttachmentList(
      attachments: (controller.complaintDetails['attachments'] as List),
    );
  }

  Widget _buildUpdatesSection() {
    return UpdateHistoryList(
      updateRecords: controller.complaintDetails['comments'],
      title: 'Updates',
    );
  }

  Widget _buildUpdateFAB() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: FloatingActionButton.extended(
          onPressed: () => Get.toNamed(
            Routes.updateComplaint,
            arguments: {'id': Get.arguments['id'].toString()},
          ),
          backgroundColor: primaryColor,
          elevation: 4,
          icon: Icon(Icons.edit, color: Colors.white),
          label: CustomText(
            title: 'Update Complaint',
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
