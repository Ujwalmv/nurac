import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nurac/admin/controlllers/details_controller.dart';

class MapController extends GetxController with WidgetsBindingObserver {
  late GoogleMapController mapController;

  var currentPosition = const LatLng(10.8505, 76.2711).obs;
  var pickedLocation = Rxn<LatLng>();
  var selectedAddress = "".obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this); // Listen for app lifecycle changes
    fetchCurrentLocation();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up observer
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When coming back from location settings, retry location fetch
      fetchCurrentLocation();
    }
  }

  Future<void> fetchCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.defaultDialog(
        title: "Location Off",
        middleText: "Please enable location services to continue.",
        textConfirm: "Open Settings",
        textCancel: "Cancel",
        onConfirm: () async {
          Get.back();
          await Geolocator.openLocationSettings();
        },
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        Get.snackbar("Permission Denied", "Location permissions are denied.");
        return;
      }
    }

    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPosition.value = LatLng(position.latitude, position.longitude);
      pickedLocation.value = currentPosition.value;
      selectedAddress.value = await getAddressFromLatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(currentPosition.value));
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch location.");
    }
  }

  void moveToLocation(double lat, double lng) {
    final newLocation = LatLng(lat, lng);
    pickedLocation.value = newLocation;
    currentPosition.value = newLocation;
    mapController.animateCamera(CameraUpdate.newLatLng(newLocation));
    getAddressFromLatLng(lat, lng).then((value) => selectedAddress.value = value);
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        return "No address found";
      }
    } catch (e) {
      return "Error getting address";
    }
  }

  void confirmLocation() {
    if (pickedLocation.value != null) {
      // Set location in DetailsController
      Get.find<DetailsController>().setLocationFromMap(
        lat: pickedLocation.value!.latitude,
        lng: pickedLocation.value!.longitude,
        address: selectedAddress.value,
      );

      // Pass data back to previous screen
      Get.back(result: {
        "lat": pickedLocation.value!.latitude,
        "lng": pickedLocation.value!.longitude,
        "address": selectedAddress.value,
      });
    } else {
      Get.snackbar("Select Location", "Please tap to select a location");
    }
  }
}
