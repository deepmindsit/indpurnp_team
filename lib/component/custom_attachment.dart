import 'package:indapur_team/utils/exported_path.dart';

class AttachmentList extends StatelessWidget {
  final List attachments;

  const AttachmentList({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      children: [
        sectionTitleWithIcon('📎 Attachments'),
        AttachmentPreviewList(
          attachments: attachments,
          onDownload: (path) => downloadFile(path),
        ),

        // SizedBox(
        //   width: double.infinity,
        //   child: Wrap(
        //     spacing: 8,
        //     runSpacing: 8,
        //     children:
        //         attachments.map((file) {
        //           String fileType = file['type'] ?? '';
        //           String filePath = file['path'] ?? '';
        //           String fileName = file['name'] ?? '';
        //
        //           Widget fileWidget;
        //
        //           if (fileType.startsWith('image/')) {
        //             // Show image
        //             fileWidget = FadeInImage(
        //               placeholder: AssetImage(Images.fevicon),
        //               image: NetworkImage(filePath),
        //               imageErrorBuilder: (context, error, stackTrace) {
        //                 return Image.asset(
        //                   Images.fevicon,
        //                   width: Get.width * 0.25.w,
        //                   height: Get.width * 0.25.w,
        //                   fit: BoxFit.cover,
        //                 );
        //               },
        //               width: Get.width * 0.25.w,
        //               height: Get.width * 0.25.w,
        //               fit: BoxFit.cover,
        //               fadeInDuration: const Duration(milliseconds: 300),
        //             );
        //           } else if (fileType.startsWith('video/')) {
        //             // Show video icon preview
        //             fileWidget = Row(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 Icon(Icons.videocam, color: Colors.red, size: 20.sp),
        //                 const SizedBox(width: 6),
        //                 SizedBox(
        //                   width: Get.width * 0.25.w,
        //                   child: CustomText(
        //                     title: fileName,
        //                     fontSize: 12.sp,
        //                     maxLines: 1,
        //                   ),
        //                 ),
        //               ],
        //             );
        //           } else if (fileType == 'application/pdf') {
        //             // Show PDF icon preview
        //             fileWidget = Row(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 Icon(
        //                   Icons.picture_as_pdf,
        //                   color: Colors.deepOrange,
        //                   size: 20.sp,
        //                 ),
        //                 const SizedBox(width: 6),
        //                 SizedBox(
        //                   width: Get.width * 0.25.w,
        //                   child: CustomText(
        //                     title: fileName,
        //                     fontSize: 12.sp,
        //                     maxLines: 1,
        //                   ),
        //                 ),
        //               ],
        //             );
        //           } else {
        //             // Fallback for other file types
        //             fileWidget = Row(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 Icon(
        //                   Icons.insert_drive_file,
        //                   color: Colors.grey,
        //                   size: 20.sp,
        //                 ),
        //                 const SizedBox(width: 6),
        //                 SizedBox(
        //                   width: Get.width * 0.25.w,
        //                   child: CustomText(
        //                     title: fileName,
        //                     fontSize: 12.sp,
        //                     maxLines: 1,
        //                   ),
        //                 ),
        //               ],
        //             );
        //           }
        //
        //           return Container(
        //             padding: const EdgeInsets.symmetric(
        //               horizontal: 12,
        //               vertical: 8,
        //             ),
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(8),
        //               color: Colors.grey.shade50,
        //               border: Border.all(color: Colors.grey.shade300),
        //             ),
        //             child: InkWell(
        //               onTap: () => downloadFile(filePath),
        //               child: fileWidget,
        //             ),
        //           );
        //         }).toList(),
        //
        //     // attachments.map((fileName) {
        //     //   return InkWell(
        //     //     onTap: () {},
        //     //     child: Container(
        //     //       padding: const EdgeInsets.symmetric(
        //     //         horizontal: 12,
        //     //         vertical: 8,
        //     //       ),
        //     //       decoration: BoxDecoration(
        //     //         borderRadius: BorderRadius.circular(8),
        //     //         color: Colors.grey.shade50,
        //     //         border: Border.all(color: Colors.grey.shade300),
        //     //       ),
        //     //       child: FadeInImage(
        //     //         placeholder: AssetImage(Images.fevicon),
        //     //         image: NetworkImage(fileName['path']),
        //     //         imageErrorBuilder: (context, error, stackTrace) {
        //     //           return Image.asset(
        //     //             Images.fevicon,
        //     //             width: 36.w,
        //     //             height: 36.h,
        //     //             fit: BoxFit.cover,
        //     //           );
        //     //         },
        //     //         width: 36.w,
        //     //         height: 36.h,
        //     //         fit: BoxFit.cover,
        //     //         fadeInDuration: const Duration(milliseconds: 300),
        //     //       ),
        //     //
        //     //       // Row(
        //     //       //   mainAxisSize: MainAxisSize.min,
        //     //       //   children: [
        //     //       //     Icon(
        //     //       //       getIconForFile(fileName['name']),
        //     //       //       color: Colors.blue,
        //     //       //       size: 18.sp,
        //     //       //     ),
        //     //       //     const SizedBox(width: 6),
        //     //       //     CustomText(title: fileName['name'], fontSize: 14.sp),
        //     //       //   ],
        //     //       // ),
        //     //     ),
        //     //   );
        //     // }).toList(),
        //   ),
        // ),
      ],
    );
  }
}
