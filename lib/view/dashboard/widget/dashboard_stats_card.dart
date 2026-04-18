import 'package:indapur_team/utils/exported_path.dart';
/*

class DashboardCard extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(40),
                spreadRadius: 2.r,
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: HugeIcon(icon: icon, color: primaryColor, size: 20.sp),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TranslatedText(
                    title: title == 'Completed Complaints'
                        ? getIt<TranslateController>().lang.value == 'mr'
                              ? 'पूर्ण झालेल्या तक्रारी'
                              : 'Completed Complaints'
                        : title,
                    fontSize: 14.sp,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            CustomText(
              title: value,
              fontSize: 24.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            // SizedBox(height: 8.h),
            // Row(
            //   children: [
            //     Icon(Icons.arrow_upward, color: Colors.green, size: 16.sp),
            //     SizedBox(width: 4.w),
            //     CustomText(
            //       title: percentage,
            //       fontSize: 12.sp,
            //       color: Colors.green,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ],
            // ),
            // const Spacer(),
            // CustomText(
            //   title: "Update: $updateDate",
            //   fontSize: 12.sp,
            //   color: Colors.grey,
            // ),
          ],
        ),
      ),
    );
  }
}
*/

class DashboardCard extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(40),
              spreadRadius: 2.r,
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: HugeIcon(
                      icon: icon,
                      color: primaryColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TranslatedText(
                      title: title != "Completed Complaints"
                          ? title
                          : getIt<TranslateController>().lang.value == 'en'
                          ? title
                          : 'पूर्ण झालेल्या तक्रारी',
                      fontSize: 14.sp,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              CustomText(
                title: value,
                fontSize: 24.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
