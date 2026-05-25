import 'package:indapur_team/utils/exported_path.dart';
import 'package:indapur_team/view/add_corp_complaint/controlller/add_corp_controller.dart';
import 'package:indapur_team/view/add_corp_complaint/view/add_corp_complaint.dart'
    show AddCorpComplaint;
import 'package:indapur_team/view/add_corp_complaint/widget/departments_tile.dart';
import 'package:ui_package/ui_package.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  final controller = getIt<AddCorpComplaintController>();
  @override
  void initState() {
    super.initState();
    controller.getDepartment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Departments', showBackButton: true),
      body: Obx(
        () => controller.isDeptLoading.isTrue
            ? AppLoader()
            : CustomScrollView(slivers: [departmentSection()]),
      ),
    );
  }

  Widget departmentSection() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      sliver: Obx(
        () => AnimationLimiter(
          child: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: controller.departmentList.length,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: DepartmentTile(
                      onTap: () {
                        Get.to(
                          () => AddCorpComplaint(
                            deptId: controller.departmentList[index]['id']
                                .toString(),
                            deptName: controller.departmentList[index]['name']
                                .toString(),
                          ),
                        );
                      },
                      isLink: false,
                      department: controller.departmentList[index]['id']
                          .toString(),
                      image: controller.departmentList[index]['image'],
                      dept: controller.departmentList[index]['name'],
                    ),
                  ),
                ),
              );
            }, childCount: controller.departmentList.length),
          ),
        ),
      ),
    );
  }
}
