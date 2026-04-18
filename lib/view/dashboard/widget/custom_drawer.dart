import '../../../utils/exported_path.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 0.7.sw,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildHeader(),
                  _buildDepartment(),
                  _buildDrawerItem(
                    icon: HugeIcons.strokeRoundedAnalyticsUp,
                    title: 'Dashboard',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    icon: HugeIcons.strokeRoundedEditUser02,
                    title: 'Profile',
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.editProfile);
                    },
                  ),
                  _buildDrawerItem(
                    icon: HugeIcons.strokeRoundedHelpCircle,
                    title: 'Help And Support',
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.helpSupport);
                    },
                  ),
                  _buildDrawerItem(
                    icon: HugeIcons.strokeRoundedLogout01,
                    title: 'Logout',
                    iconColor: Colors.black87,
                    onTap: () async {
                      Get.back();
                      logoutDialog();
                    },
                  ),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartment() {
    final roleId = getIt<UserService>().rollId.value;
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.business_center,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TranslatedText(
                    title:  roleId == '9'
                        ? controller.userData['ward']?.toString() ?? '-'
                        : controller.userData['department']?.toString() ?? '-',
                    fontSize: 15.sp,
                    color: primaryColor,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => DrawerHeader(
        decoration: BoxDecoration(color: primaryColor),
        child: controller.isProfileLoading.isTrue
            ? LoadingWidget(color: Colors.white)
            : SizedBox(
                width: Get.width,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35.r,
                      backgroundColor: Colors.grey.shade300,
                      child: ClipOval(
                        child: FadeInImage(
                          placeholder: AssetImage(Images.fevicon),
                          image: NetworkImage(
                            controller.userData['profile_image'] ?? '',
                          ),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              Images.fevicon,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            );
                          },
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      title: controller.userData['name'] ?? '',
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      title: controller.userData['role'] ?? '',
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required dynamic icon,
    required String title,
    Color iconColor = Colors.black,
    Color textColor = Colors.black87,
    required VoidCallback onTap,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      leading: HugeIcon(icon: icon, color: iconColor, size: 22.sp),
      title: TranslatedText(
        title: title,
        fontSize: 14.sp,
        color: textColor,
        textAlign: TextAlign.start,
        fontWeight: FontWeight.w500,
      ),
      onTap: onTap,
      hoverColor: Colors.grey.shade200,
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Column(
        children: [
          const Text('Crafted with care', style: TextStyle(color: Colors.grey)),
          InkWell(
            onTap: () =>
                launchInBrowser(Uri.parse('https://deepmindsinfotech.com')),
            child: const Text(
              'Deepminds Infotech Pvt. Ltd.',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
