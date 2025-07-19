// screens/details_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controlllers/auth_controller.dart';
import '../controlllers/details_controller.dart';


class DetailsScreen extends StatelessWidget {
  final DetailsController controller = Get.put(DetailsController());
  final authController = Get.find<AuthController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25,
        backgroundColor: const Color(0XFF383c44),
        title: Hero(tag: "",
            child: Image.asset("assets/images/logo-white.png", height: 30)),
        actions: [
          IconButton(
            onPressed: authController.logout,
            icon: const Text(
              "Logout  ",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final data = controller.detailsModel.value;

        return SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _labelValue(" Res.ID : ", data.code ?? ''),
              SizedBox(height: 10),
              Text("Address", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: controller.addressController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text("Phone 1", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: controller.phone1Controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              Text("Phone 2", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: controller.phone2Controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => controller.updateDetails(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child:controller.updateLoading==true?Text('Updating...'): Text('Update'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => controller.fetchDetails(data.resID!),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: Text('Reset'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                child: Text('Show Access for ResID ${data.code}'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text('Download ▼'),
              ),
              SizedBox(height: 20),
              Text("FAMILY MEMBERS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Divider(),
              ...?data.details?.map((member) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text("${member.name ?? ''} (${member.relation ?? ''})",
                    style: TextStyle(fontSize: 15)),
              )),
            ],
          ),
        );
      }),
    );
  }

  Widget _labelValue(String label, String value) {
    return Container(
      color: Color(0XFF383c44).withOpacity(.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 25)),
          Text(value,style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
