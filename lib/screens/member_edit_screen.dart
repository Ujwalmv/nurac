import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controlllers/details_controller.dart';
import '../model/details_model.dart';
import 'dart:io';
import 'dart:convert';

class EditMemberScreen extends StatelessWidget {
  final Details member;
  final String? resID;
  EditMemberScreen({super.key, required this.member,this.resID});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailsController>();
    final Color darkColor = const Color(0xFF383C44);

    // Initialize controller with member data
    controller.initializeFields(member);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        backgroundColor: darkColor,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            member.name ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),

      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: TextEditingController(text:resID.toString()),
                decoration: InputDecoration(

                  labelText: "ResID",enabled: false,
                  labelStyle: TextStyle(color: Colors.grey),
                  border: const UnderlineInputBorder(),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),

                ),
              ),
              // Image preview and picker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8), // Adjust for slightly rounded corners, or 0 for perfect square
                  ),
                  child: controller.selectedImage.value != null
                      ? Image.file(
                    controller.selectedImage.value!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                      : (member.photo != null && member.photo!.startsWith('data:image'))
                      ? Image.memory(
                    base64Decode(member.photo!.split(',')[1]),
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                      : (member.photo != null && member.photo!.isNotEmpty)
                      ? CachedNetworkImage(
                    imageUrl:
                    'https://tras.nurac.com/img/Uploads/${member.photo!}',
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.person, size: 50),
                  )
                      : const Icon(Icons.person, size: 50),
                ),
              ),

              // const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () => controller.pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera),
                    label: const Text("Camera"),
                  ),
                  TextButton.icon(
                    onPressed: () => controller.pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text("Gallery"),
                  ),
                ],
              ),
              ...controller.controllers.entries.map((entry) {
                final isDOBField = entry.key == 'Date of Birth';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: isDOBField
                        ? () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.tryParse(entry.value.text) ??
                                  DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              entry.value.text = "${pickedDate.toLocal()}"
                                  .split(' ')[0]; // YYYY-MM-DD
                            }
                          }
                        : null,
                    child: AbsorbPointer(
                      absorbing: isDOBField,
                      child: TextField(
                        controller: entry.value,
                        readOnly: isDOBField, // optional extra safeguard
                        decoration: InputDecoration(
                          labelText: entry.key,
                          labelStyle: TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          suffixIcon: isDOBField
                              ? Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.controllers.clear();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reset"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: controller.updateLoading.value
                          ? null
                          : () => controller.saveMemberData(member),
                      icon: const Icon(Icons.save),
                      label: controller.updateLoading.value
                          ? const CircularProgressIndicator()
                          : const Text("Save Changes"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
