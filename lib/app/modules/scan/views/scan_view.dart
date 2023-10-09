import 'package:camera/camera.dart';
import 'package:camerasoft/app/modules/scan/views/convert_percent.dart';
import 'package:camerasoft/app/modules/scan/views/progressbar.dart';
import 'package:camerasoft/app/modules/scan/views/remove_number.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mlkit_scanner/mlkit_scanner.dart';
import 'package:screenshot/screenshot.dart';
import '../controllers/scan_controller.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Camera'),
              centerTitle: true,
              actions: const [
                // ToggleButtons(
                //     isSelected: const [], children: const [Icon(Icons.circle)])
              ],
            ),
            backgroundColor: Colors.white,
            body: controller.isCameraInitialized.value
                ? Screenshot(
                    controller: controller.screenshotController,
                    child: Stack(
                      children: [
                        CameraPreview(
                          controller.cameraController,
                        ),
                        Positioned(
                            bottom: 186,
                            right: 0,
                            child: Container(
                              height: 120,
                              width: 230,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(controller.alamat,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  const SizedBox(height: 6),
                                  Text(controller.latitude.toString(),
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  const SizedBox(height: 6),
                                  Text(controller.longitude.toString(),
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  const SizedBox(height: 6),
                                  Text(controller.waktu,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
            bottomSheet: Container(
              height: 150,
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(controller.outputData.isNotEmpty
                      ? controller.outputData[0]['label']
                          .toString()
                          .removeLeadingNumber()
                      : 'Object tidak terdeteksi'),
                  const SizedBox(height: 12),
                  LinearProgressBar(
                      maxValue: 1,
                      value: controller.outputData.isNotEmpty
                          ? controller.outputData[0]['confidence']
                          : 0),
                  const SizedBox(height: 12),
                  Text(controller.outputData.isNotEmpty
                      ? stringToPercentage(
                          controller.outputData[0]['confidence'].toString())
                      : '0 %'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: Get.width,
                    child: ElevatedButton(
                        onPressed: controller.isButtonEnable
                            ? () => controller.captureImage()
                            : null,
                        child: const Text('Submit')),
                  )
                ],
              ),
            ),
            // body: c.isCameraInitialize == false
            //     ? const Center(child: CircularProgressIndicator())
            //     // : Stack(
            //     //     children: [
            //     //       Camera(
            //     //         controller.cameras,
            //     //         mobilenet,
            //     //         controller.setRecognitions,
            //     //       ),
            //     //       BndBox(
            //     //           controller.recognitions ?? [],
            //     //           math.max(controller.imageHeight, controller.imageWidth),
            //     //           math.min(controller.imageHeight, controller.imageWidth),
            //     //           Get.height,
            //     //           Get.width,
            //     //           controller.model),
            //     //     ],
            //     //   ),
            //     : Column(
            //         children: [
            //           Flexible(
            //             flex: 8,
            //             child: SizedBox(
            //               width: Get.width,
            //               child: controller.filePick != null
            //                   ? Container(
            //                       height: Get.height,
            //                       width: Get.width,
            //                       decoration: BoxDecoration(
            //                           image: DecorationImage(
            //                               image:
            //                                   FileImage(controller.filePick!))),
            //                     )
            //                   : Screenshot(
            //                       controller: controller.screenshotController,
            //                       child: Stack(
            //                         children: [
            //                           SizedBox(
            //                               width: Get.width,
            //                               child: CameraPreview(
            //                                   controller.cameraController)),
            //                           Positioned(
            //                               bottom: 16,
            //                               right: 16,
            //                               child: Container(
            //                                 height: 120,
            //                                 width: 170,
            //                                 padding: const EdgeInsets.all(16),
            //                                 decoration: BoxDecoration(
            //                                   color:
            //                                       Colors.black.withOpacity(0.3),
            //                                 ),
            //                                 child: Column(
            //                                   crossAxisAlignment:
            //                                       CrossAxisAlignment.start,
            //                                   children: [
            //                                     Text(
            //                                       controller.alamat,
            //                                       style: const TextStyle(
            //                                           color: Colors.white),
            //                                     ),
            //                                     const SizedBox(height: 6),
            //                                     Text(
            //                                       "${controller.lat}",
            //                                       style: const TextStyle(
            //                                           color: Colors.white),
            //                                     ),
            //                                     const SizedBox(height: 6),
            //                                     Text(
            //                                       controller.dateTime ?? '',
            //                                       style: const TextStyle(
            //                                           color: Colors.white),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ))
            //                         ],
            //                       )),
            //             ),
            //           ),
            //           Flexible(
            //             flex: 2,
            //             child: Container(
            //               height: 100,
            //               width: Get.width,
            //               color: Colors.white,
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Center(
            //                       child: Text(
            //                     '${controller.output}',
            //                     style: const TextStyle(color: Colors.black),
            //                   )),
            //                   GestureDetector(
            //                       onTap: () => controller.takeScreenshot(),
            //                       child: CircleAvatar(
            //                           backgroundColor: controller.filePick != null
            //                               ? Colors.amber
            //                               : Colors.white,
            //                           radius: 24,
            //                           child: const Icon(Icons.camera))),
            //                 ],
            //               ),
            //             ),
            //           )
            //         ],
            //       )
          );
        });
  }
}
