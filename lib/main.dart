import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:low_code_embed_with_flutter/web_page.dart';
import 'package:permission_handler/permission_handler.dart';


var _lowCodeUrl = ""; // Replace by your own
void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return  const MaterialApp(
      home: kIsWeb?WebViewXPage():InAppWebViewPage(),
    );
  }
}

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage();

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
        appBar: AppBar(title: const Text("Meeting")),
        body:Column(children: <Widget>[
          Expanded(
            child: InAppWebView(

              initialUrlRequest: URLRequest(url: Uri.parse(_lowCodeUrl)),
              initialOptions: InAppWebViewGroupOptions(

                  crossPlatform: InAppWebViewOptions(
                    mediaPlaybackRequiresUserGesture: false,
                    supportZoom: false,
                    //  userAgent:Platform.isIOS? "Mozilla/5.0 (iPhone; CPU iPhone OS 16_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/604.1":"",

                  ),
                  ios: IOSInAppWebViewOptions(
                    allowsInlineMediaPlayback: true,



                  )),
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                await Permission.camera.request();
                await Permission.microphone.request();
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
            ),
          ),
        ]));
  }
}
