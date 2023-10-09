import 'dart:developer';
import 'dart:io';
import 'package:barcode_finder/barcode_finder.dart';
import 'package:get/get.dart';

import '../../../utils/qr_render.dart';

class QrscanController extends GetxController {
  File? imageScan;
  bool isLoading = false;
  String? currentResult;

  setImage() {
    imageScan = File(Get.arguments);
    isLoading = true;
    update();
    Future.delayed(2.seconds, () {
      print("Path : ${imageScan!.path}");
      scanFile(imageScan!.path);
      isLoading = false;
      update();
    });
  }

  // scanImage(String path) async {
  //   final result = await FlutterQrReader.imgScan(File(path));
  //   currentResult = result;
  //   update();
  //   print(result);
  // }

  Future<void> scanFile(String path) async {
    String? barcode = await BarcodeFinder.scanFile(path: path);
    currentResult = barcode;
    update();
    print("Result : $barcode");
    log("Result : $barcode");
  }

  @override
  void onInit() {
    setImage();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    imageScan!.delete();
  }

  @override
  void dispose() {
    imageScan!.delete();
    super.dispose();
  }
}
