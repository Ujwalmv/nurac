import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../user/screens/userHome_page.dart';
import 'home.dart';
import 'login.dart';


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

  // void _checkLogin() async {
  //   await Future.delayed(Duration(seconds: 2));
  //   final prefs = await SharedPreferences.getInstance();
  //
  //
  //     final userType = prefs.getString('userType');
  //     if (userType == 'Admin') {
  //       Get.off(() => HomePage());
  //     } else if (userType == 'User') {
  //       Get.off(() => UserhomePage());
  //     } else {
  //       Get.off(() => LoginPage());
  //     }
  //   }



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
