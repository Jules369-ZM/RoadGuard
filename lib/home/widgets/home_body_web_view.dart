import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:road_guard/home/widgets/urls.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class HomeBodyWebView extends StatefulWidget {
  const HomeBodyWebView({super.key});

  @override
  State<HomeBodyWebView> createState() => _HomeBodyWebViewState();
}

class _HomeBodyWebViewState extends State<HomeBodyWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('allowing navigation to ${request.url}');
            if (request.url == eMag) {
              downloadEmag(context, request.url, 'eMag2024');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            if (change.url == eMag) {
              downloadEmag(context, eMag, 'eMag2024');
            }
            debugPrint('URL changed to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('JS message: ${message.message}');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse('https://www.rtsa.org.zm'));

    if (kIsWeb || !Platform.isMacOS) {
      controller.setBackgroundColor(const Color(0x80000000));
    }

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          if (await _controller.canGoBack()) {
            await _controller.goBack();
            return Future.value(false); // Prevent app from closing
          }
          return Future.value(true); // Allow app to close
        },
        child: WebViewWidget(
          key: UniqueKey(),
          controller: _controller,
        ),
      ),
    );
  }

  Future<void> downloadEmag(
    BuildContext context,
    String url,
    String name,
  ) async {
    try {
      final headers = {'Cookie': 'PHPSESSID=4pq926k9e01qpfm4r8kujht32f'};
      final dio = Dio();

      // Define the path where the file will be saved
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$name.pdf';
      // Make the GET request to download the APK file
      final response = await dio.get<dynamic>(
        url,
        options: Options(
          headers: headers,
          responseType:
              ResponseType.bytes, // Important for downloading binary files
        ),
        onReceiveProgress: (received, total) {
          final progress = received / total * 100;
          // _controller.add(progress);
          log('Progress: ${progress.toStringAsFixed(2)}% ($received/$total)');
        },
      );

      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.data as List<int>);

        // Open the downloaded PDF using OpenFilex
        await OpenFilex.open(filePath);
      } else {
        if (kDebugMode) {
          print(response.statusMessage);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading file: $e');
      }
    }
  }
}
