// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';

Widget buildWebView() {
  const String viewId = 'LowCodeEmbed';
  const String lowCodeUrl = 'https://your-low-code-url.com?skipMediaPermissionPrompt'; // Replace it

  // Register the iframe only once
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    viewId,
        (int viewId) => IFrameElement()
      ..src = lowCodeUrl
      ..style.border = 'none'
      ..allow = "camera; microphone; fullscreen; speaker; display-capture"
      ..width = '100%'
      ..height = '100%',
  );

  return const HtmlElementView(viewType: viewId);
}
