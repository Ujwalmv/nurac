import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nurac/screens/login.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_model.dart';
import '../screens/home.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    final url = Uri.parse('https://tras.nurac.com/api/login/$username/$password');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loginResponse = LoginResponse.fromJson(data);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('AssociationID', loginResponse.associationID);

        Get.off(() => HomePage());
      } else {
        Get.snackbar('Error', 'Invalid credentials');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> logout() async {
    Get.defaultDialog(
      title: "Confirm Logout",
      middleText: "Are you sure you want to log out?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Get.offAll(LoginPage());
      },
      onCancel: () {
        Get.back(); // just closes the dialog
      },
    );
  }

}
