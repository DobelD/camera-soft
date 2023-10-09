import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  String alamat = "";
  double latitude = 0.0;
  double longitude = 0.0;
  String waktu = "";
  bool isLoading = false;
  final box = GetStorage();

  Future<void> checkAndRequestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }
  }

  Future<void> initGeolocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude = position.latitude;
    longitude = position.longitude;
    box.write('latitude', position.latitude);
    box.write('longitude', position.longitude);
    update();
  }

  Future<void> getAddressFromCoordinates() async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks[0];
        alamat =
            "${placemark.locality} - ${placemark.subLocality} - ${placemark.thoroughfare}";
        box.write('alamat', alamat);
        update();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void updateWaktu() {
    final DateTime now = DateTime.now();
    final String formattedTime = DateFormat("dd-MM-yyyy HH:mm").format(now);
    waktu = formattedTime;
    box.write('waktu', formattedTime);
    update();
  }

  Future<void> initData() async {
    isLoading = true;
    update();
    await checkAndRequestLocationPermission();
    await initGeolocation();
    await getAddressFromCoordinates();
    updateWaktu();
    isLoading = false;
    update();
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }
}
