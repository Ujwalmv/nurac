import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controlllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Obx(() {

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(tag: "assets/images/logo.png",
                child: Image.asset("assets/images/logo.png", height: 80)),
                SizedBox(height: 16),
                Container(
                  height: 50,
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 50,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  height: 50,
                  width: double.infinity, // Full width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          4,
                        ), // Smaller radius
                      ),

                    ),
                    onPressed:authController.isLoading.value?(){}: () {
                      final username = usernameController.text.trim();
                      final password = passwordController.text.trim();
                      authController.login(username, password);
                    },
                    child: Center(
                      child: authController.isLoading.value?
             CircularProgressIndicator(color: Colors.white,):
             Text(
                        'Sign in',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text("© 2024. All Rights Reserved",style: TextStyle(color: Colors.grey),),
              ],
            );
          }),
        ),
      ),
    );
  }
}
