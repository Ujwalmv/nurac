import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controlllers/details_controller.dart';
import '../model/details_model.dart';
import 'dart:io';
import 'dart:convert';

class EditMemberScreen extends StatelessWidget {
  final Details? member;
  final String? resID;
  bool? newMember;
  EditMemberScreen({super.key, this.newMember, this.member, this.resID});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailsController>();
    final Color darkColor = const Color(0xFF383C44);

    // Initialize controller with member data
    if (newMember == false) controller.initializeFields(member!);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        backgroundColor: darkColor,
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            member?.name ?? "New Member",
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
                      : (member?.photo != null &&
                            member!.photo!.startsWith('data:image'))
                      ? Image.memory(
                          base64Decode(member!.photo!.split(',')[1]),
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : (member?.photo != null && member!.photo!.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl:
                              'https://tras.nurac.com/img/Uploads/${member?.photo!}',
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
                final live=entry.key=="Living Status";
                final focusNode = controller.focusNodes[entry.key];
                final keys = controller.controllers.keys.toList();
                final currentIndex = keys.indexOf(entry.key);

                // Dropdown with typing support: Qualification, Blood Group, Birthstar
                if (entry.key == "Qualification" ||
                    entry.key == "Birthstar" ||
                    entry.key == "Blood Group") {
                  final options = {
                    "Qualification": [
                      '1ST STD',
                      '2ND STD',
                      '3RD STD',
                      '4TH STD',
                      '5TH STD',
                      '6TH STD',
                      '7TH STD',
                      '8TH STD',
                      '9TH STD',
                      '10TH STD',
                      '11TH STD',
                      '12TH STD',
                      'DIPLOMA',
                      'ITI',
                      'UG',
                      'PG',
                      'M.PHIL',
                      'PHD',
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
                      'ASHWINI',
                      'BHARANI',
                      'KRITTIKA',
                      'ROHINI',
                      'MRIGASHIRSHA',
                      'ARDRA',
                      'PUNARVASU',
                      'PUSHYA',
                      'ASHLESHA',
                      'MAGHA',
                      'PURVA PHALGUNI',
                      'UTTARA PHALGUNI',
                      'HASTA',
                      'CHITRA',
                      'SWATI',
                      'VISHAKHA',
                      'ANURADHA',
                      'JYESHTHA',
                      'MULA',
                      'PURVA ASHADHA',
                      'UTTARA ASHADHA',
                      'SHRAVANA',
                      'DHANISHTA',
                      'SHATABHISHA',
                      'PURVA BHADRAPADA',
                      'UTTARA BHADRAPADA',
                      'REVATI',
                    ],
                  }[entry.key]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RawAutocomplete<String>(
                      textEditingController: entry.value,
                      focusNode: focusNode,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return options.where((String option) {
                          return option.toLowerCase().contains(
                            textEditingValue.text.toUpperCase(),
                          );
                        });
                      },
                      fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController textController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted,
                          ) {
                        return TextField(
                          controller: textController,
                          focusNode: focusNode,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            if (currentIndex < keys.length - 1) {
                              final nextKey = keys[currentIndex + 1];
                              controller.focusNodes[nextKey]?.requestFocus();
                            } else {
                              FocusScope.of(context).unfocus();
                            }
                          },
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
                              width: 200,
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

                // Mem.NO and Membership
                if (entry.key == "Mem.NO") {
                  final memNoController = entry.value;
                  final membershipController = controller.controllers["Membership"]!;
                  return Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                          child: TextField(
                            controller: memNoController,
                            focusNode: controller.focusNodes["Mem.NO"],
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) =>
                                controller.focusNodes["Membership"]?.requestFocus(),
                            decoration: InputDecoration(
                              labelText: 'Mem.NO',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: const UnderlineInputBorder(),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: darkColor, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                          child: TextField(
                            controller: membershipController,
                            focusNode: controller.focusNodes["Membership"],
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) {
                              if (currentIndex + 1 < keys.length) {
                                controller.focusNodes[keys[currentIndex + 1]]?.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Membership',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: const UnderlineInputBorder(),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: darkColor, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (entry.key == "Membership") return SizedBox.shrink();
                if (live && entry.value.text.isEmpty) {
                  entry.value.text = "LIVE";
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: isDOBField
                        ? () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.tryParse(entry.value.text) ?? DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        final isoDate = pickedDate.toUtc().toIso8601String(); // Convert to UTC ISO 8601
                        entry.value.text = isoDate;

                      }

                    }
                        : null,
                    child: AbsorbPointer(
                      absorbing: isDOBField,
                      child: TextField(
                        controller: entry.value,
                        focusNode: focusNode,
                        readOnly: isDOBField,
                        textInputAction:
                        currentIndex < keys.length - 1 ? TextInputAction.next : TextInputAction.done,
                        onSubmitted: (_) {
                          if (currentIndex < keys.length - 1) {
                            final nextKey = keys[currentIndex + 1];
                            controller.focusNodes[nextKey]?.requestFocus();
                          } else {
                            FocusScope.of(context).unfocus();
                          }
                        },
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
                              ? Icon(Icons.calendar_today, size: 20, color: Colors.grey)
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
                        onPressed:
                            controller.updateLoading.value ||
                                controller.nameText.value.isEmpty
                            ? null
                            : () => controller.saveMemberData(newMember==true?null:member!),
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
                                children: [
                                  // const Icon(Icons.save),
                                  const SizedBox(width: 8),
                                  Text(newMember == true ? "Save" : "Update"),
                                ],
                              ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller.resetFields(newMember!); // Reset fields
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
              if(newMember==false)
              PopupMenuButton<String>(
                color: Colors.white,
                onSelected: (value) async {
                  final String? memberId = member?.pID.toString();

                  if (value == 'Transfer') {
                    String? newResID = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        final TextEditingController resIdController =
                            TextEditingController();
                        return AlertDialog(
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          title: const Text('Enter New ResID'),
                          content: TextField(
                            controller: resIdController,

                            decoration: const InputDecoration(
                              hintText: 'Enter ResID',
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context), // Cancel
                              child: const Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  resIdController.text.toUpperCase().trim(),
                                );
                              },
                              child: const Text('Transfer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (newResID != null && newResID.isNotEmpty) {
                      String url =
                          'https://tras.nurac.com/api/member/$memberId/$newResID';
                      controller.performGetRequest(url);
                    }
                  } else if (value == 'Delete') {
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                          'Are you sure you want to delete this member?',
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                            ),
                            onPressed: () =>
                                Navigator.pop(context, false), // Cancel
                            child: const Text('   No   '),
                          ),

                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pop(context, true), // Confirm
                            child: const Text('   Yes   '),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      String url =
                          'https://tras.nurac.com/api/member/delete/$memberId';
                      controller.performGetRequest(url);
                    }
                  }
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
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: controller.downloadLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
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
            ],
          ),
        ),
      ),
    );
  }
}
