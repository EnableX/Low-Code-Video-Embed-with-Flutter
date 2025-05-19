import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:low_code_sample/web_page.dart';
import 'package:permission_handler/permission_handler.dart';

var _lowCodeUrl = ""; // Replace by your own


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enablex Meeting',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: kIsWeb ? const WebViewXPage() : const InAppWebViewPage(),
    );
  }
}

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage({super.key});

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _lowCodeUrl += '?skipMediaPermissionPrompt';


  }
  Size get screenSize => MediaQuery.of(context).size;
  @override
  Widget build(BuildContext context) {


    return Scaffold(

        body:Column(children: <Widget>[
          Expanded(
            child: InAppWebView(

              initialUrlRequest: URLRequest(url: WebUri(_lowCodeUrl)),
              initialSettings: InAppWebViewSettings(
                  isInspectable: kDebugMode,
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: true,
                  iframeAllow: "camera; microphone",
                  iframeAllowFullscreen: true




                  ),
              onPermissionRequest: (InAppWebViewController controller,
                  PermissionRequest request) async {
                await Permission.camera.request();
               await Permission.microphone.request();
                return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT);
              },
            ),
          ),
        ]));
  }
}
