import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurac/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';


class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkLogin();
    return Scaffold(
      body: Center(
        child: Hero(tag:"",
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/splash.png",height: 100,),
            Image.asset("assets/images/logo-name.png",height: 50,),
          ],
        )),

      ),
    );
  }

  void _checkLogin() async {
    await Future.delayed(Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('AssociationID')) {
      Get.off(() => HomePage());
    } else {
      Get.off(() => LoginPage());
    }
  }
}
