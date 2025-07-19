// controllers/details_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nurac/screens/home.dart';
import 'dart:convert';

import '../constants/api_const.dart';
import '../model/details_model.dart';


class DetailsController extends GetxController {
  var isLoading = false.obs;
  var updateLoading = false.obs;
  var detailsModel = DetailsModel().obs;

  final addressController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();

  Future<void> fetchDetails(int id) async {
    try {
      isLoading.value = true;
      final response =
      await http.get(Uri.parse(ApiConstants.residentDetails(id)));

      if (response.statusCode == 200) {
        final model = DetailsModel.fromJson(json.decode(response.body));
        detailsModel.value = model;

        // Fill text fields with values
        addressController.text = model.address1 ?? '';
        phone1Controller.text = model.phone1 ?? '';
        phone2Controller.text = model.phone2 ?? '';
      } else {
        Get.snackbar("Error", "Failed to load data");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDetails() async {
    final body = {
      "Address1": addressController.text,
      "AssociationID": detailsModel.value.associationID,
      "Code": detailsModel.value.code,
      "Phone1": phone1Controller.text,
      "Phone2": phone2Controller.text,
      "ResID": detailsModel.value.resID,
    };

    try {
      updateLoading.value=true;
      final response = await http.put(
        Uri.parse(ApiConstants.residentDetails(detailsModel.value.resID!)),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        await Get.snackbar("Success", "Details updated successfully");
        // await fetchDetails(detailsModel.value.resID!); // refresh
        // Get.back();
        await Get.offAll(HomePage());
      } else {
        Get.snackbar("Error", "Update failed");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
    finally {
      updateLoading.value = false;
    }
  }

  @override
  void onInit() {

    super.onInit();
  }
}
