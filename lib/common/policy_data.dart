import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../utils/exported_path.dart';

class PolicyData extends StatefulWidget {
  final String slug;

  const PolicyData({super.key, required this.slug});

  @override
  State<PolicyData> createState() => _PolicyDataState();
}

class _PolicyDataState extends State<PolicyData> {
  final controller = Get.put(ProfileController());

  @override
  void initState() {
    controller.getLegalPage(widget.slug);
    super.initState();
  }

  // setController(String link) {
  //   print('link=============>$link');
  //   _controller =
  //       WebViewController()
  //         ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //         ..setNavigationDelegate(
  //           NavigationDelegate(
  //             onProgress: (int progress) {
  //               final p = progress / 100;
  //               Center(
  //                 child: CircularProgressIndicator(
  //                   value: double.parse(p.toString()),
  //                   strokeWidth: 2.0,
  //                 ),
  //               );
  //             },
  //             onPageStarted: (String url) {},
  //             onPageFinished: (String url) {},
  //             onNavigationRequest: (NavigationRequest request) {
  //               return NavigationDecision.navigate;
  //             },
  //           ),
  //         )
  //         ..loadRequest(Uri.parse(link));
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isPolicyLoading.isTrue
              ? Container(
                color: Colors.white,
                child: LoadingWidget(color: primaryColor),
              )
              : Scaffold(
                backgroundColor: Colors.white,
                appBar: CustomAppBar(
                  title: controller.privacyData['page_name'] ?? '',
                  showBackButton: true,
                  titleSpacing: 0,
                ),
                body: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri('${controller.privacyData['url']}?key=demo'),
                  ),
                  initialSettings: InAppWebViewSettings(
                    pageZoom: 8,
                    supportZoom: true,
                    minimumFontSize: 8,
                    javaScriptEnabled: true,
                  ),
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(
                      resources: request.resources,
                      action: PermissionResponseAction.GRANT,
                    );
                  },
                ),

                // WebViewWidget(controller: _controller),
              ),
    );
  }
}
