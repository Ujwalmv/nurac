import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../admin/controlllers/auth_controller.dart';
import '../../admin/controlllers/details_controller.dart';
import '../../admin/screens/details_screen.dart';

class UserhomePage extends StatelessWidget {
  UserhomePage({super.key});
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog
        bool shouldClose = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to close the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        return shouldClose;
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leadingWidth: 25,
          backgroundColor: const Color(0XFF383c44),
          title: Hero(
            tag: "",
            child: Image.asset("assets/images/logo-white.png", height: 30),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              // authController.logout,
              icon: const Text(
                "Logout  ",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final resId = prefs.getInt('resID');
                  Get.to(
                    () => DetailsScreen(PID: resId, newMember: false),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: 300),
                  );

                  Get.put(DetailsController()).fetchDetails(resId ?? 0);
                },
                child: Container(
                  width: double.infinity,
                  color: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                  child: Text(
                    "FAMILY DETAILS",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                color: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                child: Text(
                  "DIRECTORY",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
