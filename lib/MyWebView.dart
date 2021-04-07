import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class MyWebView extends StatefulWidget {
  MyWebView({Key key, this.title, this.selectedUrl}) : super(key: key);

  final String title;
  final String selectedUrl;

  // final String title;
  // final String selectedUrl;
  @override
  _MyWebView createState() => _MyWebView();
}

class _MyWebView extends State<MyWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String os = Platform.operatingSystem;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    print("++++++++++++++++++++++++++++++++++++++$os");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: WebView(
          initialUrl: widget.selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          gestureNavigationEnabled: true,
          debuggingEnabled: true,
          allowsInlineMediaPlayback: true,
        ));
  }
}
