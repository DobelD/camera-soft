import 'package:camerasoft/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/qrscan_controller.dart';

class QrscanView extends GetView<QrscanController> {
  const QrscanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrscanController>(
        init: QrscanController(),
        builder: (controller) {
          return controller.isLoading
              ? Container(
                  color: Colors.white,
                  height: Get.height,
                  width: Get.width,
                  child: const Center(child: CircularProgressIndicator()))
              : Scaffold(
                  appBar: AppBar(
                    title: const Text('QrscanView'),
                    centerTitle: true,
                    leading: IconButton(
                        onPressed: () {
                          controller.imageScan!.delete();
                          Get.offNamed(Routes.HOME);
                        },
                        icon: const Icon(Icons.arrow_back)),
                  ),
                  body: Column(
                    children: [
                      Container(
                        height: Get.height * 0.7,
                        width: Get.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                                image: FileImage(controller.imageScan!),
                                fit: BoxFit.contain)),
                      ),
                      Container(
                        height: Get.height * 0.1,
                        width: Get.width,
                        color: Colors.white,
                        child: Center(
                          child: Text(controller.currentResult ?? '-'),
                        ),
                      )
                    ],
                  ));
        });
  }
}
