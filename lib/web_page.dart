import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'web_view_stub.dart'
if (dart.library.html) 'web_view_web.dart';

class WebViewXPage extends StatelessWidget {
  const WebViewXPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enablex Meeting')),
      body: kIsWeb
          ? buildWebView()
          : const Center(child: Text("Not supported on this platform")),
    );
  }
}
