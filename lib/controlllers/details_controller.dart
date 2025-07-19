import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nurac/controlllers/home_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import '../constants/api_const.dart';
import '../model/details_model.dart';
import '../screens/home.dart';

class DetailsController extends GetxController {
  var isLoading = false.obs;
  var updateLoading = false.obs;
  var whatsAppLoading = false.obs;
  var downloadLoading = false.obs;
  var detailsModel = DetailsModel().obs;

  final addressController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();

  Future<void> fetchDetails(int id) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(ApiConstants.residentDetails(id)),
      );

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
      updateLoading.value = true;
      final response = await http.put(
        Uri.parse(ApiConstants.residentDetails(detailsModel.value.resID!)),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        await Get.find<HomeController>().fetchHomeData();
        updateLoading.value = false;
        await Get.snackbar("Success", "Details updated successfully");
        await Get.off(HomePage());
      } else {
        Get.snackbar("Error", "Update failed");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      updateLoading.value = false;
    }
  }

  /// 🔗 Open WhatsApp with access message from API
  Future<void> openWhatsappWithAccessMessage(
    int associationId,
    int resId,
  ) async {
    try {
      whatsAppLoading.value = true;
      final response = await http.get(
        Uri.parse(
          'https://tras.nurac.com/api/create/user/get/$associationId/$resId',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final name = data['Name'] ?? '';
        final username = data['Username'] ?? '';
        final password = data['Password'] ?? '';
        final url = data['URL'] ?? '';

        final message = Uri.encodeComponent(
          "Hello $name, your login details:\n"
          "🔹 Username: $username\n"
          "🔹 Password: $password\n"
          "🔹 Login Link: $url",
        );

        String? phone = phone1Controller.text.trim().isNotEmpty
            ? phone1Controller.text.trim()
            : phone2Controller.text.trim();

        if (phone.isNotEmpty) {
          phone = phone.replaceAll(RegExp(r'[^\d]'), '');
          if (phone.startsWith('91')) phone = phone.substring(2);
          if (phone.startsWith('0')) phone = phone.substring(1);

          try {
            await launchUrl(
              Uri.parse("whatsapp://send?phone=91$phone&text=$message"),
              mode: LaunchMode.externalApplication,
            );
          } catch (e) {
            await launchUrl(
              Uri.parse("https://wa.me/91$phone?text=$message"),
              mode: LaunchMode.externalApplication,
            );
          }
        } else {
          Get.snackbar("Error", "No phone number found");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed: ${e.toString()}");
    } finally {
      whatsAppLoading.value = false;
    }
  }

  Future<void> downloadPDF(String url) async {
    try {
      downloadLoading.value = true;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final path =
            '${directory!.path}/downloaded_file_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        Get.snackbar('Success', 'File downloaded to $path');
        OpenFile.open(file.path); // Optional: opens the PDF after downloading
      } else {
        Get.snackbar('Error', 'Failed to download file');
      }
    } catch (e) {
      Get.snackbar('Error', 'Download failed: $e');
    } finally {
      downloadLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
