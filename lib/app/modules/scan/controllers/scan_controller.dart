import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mlkit_scanner/mlkit_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../../../routes/app_pages.dart';

class ScanController extends GetxController {
  final box = GetStorage();

  late CameraController cameraController;
  BarcodeScannerController? scanController;
  ScreenshotController screenshotController = ScreenshotController();
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var outputData = [];
  List<String> barcodes = [];
  var isButtonEnable = false;
  var isBarcode = false;
  String alamat = "";
  double latitude = 0.0;
  double longitude = 0.0;
  String waktu = "";
  File? qrBarcode;
  var qrBarcodeImages;

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      // Cari kamera depan
      CameraDescription? frontCamera;
      for (final camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.back) {
          frontCamera = camera;
          break;
        }
      }

      if (frontCamera == null) {
        print("Kamera depan tidak ditemukan");
        return;
      }

      cameraController = CameraController(frontCamera, ResolutionPreset.max);
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized(true);
      update();
    } else {
      print("Izin kamera ditolak");
    }
  }

  initTfLite() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false);
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((e) {
          return e.bytes;
        }).toList(),
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 1,
        rotation: 90,
        threshold: 0.4);

    if (detector != null) {
      outputData = detector;
      update();
      log("Result is $detector");
      if (detector[0]['confidence'] > 0.6) {
        isButtonEnable = true;
        update();
      }
    }
  }

  changeCamera(bool isFront) {
    if (isFront) {
      initCamera();
    } else {
      initCamera();
    }
  }

  initData() {
    alamat = box.read('alamat');
    latitude = box.read('latitude');
    longitude = box.read('longitude');
    waktu = box.read('waktu');
  }

  Future<void> captureImage() async {
    isCameraInitialized(true);
    update();
    final directory = await getApplicationDocumentsDirectory();
    screenshotController.captureAndSave(directory.path).then((value) {
      if (value != null) {
        Get.offNamedUntil(Routes.QRSCAN, (route) => route.isFirst,
            arguments: value);
      }
    });
  }

  Future<void> onScannerInitialized(BarcodeScannerController controller) async {
    scanController = controller;
    await scanController?.startScan(100);
    // if (program.products?.length != 0 || program.products!.isNotEmpty) {
    //   await scanController?.startScan(100);
    // } else {
    //   await scanController?.cancelScan();
    // }
  }

  Future<void> scanBarcode(Barcode code) async {
    if (code.format == BarcodeFormat.code128) {
      // if (!isScans) {
      //   barcodes.add(code.rawValue);
      // }
      log("Result : ${code.rawValue}");
      barcodes.add(code.rawValue);
      update();
      scanController?.cancelScan();
      print("Berhasil");
    }
  }

  @override
  void onInit() {
    super.onInit();
    initData();
    initCamera();
    initTfLite();
  }

  @override
  void onClose() {
    super.onClose();
    scanController?.cancelScan();
    cameraController.dispose();
  }
}
