import 'dart:async';
import 'dart:io';

import 'package:admission/provider/admission_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdmissionPaymentScreen extends StatefulWidget {
  const AdmissionPaymentScreen({super.key});

  @override
  State<AdmissionPaymentScreen> createState() => _AdmissionPaymentScreenState();
}

class _AdmissionPaymentScreenState extends State<AdmissionPaymentScreen> {
  String url = '';
  String applicantId = '';
  String admissionUserId = '';
  late bool isLoading = false;
  @override
  void initState() {
    applicantId =
        Provider.of<AdmissionProvider>(context, listen: false).applicantId!;
    admissionUserId = Provider.of<AdmissionProvider>(context, listen: false)
        .admission_user_id
        .toString();
    if (Platform.isAndroid) {
      url =
          'http://10.0.2.2:8000/admissionpayment/create/$applicantId/$admissionUserId';
    } else {
      url =
          'http://localhost:8000/admissionpayment/create/$applicantId/$admissionUserId';
    }
    setState(() {
      url = "https://theshillongtimes.com";
    });
    super.initState();
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admission Payment'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageStarted: (url) => {
                setState(() {
                  isLoading = true;
                })
              },
              onPageFinished: (url) => {
                setState(() {
                  isLoading = false;
                })
              },
            ),
    );
  }
}
