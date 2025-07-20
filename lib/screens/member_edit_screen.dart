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
  EditMemberScreen({super.key, required this.member, this.resID});

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
                controller: TextEditingController(text: resID.toString()),
                decoration: InputDecoration(
                  labelText: "ResID",
                  enabled: false,
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: controller.selectedImage.value != null
                      ? Image.file(
                          controller.selectedImage.value!,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : (member.photo != null &&
                            member.photo!.startsWith('data:image'))
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
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        child: TextButton.icon(
                          onPressed: () =>
                              controller.pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera),
                          label: const Text("Camera"),
                        ),
                      ),
                    ),
                    SizedBox(width: 1),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        child: TextButton.icon(
                          onPressed: () =>
                              controller.pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo),
                          label: const Text("Gallery"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...controller.controllers.entries.map((entry) {
                final isDOBField = entry.key == 'Date of Birth';

                // Dropdown with typing support: Qualification, Blood Group, Birthstar
                if (entry.key == "Qualification" ||
                    entry.key == "Birthstar" ||
                    entry.key == "Blood Group") {
                  final options = {
                    "Qualification": [
                      '1st Std',
                      '2nd Std',
                      '3rd Std',
                      '4th Std',
                      '5th Std',
                      '6th Std',
                      '7th Std',
                      '8th Std',
                      '9th Std',
                      '10th Std',
                      '11th Std',
                      '12th Std',
                      'Diploma',
                      'ITI',
                      'UG',
                      'PG',
                      'M.Phil',
                      'PhD',
                    ],
                    "Blood Group": [
                      'A+',
                      'A-',
                      'B+',
                      'B-',
                      'AB+',
                      'AB-',
                      'O+',
                      'O-',
                    ],
                    "Birthstar": [
                      'Ashwini',
                      'Bharani',
                      'Krittika',
                      'Rohini',
                      'Mrigashirsha',
                      'Ardra',
                      'Punarvasu',
                      'Pushya',
                      'Ashlesha',
                      'Magha',
                      'Purva Phalguni',
                      'Uttara Phalguni',
                      'Hasta',
                      'Chitra',
                      'Swati',
                      'Vishakha',
                      'Anuradha',
                      'Jyeshtha',
                      'Mula',
                      'Purva Ashadha',
                      'Uttara Ashadha',
                      'Shravana',
                      'Dhanishta',
                      'Shatabhisha',
                      'Purva Bhadrapada',
                      'Uttara Bhadrapada',
                      'Revati',
                    ],
                  }[entry.key]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RawAutocomplete<String>(
                      textEditingController: entry.value,
                      focusNode: FocusNode(),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return options.where((String option) {
                          return option.toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          );
                        });
                      },
                      fieldViewBuilder:
                          (
                            BuildContext context,
                            TextEditingController textController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted,
                          ) {
                            return TextField(
                              controller: textController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: entry.key,
                                labelStyle: TextStyle(color: Colors.grey),
                                border: const UnderlineInputBorder(),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: darkColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                      optionsViewBuilder: (
                          BuildContext context,
                          void Function(String) onSelected,
                          Iterable<String> options,
                          ) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4,
                            child: SizedBox(
                              width: 200, // Set your desired width here
                              child: ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: options.map((String option) {
                                  return ListTile(
                                    title: Text(option),
                                    onTap: () => onSelected(option),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },

                    ),
                  );
                }

                // Mem.NO and Membership in one row
                if (entry.key == "Mem.NO") {
                  final memNoController = entry.value;
                  final membershipController =
                      controller.controllers["Membership"]!;
                  return Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 8,
                            top: 8,
                            bottom: 8,
                          ),
                          child: TextField(
                            controller: memNoController,
                            decoration: InputDecoration(
                              labelText: 'Mem.NO',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: const UnderlineInputBorder(),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: darkColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            top: 8,
                            bottom: 8,
                          ),
                          child: TextField(
                            controller: membershipController,
                            decoration: InputDecoration(
                              labelText: 'Membership',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: const UnderlineInputBorder(),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: darkColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (entry.key == "Membership") return SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: isDOBField
                        ? () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.tryParse(entry.value.text) ??
                                  DateTime(1970),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              entry.value.text =
                                  "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                            }
                          }
                        : null,
                    child: AbsorbPointer(
                      absorbing: isDOBField,
                      child: TextField(
                        controller: entry.value,
                        readOnly: isDOBField,
                        decoration: InputDecoration(
                          labelText: entry.key,
                          labelStyle: TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: darkColor, width: 2),
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

              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.updateLoading.value
                            ? null
                            : () => controller.saveMemberData(member),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: controller.updateLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.save),
                                  SizedBox(width: 8),
                                  Text("Update"),
                                ],
                              ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller.resetFields(); // Reset fields
                        },
                        // icon: const Icon(Icons.refresh),
                        label: const Text(
                          "Reset",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                color: Colors.white,
                onSelected: (value) {
                  // String url = '';
                  // if (value == 'summary') {
                  //   url = '${ApiConstants.baseUrl}/address/download/${data.resID ?? 0}';
                  // } else if (value == 'details') {
                  //   url = '${ApiConstants.baseUrl}/members/download/${data.resID ?? 0}';
                  // } else if (value == 'blank') {
                  //   url = '${ApiConstants.baseUrl}/blank/download';
                  // }
                  // if (url.isNotEmpty) {
                  //   controller.downloadPDF(url);
                  // }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Transfer',
                    child: Text('Transfer'),
                  ),
                  const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                ],
                child: Container(
                  width: double.infinity,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,

                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: controller.downloadLoading.value
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2, // thinner ring
                            ),
                          )
                        : const Text(
                            "Action ▼",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
