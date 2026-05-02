import 'package:indapur_team/utils/exported_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final controller = getIt<SplashController>();

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  // Future<void> _initialize() async {
  //   // Wait for the first frame to complete before navigating
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await Future.delayed(const Duration(seconds: 1));
  //     controller.expanded.value = true;
  //     await Future.delayed(transitionDuration);
  //     final token = await LocalStorage.getString('auth_key');
  //     final connectivityResult = await (Connectivity().checkConnectivity());
  //
  //     if (!connectivityResult.contains(ConnectivityResult.none)) {
  //       token != null
  //           ? Get.offAllNamed(Routes.mainScreen)
  //           : Get.offAllNamed(Routes.login);
  //     } else {
  //       showNoInternetDialog();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            /// Full Screen Background Image
            Positioned.fill(
              child: Image.asset(
                Images.splashScreen,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );


    //   Obx(
    //   () => Material(
    //     surfaceTintColor: Colors.white,
    //     color: Colors.white,
    //     child: Container(
    //       color: Colors.white,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           AnimatedCrossFade(
    //             firstCurve: Curves.fastOutSlowIn,
    //             crossFadeState: !controller.expanded.value
    //                 ? CrossFadeState.showFirst
    //                 : CrossFadeState.showSecond,
    //             duration: controller.transitionDuration,
    //             firstChild: Container(),
    //             secondChild: _logoRemainder(),
    //             alignment: Alignment.centerLeft,
    //             sizeCurve: Curves.easeInOut,
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  // Widget _logoRemainder() {
  //   return Image.asset(Images.fevicon, width: Get.width * 0.8.h);
  // }
}
