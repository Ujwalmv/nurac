import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nurac/user/screens/userHome_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/api_const.dart';

import '../model/login_model.dart';
import '../screens/home.dart';
import '../screens/login.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  Future<void> login(String username, String password) async {
    isLoading.value = true;

    try {
      final url = Uri.parse(ApiConstants.login(username, password));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userType = data['UserType'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('AssociationID', data['AssociationID'] ?? 0);
        await prefs.setString('userType', userType ?? '');

        if (userType == 'User') {
          final user = LoginUserResponse.fromJson(data);
          await prefs.setInt('resID', user.resID ?? 0);
          await prefs.setString('username', user.username ?? '');
          await prefs.setString('mobile', user.mobile ?? '');
          Get.off(() => UserhomePage());
        } else if (userType == 'Admin') {
          final admin = LoginResponse.fromJson(data);
          await prefs.setInt('adminKey', admin.key ?? 0);
          await prefs.setString('adminName', admin.name ?? '');
          await prefs.setString('mobile', admin.mobile ?? '');
          Get.off(() => HomePage());
        } else {
          Get.snackbar('Login Failed', 'Unknown user type');
        }
      } else {
        Get.snackbar('Login Failed', 'Invalid credentials');
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
        Get.back();
      },
    );
  }
}
