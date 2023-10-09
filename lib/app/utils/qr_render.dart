import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterQrReader {
  static const MethodChannel _channel =
      MethodChannel('me.ali.flutter_qr_reader');

  static Future<String?> imgScan(File file) async {
    log("Channel : $_channel");
    if (file.existsSync() == false) {
      return null;
    }
    try {
      final rest =
          await _channel.invokeMethod("imgQrCode", {"file": file.path});
      log("Path : ${file.path}");
      log("REST : $rest");
      return rest;
    } catch (e) {
      log("Error : $e");
      print(e);
      return null;
    }
  }
}
