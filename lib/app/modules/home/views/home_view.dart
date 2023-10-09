import 'package:camerasoft/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (c) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.toNamed(Routes.SCAN),
              child: const Icon(Icons.camera_alt_rounded),
            ),
            backgroundColor: Colors.white,
            body: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(controller.alamat),
                      const SizedBox(height: 12),
                      Text(controller.latitude.toString()),
                      const SizedBox(height: 12),
                      Text(controller.longitude.toString()),
                      const SizedBox(height: 12),
                      Text(controller.waktu),
                    ],
                  ),
          );
        });
  }
}
