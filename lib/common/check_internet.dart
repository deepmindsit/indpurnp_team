import 'package:indapur_team/utils/exported_path.dart';

Future<void> checkInternetAndShowPopup() async {
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult.contains(ConnectivityResult.none)) {
    showNoInternetDialog();
  }
}

void showNoInternetDialog() {
  Get.dialog(
    PopScope(
      canPop: false,
      child: AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text(
          'No Internet Connection',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          height: Get.height * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Images.noInternet, width: Get.height * 0.3),
              const Text('Check your Internet Connection'),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.offAllNamed(Routes.splash);
            },
            child: Container(
              width: Get.width * 0.15,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.red,
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Retry',
                    style: TextStyle(letterSpacing: 1, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
