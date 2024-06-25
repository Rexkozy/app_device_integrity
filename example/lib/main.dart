import 'dart:developer';
import 'dart:io';
import 'package:app_device_integrity_example/services/providers/attest_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:app_device_integrity/app_device_integrity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _tokenExample = 'UNKNOWN';
  final _appAttestationPlugin = AppDeviceIntegrity();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var tokenReceived;
    AttestProvider attestProvider = AttestProvider();

    try {
      // String sessionId = await attestProvider.getSession();
      String sessionId = "3abcd48be9b0cf8513ff91688ba822493b0804d2f3bcc5d5";
      log(sessionId.toString());
      if (Platform.isAndroid) {
        // int gpc = 0000000000; // YOUR GCP PROJECT ID IN ANDROID
        int gpc = 525354232116; // YOUR GCP PROJECT ID IN ANDROID
        tokenReceived = await _appAttestationPlugin
            .getAttestationServiceSupport(challengeString: sessionId, gcp: gpc);
        setState(() {
          _tokenExample = tokenReceived;
        });
        log(_tokenExample.toString());

        return;
      }
      tokenReceived = await _appAttestationPlugin.getAttestationServiceSupport(
          challengeString: sessionId);
      setState(() {
        _tokenExample = tokenReceived;
      });
    } on PlatformException {
      tokenReceived = 'Failed to get token';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: _tokenExample));
            },
              child: Text('Running token: $_tokenExample')),
        ),
      ),
    );
  }
}
