# Low-Code-Video-Embed-with-Flutter

EnableX Video Embed is an easy-to-use Video Calling API loaded with powerful conferencing, collaborative, and reporting features. You can build one-to-one or multiparty video meetings for any application or browser within minutes using its simple yet powerful REST API.

You do not need client-side SDKs to develop an engaging UI layout for a video meeting application. Just select our pre-built UI or you can also design it with the EnableX App Visual Builder, and you can go live within minutes with your fully-functional video meeting application.

# Documentation
Visit https://www.enablex.io/developer/video/low-code-video-embed/ to view the full Low-Code-Video-Embed developer guide documentation and get started.


The enableX help to the developer community to understand, How the Enablex Low-Code-Video-Embed product can be implemented using webview in Flutter App( Dart).


# How it work

## 1.Add  these  permission handler and Inapp webview package

![GitHub Logo](/images/package.png)

 ## 2.Add  these  permission
### Requires camera and mic permission for Audio and video streaming

![GitHub Logo](/images/permission.png)


 ## 3. Here is an example:

import 'dart:io'; <br />

import 'package:flutter/material.dart';<br />
import 'package:flutter_inappwebview/flutter_inappwebview.dart';<br />
import 'package:permission_handler/permission_handler.dart';<br />

var _lowCodeUrl = " "; // Replace by your own

void main() {<br />
runApp(const MyApp());<br />
}

class MyApp extends StatelessWidget {<br />
const MyApp({Key? key}) : super(key: key);<br />

@override
Widget build(BuildContext context) {<br />
if (Platform.isAndroid) {<br />
_lowCodeUrl += '?skipMediaPermissionPrompt';<br />
}
return const MaterialApp(
debugShowCheckedModeBanner: false,
home: InAppWebViewPage(),
);
}
}

class InAppWebViewPage extends StatefulWidget {<br />
const InAppWebViewPage();

@override
State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {


@override
Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: const Text("Meeting")),
        body: Column(children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(_lowCodeUrl)),
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    mediaPlaybackRequiresUserGesture: false,
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






