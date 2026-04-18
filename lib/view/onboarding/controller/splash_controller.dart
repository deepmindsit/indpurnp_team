import '../../../utils/exported_path.dart';

@lazySingleton
class SplashController extends GetxController {
  final token = ''.obs;
  final expanded = false.obs;
  final isOnboarded = false.obs;
  final transitionDuration = const Duration(seconds: 1);

  Future<void> initialize() async {
    await _loadPreferences();
    await Future.delayed(transitionDuration);
    expanded.value = true;
    await Future.delayed(transitionDuration);

    final connectivityResult = await (Connectivity().checkConnectivity());

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      token.value.isNotEmpty
          ? Get.offAllNamed(Routes.mainScreen)
          : Get.offAllNamed(Routes.login);
    } else {
      showNoInternetDialog();
    }
  }

  Future<void> _loadPreferences() async {
    token.value = await LocalStorage.getString('auth_key') ?? '';
  }
}
