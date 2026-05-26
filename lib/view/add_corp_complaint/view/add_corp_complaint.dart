import 'package:dotted_border/dotted_border.dart';
import 'package:indapur_team/utils/exported_path.dart';
import 'package:ui_package/ui_package.dart';

class AddCorpComplaint extends StatefulWidget {
  final String deptId;
  final String deptName;

  const AddCorpComplaint({
    super.key,
    required this.deptId,
    required this.deptName,
  });

  @override
  State<AddCorpComplaint> createState() => _AddCorpComplaintState();
}

class _AddCorpComplaintState extends State<AddCorpComplaint> {
  final controller = getIt<AddCorpComplaintController>();

  @override
  void initState() {
    super.initState();
    controller.loadInitialData(widget.deptId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        surfaceTintColor: Colors.grey.withValues(alpha: 0.1),
        titleSpacing: 0,
        title: Text(
          '${widget.deptName.tr} ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),

      body: Obx(
        () => controller.isPageLoading.value
            ? AppLoader()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: controller.formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppDropdownField(
                          fillColor: Colors.white,
                          // isEnabled: true,
                          isDynamic: true,
                          value: controller.selectedType.value,
                          title: 'Complaint Type',
                          items: controller.complaintTypeList,
                          hintText: 'Select Complaint Type',
                          validator: (value) => value == null
                              ? 'Please select Complaint Type'
                              : null,
                          onChanged: (value) async {
                            controller.selectedType.value = value;
                          },
                        ),
                        SizedBox(height: 12.h),
                        AppDropdownField(
                          fillColor: Colors.white,
                          // isEnabled: true,
                          isDynamic: true,
                          value: controller.selectedWard.value,
                          title: 'Ward',
                          items: controller.wardList,
                          hintText: 'Select ward',
                          validator: (value) =>
                              value == null ? 'Please select ward' : null,
                          onChanged: (value) async {
                            controller.selectedWard.value = value;
                          },
                        ),
                        SizedBox(height: 12.h),
                        _buildLabel('Landmark'.tr),
                        buildTextField(
                          keyboardType: TextInputType.text,
                          controller: controller.landMarkController,
                          validator: (value) => value!.isEmpty
                              ? 'Please Enter landmark'.tr
                              : null,
                          hintText: 'Enter landmark'.tr,
                        ),
                        SizedBox(height: 12.h),
                        _buildLabel('Description'.tr),
                        buildTextField(
                          keyboardType: TextInputType.text,
                          controller: controller.descriptionController,
                          maxLines: 3,
                          validator: (value) => value!.isEmpty
                              ? 'Please Enter description'.tr
                              : null,
                          hintText: 'Enter description'.tr,
                        ),
                        SizedBox(height: 12.h),
                        _buildLabel('Attachment'.tr),
                        DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            dashPattern: [10, 5],
                            radius: const Radius.circular(10),
                            color: primaryGrey,
                            strokeWidth: 1,
                            padding: const EdgeInsets.all(16),
                          ),

                          child: GestureDetector(
                            onTap: () {
                              CustomFilePicker.showPickerBottomSheet(
                                onFilePicked: (file) {
                                  controller.attachmentList.add(file);
                                },
                              );
                            },
                            child: Container(
                              width: Get.width,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                // color: primaryGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(16),
                              child: Obx(
                                () => controller.isLoading.isTrue
                                    ? LoadingWidget(color: primaryColor)
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedFileUpload,
                                          ),
                                          Text(
                                            'Attach Documents'.tr,
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildSelectedFilesWrap(),

                        // Obx(
                        //   () => controller.attachmentList.isNotEmpty
                        //       ? SizedBox(
                        //           width: Get.width * 0.8,
                        //           height: controller.attachmentList.length > 3
                        //               ? Get.width * 0.5
                        //               : Get.width * 0.3,
                        //           child: GridView.builder(
                        //             itemCount: controller.attachmentList.length,
                        //             gridDelegate:
                        //                 const SliverGridDelegateWithFixedCrossAxisCount(
                        //                   mainAxisSpacing: 5,
                        //                   crossAxisSpacing: 5,
                        //                   crossAxisCount: 3,
                        //                 ),
                        //             itemBuilder: (context, index) {
                        //               final data = controller.attachmentList[index];
                        //               final isImage = data['from'] == 'camera';
                        //               return Stack(
                        //                 alignment: Alignment.center,
                        //                 children: [
                        //                   ClipRRect(
                        //                     borderRadius: BorderRadius.circular(10.0),
                        //                     child: isImage
                        //                         ? GestureDetector(
                        //                             onTap: () {
                        //                               Get.dialog(
                        //                                 Dialog(
                        //                                   surfaceTintColor:
                        //                                       Colors.white,
                        //                                   backgroundColor: Colors.white,
                        //                                   shape: RoundedRectangleBorder(
                        //                                     borderRadius:
                        //                                         BorderRadius.circular(
                        //                                           12,
                        //                                         ),
                        //                                   ),
                        //                                   child: Column(
                        //                                     mainAxisSize:
                        //                                         MainAxisSize.min,
                        //                                     children: [
                        //                                       ClipRRect(
                        //                                         borderRadius:
                        //                                             const BorderRadius.only(
                        //                                               topLeft:
                        //                                                   Radius.circular(
                        //                                                     12,
                        //                                                   ),
                        //                                               topRight:
                        //                                                   Radius.circular(
                        //                                                     12,
                        //                                                   ),
                        //                                             ),
                        //                                         child: Image.file(
                        //                                           data['path'],
                        //                                           fit: BoxFit.cover,
                        //                                           width:
                        //                                               Get.width * 0.6,
                        //                                         ),
                        //                                       ),
                        //                                       Padding(
                        //                                         padding:
                        //                                             const EdgeInsets.all(
                        //                                               12,
                        //                                             ),
                        //                                         child: Column(
                        //                                           crossAxisAlignment:
                        //                                               CrossAxisAlignment
                        //                                                   .start,
                        //                                           children: [
                        //                                             if (data['userLocation'] !=
                        //                                                 null)
                        //                                               Text(
                        //                                                 '📍 ${data['userLocation']}',
                        //                                                 style: const TextStyle(
                        //                                                   fontSize: 14,
                        //                                                   fontWeight:
                        //                                                       FontWeight
                        //                                                           .w500,
                        //                                                 ),
                        //                                               ),
                        //                                             if (data['latLng'] !=
                        //                                                 null)
                        //                                               Text(
                        //                                                 '🌐 ${data['latLng']}',
                        //                                                 style: const TextStyle(
                        //                                                   fontSize: 14,
                        //                                                   fontWeight:
                        //                                                       FontWeight
                        //                                                           .w500,
                        //                                                 ),
                        //                                               ),
                        //                                             if (data['dateTime'] !=
                        //                                                 null)
                        //                                               Text(
                        //                                                 '🕒 ${data['dateTime']}',
                        //                                                 style: const TextStyle(
                        //                                                   fontSize: 14,
                        //                                                   fontWeight:
                        //                                                       FontWeight
                        //                                                           .w500,
                        //                                                 ),
                        //                                               ),
                        //                                           ],
                        //                                         ),
                        //                                       ),
                        //                                       TextButton(
                        //                                         onPressed: () =>
                        //                                             Get.back(),
                        //                                         child: const Text(
                        //                                           "Close",
                        //                                         ),
                        //                                       ),
                        //                                     ],
                        //                                   ),
                        //                                 ),
                        //                               );
                        //                             },
                        //                             child: Image.file(
                        //                               data['path'],
                        //                               fit: BoxFit.cover,
                        //                               width:
                        //                                   (Get.width * 0.8 - 10) /
                        //                                   3, // 3 columns in 80% width
                        //                               height:
                        //                                   (Get.width * 0.8 - 10) / 3,
                        //                             ),
                        //                           )
                        //                         : Image.asset(
                        //                             'assets/images/pdf_icon.png',
                        //                             height: Get.height * 0.07,
                        //                           ),
                        //                   ),
                        //                   Positioned(
                        //                     top: 7,
                        //                     right: 7,
                        //                     child: GestureDetector(
                        //                       onTap: () {
                        //                         controller.attachmentList.removeAt(
                        //                           index,
                        //                         );
                        //                         if (controller.attachmentList.isEmpty) {
                        //                           controller.attachmentList.clear();
                        //                         }
                        //                       },
                        //                       child: Icon(
                        //                         Icons.delete,
                        //                         size: 20,
                        //                         color: Colors.red.shade300,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               );
                        //             },
                        //           ),
                        //         )
                        //       : const SizedBox(),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: buildAddButton(),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
      child: buildLabel(text),
    );
  }

  Widget _buildSelectedFilesWrap() {
    return Obx(
      () => Wrap(
        spacing: 16,
        runSpacing: 8,
        children: controller.attachmentList.map((file) {
          final isImage =
              file.path.endsWith('.jpg') || file.path.endsWith('.png');

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: Get.width * 0.25.w,
                height: Get.width * 0.25.w,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isImage
                    ? Image.file(file, fit: BoxFit.cover)
                    : Center(
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedDocumentAttachment,
                          size: 40.sp,
                          color: Colors.grey,
                        ),
                      ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: InkWell(
                  onTap: () {
                    controller.attachmentList.remove(file);
                  },
                  child: CircleAvatar(
                    radius: 10.r,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, size: 12.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget buildAddButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ).copyWith(bottom: 8),
        child: CustomButton(
          isLoading: controller.isAddLoading,
          onPressed: () async {
            if (controller.formKey.currentState!.validate()) {
              await controller.addComplaint(widget.deptId);
            }
          },
          backgroundColor: primaryColor,
          text: 'Add Complaint',
          width: 0.8.sw,
          height: 48.h,
        ),
      ),
    );
  }
}
