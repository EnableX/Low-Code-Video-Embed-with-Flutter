import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final MethodChannel _pipChannel = const MethodChannel('com.example.pip');
  InAppWebViewController? _webViewController;
  Size get screenSize => MediaQuery.of(context).size;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _lowCodeUrl += '?skipMediaPermissionPrompt';
    _setupPipListener();

  }
  void _setupPipListener() {
    _pipChannel.setMethodCallHandler((call) async {
      if (!mounted) return; // Important check
      switch (call.method) {
        case 'onPipClosed':
          print("PiP close: ");
        // Case 1: User clicked "X" → Destroy WebView
          if (_webViewController != null) {
            _webViewController!.dispose();
            SystemNavigator.pop();
          }
          break;
        case 'onPipEntered':
          //final dynamic data = call.arguments;
          print("PiP entering: ");
          Map<String, dynamic> data = {
            'action': 'minimized',
          };
          String jsonString = jsonEncode(data); // Convert to JSON
          _webViewController?.evaluateJavascript(
              source: "fromAndroid($jsonString);"
          );
          break;
        case 'onPipExpanded':
        // Case 2: User exited PiP to fullscreen → Process data
          //final dynamic data = call.arguments;
          print("PiP fullscreen: ");
          Map<String, dynamic> data = {
            'action': 'maximized',
          };
          String jsonString = jsonEncode(data); // Convert to JSON
          _webViewController?.evaluateJavascript(
              source: "fromAndroid($jsonString);"
          );

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

        body:Column(children: <Widget>[
          Expanded(
            child: InAppWebView(

              initialUrlRequest: URLRequest(url: WebUri(_lowCodeUrl)),
              onWebViewCreated: (controller) {
                _webViewController = controller;
                controller.addJavaScriptHandler(
                  handlerName: 'AndroidInterface',
                  callback: (args) {
                    final method = args[0];
                    final data = args.length > 1 ? args[1] : null;
                    print("Login with: $data");
                    // switch (method) {
                    //   case 'login':
                    //     print("Login with: $data");
                    //     break;
                    //   case 'logout':
                    //     print("Logout called");
                    //     break;
                    //   default:
                    //     print("Unknown method: $method");
                    // }
                    try {
                      _pipChannel.invokeMethod('isConnected');
                    } catch (e) {
                      print('Error entering PIP: $e');
                    }
                    return "Flutter handled $method";
                  },
                );

              },
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
  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }
}
