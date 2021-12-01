# Low-Code-Video-Embed-with-Flutter

Documentation
Visit https://www.enablex.io/developer/video/low-code-video-embed/ to view the full Low-Code-Video-Embed developer guide documentation and get started.

Disclaimer
The EnableX help to the developer community to understand, How the Enablex Low-Code-Video-Embed product can be implemented using webview in Android Native App( Java/kotlin).


# How it work

## 1.Add  these  permission handler and Inapp webview package

![GitHub Logo](/images/package.png)

 ## 2.Add  these  permission

![GitHub Logo](/images/permission.png)


 ## 3. Here is an example:

import 'dart:io'; <br \>

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






