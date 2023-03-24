
import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui' as ui;


class WebViewXPage extends StatefulWidget {
  const WebViewXPage({
    Key? key,
  }) : super(key: key);

  @override
  _WebViewXPageState createState() => _WebViewXPageState();
}

class _WebViewXPageState extends State<WebViewXPage> {
  late IFrameElement _element;


  Size get screenSize => MediaQuery.of(context).size;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'LowCodeEmbed',

            (int viewId) => IFrameElement()
          ..width = '640'
          ..height = '360'
          ..src = ""// Replace by your own low code url
          ..style.border = 'none'
        ..allow= "camera; microphone; fullscreen; speaker; display-capture"

    );
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enablex Meeting'),
      ),
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: const HtmlElementView(viewType:"LowCodeEmbed" ),
      ),
    );
  }



}