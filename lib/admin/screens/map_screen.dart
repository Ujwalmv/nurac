import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import '../controlllers/map_controller.dart';

class MapPickerScreen extends StatelessWidget {
  final controller = Get.put(MapController());
  final String googleApiKey = "AIzaSyBgZuaVjoF9kBUK558Z6fcW-vlp6gVOiII"; // Replace with your test key

  MapPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Stack(
        children: [
          Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: controller.currentPosition.value,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (mapCtrl) => controller.mapController = mapCtrl,
            onCameraMove: (position) => controller.pickedLocation.value = position.target,
            onCameraIdle: () async {
              final pos = controller.pickedLocation.value;
              if (pos != null) {
                controller.selectedAddress.value =
                await controller.getAddressFromLatLng(pos.latitude, pos.longitude);
              }
            },
          )),
          Center(
            child: Icon(Icons.location_pin, size: 40, color: Colors.red),
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(8),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: TextEditingController(),
                googleAPIKey: googleApiKey,
                inputDecoration: const InputDecoration(
                  hintText: "Search location...",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                debounceTime: 800,
                countries: const ["in"], // Optional country restriction
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (prediction) {
                  if (prediction.lat != null && prediction.lng != null) {
                    controller.moveToLocation(
                      double.parse(prediction.lat!),
                      double.parse(prediction.lng!),
                    );
                  }
                },
                itemClick: (prediction) {},
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Obx(() => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
              ),
              child: Text(
                controller.selectedAddress.value,
                style: const TextStyle(fontSize: 16),
              ),
            )),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: controller.confirmLocation,
              icon: const Icon(Icons.check),
              label: const Text("Confirm Location"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
