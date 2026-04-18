import '../../../utils/exported_path.dart';

@lazySingleton
class NavigationController extends GetxController {
  final currentIndex = 0.obs;
  final fromDashboard = false.obs;
  static final List<Widget> widgetOptions = <Widget>[
    DashboardPage(),
    ComplaintScreen(),
  ];

  void updateIndex(int index, {bool isFromDashboard = false}) {
    fromDashboard.value = isFromDashboard;
    currentIndex.value = index;
  }
}
