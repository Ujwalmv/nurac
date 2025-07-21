import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/api_const.dart';
import '../controlllers/auth_controller.dart';
import '../controlllers/details_controller.dart';
import 'home.dart';
import 'member_edit_screen.dart';

class DetailsScreen extends StatelessWidget {
  final int? PID;
  final bool newMember;

  DetailsScreen({super.key, this.PID, required this.newMember});
  final DetailsController controller = Get.put(DetailsController());
  final authController = Get.find<AuthController>();

  final Color darkColor = const Color(0xFF383C44);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => HomePage(), transition: Transition.leftToRight,
          duration: Duration(milliseconds: 300),); // Back button (Android)
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leadingWidth: 25,
          backgroundColor: darkColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.to(() => HomePage(), transition: Transition.leftToRight,
                duration: Duration(milliseconds: 300),); // AppBar back button
            },
          ),
          title: Hero(
            tag: "",
            child: Image.asset("assets/images/logo-white.png", height: 30),
          ),
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
            return Center(child: CircularProgressIndicator(color: Colors.grey));
          }
          final data = controller.detailsModel.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _labelValue("Res.ID : ", data.code ?? ''),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: controller.addressController,
                  label: "Address",
                  maxLines: 4,
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: controller.phone1Controller,
                  label: "Phone Number",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: controller.phone2Controller,
                  label: "Phone Number",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),

                Column(
                  children: [
                    _buildButton(
                      loading: controller.updateLoading.value,
                      label: newMember == true ? "Save" : "Update",
                      color: Colors.green,
                      onPressed: () => controller.updateDetails(newMember),
                    ),
                    _buildButton(
                      loading: controller.isLoading.value,
                      label: "Reset",
                      color: Colors.orange,
                      onPressed: newMember == true
                          ? () {
                              controller.addressController.clear();
                              controller.phone1Controller.clear();
                              controller.phone2Controller.clear();
                            }
                          : () => controller.fetchDetails(data.resID!),
                    ),
                    if (newMember == false)
                      _buildButton(
                        label: 'Show Access for ResID ${data.code ?? ""}',
                        color: Colors.cyan,
                        loading: controller.whatsAppLoading.value,
                        onPressed: () =>
                            controller.openWhatsappWithAccessMessage(
                              // controller.detailsModel.value.associationID!,
                              10,
                              PID ?? 0,
                            ),
                      ),
                    if (newMember == false)
                      PopupMenuButton<String>(
                        color: Colors.white,
                        onSelected: (value) {
                          String url = '';
                          if (value == 'summary') {
                            url =
                                '${ApiConstants.baseUrl}/address/download/${data.resID ?? 0}';
                          } else if (value == 'details') {
                            url =
                                '${ApiConstants.baseUrl}/members/download/${data.resID ?? 0}';
                          } else if (value == 'blank') {
                            url = '${ApiConstants.baseUrl}/blank/download';
                          }
                          if (url.isNotEmpty) {
                            controller.downloadPDF(url);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'summary',
                            child: Text('Summary'),
                          ),
                          const PopupMenuItem(
                            value: 'details',
                            child: Text('Details'),
                          ),
                          const PopupMenuItem(
                            value: 'blank',
                            child: Text('Blank'),
                          ),
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
                                    "Download ▼",
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
                const Divider(),

                Container(
                  height: 40,
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: darkColor.withOpacity(.7),
                  child: const Text(
                    "FAMILY MEMBERS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),

                ...?controller.detailsModel.value.details?.map(
                  (member) => GestureDetector(
                    onTap: () {
                      controller.initializeFields(member);
                      Get.to(
                        () => EditMemberScreen(
                          member: member,
                          resID: controller.detailsModel.value.code ?? "",
                          newMember: false,
                        ),
                        transition: Transition.downToUp,
                        duration: Duration(milliseconds: 300),
                      );
                    },
                    child: _buildFamilyCard(member.name, member.relation),
                  ),
                ),
                const SizedBox(height: 10),

                if (newMember == false)
                  _buildButton(
                    label: 'New Member',
                    color: Colors.blue,
                    onPressed: () {
                      controller.onClear();

                      Get.to(
                        () => EditMemberScreen(
                          newMember: true,
                          resID: controller.detailsModel.value.code ?? "",
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _labelValue(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(4),
      color: darkColor.withOpacity(.7),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      cursorColor: darkColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: darkColor),
        border: OutlineInputBorder(borderSide: BorderSide(color: darkColor)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: darkColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: darkColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildButton({
    bool? loading,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading == true ? () {} : onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: color),
        child: loading == true
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2, // thinner ring
                ),
              )
            : Text(label),
      ),
    );
  }

  Widget _buildFamilyCard(String? name, String? relation) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(width: .5),
        gradient: const LinearGradient(
          colors: [Color(0xFF383C44), Color(0xFF53575F)],
        ),
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: Colors.white,
        child: Text(
          "${name ?? ''}${relation == null ? "" : "(${relation ?? ''})"} ",
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
