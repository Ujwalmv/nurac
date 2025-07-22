import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/api_const.dart';
import '../model/details_model.dart';
import '../screens/details_screen.dart';
import '../screens/home.dart';
import 'home_controller.dart';

class DetailsController extends GetxController {
  Map<String, FocusNode> focusNodes = {};
  var selectedImage = Rxn<File>(); // Store the picked image
  Details? _originalMember;
  // Text controllers for all fields
  final addressController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();
  final nameController = TextEditingController();
  final relationController = TextEditingController();
  final sexController = TextEditingController();
  final dobController = TextEditingController();
  final professionController = TextEditingController();
  final qualificationController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final memNOController = TextEditingController();
  final membershipController = TextEditingController();
  final livingStatusController = TextEditingController( text: "LIVE");
  final benameController = TextEditingController();
  final fnameController = TextEditingController();
  final mnameController = TextEditingController();
  final statusController = TextEditingController();
  final birthplaceController = TextEditingController();
  final birthstarController = TextEditingController();
  final bloodgroupController = TextEditingController();
  final childrenController = TextEditingController();
  final nativeplaceController = TextEditingController();
  final pofficeController = TextEditingController();
  final subcasteController = TextEditingController();
  final subsectorController = TextEditingController();

  Map<String, TextEditingController> get controllers => {
    'Name': nameController,
    'Sex': sexController,
    'Date of Birth': dobController,
    'Relation': relationController,
    'Profession': professionController,
    'Qualification': qualificationController,
    'Email': emailController,
    'Mobile': mobileController,
    "Mem.NO": memNOController,
    "Membership": membershipController,
    'Living Status': livingStatusController,
    'Spouse Name': benameController,
    'Father\'s Name': fnameController,
    'Mother\'s Name': mnameController,
    'Marital Status': statusController,
    'Birthplace': birthplaceController,
    'Birthstar': birthstarController,
    'Blood Group': bloodgroupController,
    'Children': childrenController,
    'Native Place': nativeplaceController,
    'Post Office': pofficeController,
    'Subcaste': subcasteController,
    'Subsector': subsectorController,
  };

  // Reset fields to original member data
  void resetFields(bool newMember) {
    if (_originalMember != null) {
      initializeFields(_originalMember!); // Reinitialize with original data
      selectedImage.value = null; // Clear selected image
    }
   if(newMember==true)onClear();
  }

  // Initialize fields with member data
  void initializeFields(Details member) {
    _originalMember = member;
    nameController.text = member.name ?? '';
    relationController.text = member.relation ?? '';
    sexController.text = member.sex ?? '';
    if (member.dob != null && member.dob!.isNotEmpty) {
      DateTime? parsedDob = DateTime.tryParse(member.dob!);
      if (parsedDob != null) {
        dobController.text =
            "${parsedDob.day.toString().padLeft(2, '0')}-${parsedDob.month.toString().padLeft(2, '0')}-${parsedDob.year}";
      } else {
        dobController.text = '';
      }
    } else {
      dobController.text = '';
    }

    professionController.text = member.profession ?? '';
    qualificationController.text = member.qualification ?? '';
    emailController.text = member.email ?? '';
    mobileController.text = member.mobile ?? '';
    memNOController.text = "";
    memNOController.text = "";
    livingStatusController.text = member.livingstatus ?? '';
    benameController.text = member.bename ?? '';
    fnameController.text = member.fname ?? '';
    mnameController.text = member.mname ?? '';
    statusController.text = member.status ?? '';
    birthplaceController.text = member.birthplace ?? '';
    birthstarController.text = member.birthstar ?? '';
    bloodgroupController.text = member.bloodgroup ?? '';
    childrenController.text = member.children ?? '';
    nativeplaceController.text = member.nativeplace ?? '';
    pofficeController.text = member.poffice ?? '';
    subcasteController.text = member.subcaste ?? '';
    subsectorController.text = member.subsector ?? '';
  }

  // Method to set member data when navigating to EditMemberScreen
  void setMember(Details member) {
    initializeFields(member);
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Color(0xFF383C44),
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
            initAspectRatio: CropAspectRatioPreset.original,
            hideBottomControls: false,
          ),
          IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: false),
        ],
      );

      if (croppedFile != null) {
        selectedImage.value = File(croppedFile.path);
      }
    }
  }

  Future<String?> convertImageToBase64DataUri(File imageFile) async {
    try {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        quality: 60,
      );

      if (compressedBytes == null) return null;

      final base64String = base64Encode(compressedBytes);

      String mimeType = 'image/jpeg';
      String ext = imageFile.path.split('.').last.toLowerCase();
      if (ext == 'png') mimeType = 'image/png';

      return 'data:$mimeType;base64,$base64String';
    } catch (e) {
      print('Error compressing/converting image: $e');
      return null;
    }
  }

  // Remove null or empty values from map
  Map<String, dynamic> cleanPayload(Map<String, dynamic> map) {
    map.removeWhere(
      (key, value) => value == null || value.toString().trim().isEmpty,
    );
    return map;
  }

  // Save member data with optional image upload
  Future<void> saveMemberData(Details? member) async {
    try {
      Future.delayed(const Duration(milliseconds: 200), () {
        updateLoading.value = true;
      });

      String? imageDataUri;
      if (selectedImage.value != null) {
        imageDataUri = await convertImageToBase64DataUri(selectedImage.value!);
      }

      final uri = member == null
          ? Uri.parse('https://tras.nurac.com/api/member')
          : Uri.parse('https://tras.nurac.com/api/member/${member?.pID ?? ""}');

      final payload = {
        "Membership": {
          "MembershipNo": memNOController.text.toUpperCase(),
          "MembershipType": membershipController.text.toUpperCase(),
        },

        "Detail": {
          "PID": member?.pID??"",
          "ResID": detailsModel.value.resID,
          "name": nameController.text.toUpperCase(),
          "relation": relationController.text.toUpperCase(),
          "sex": sexController.text.toUpperCase(),
          "dob": dobController.text.isEmpty
              ? null
              : dobController.text.toUpperCase(),
          "profession": professionController.text.toUpperCase(),
          "qualification": qualificationController.text.toUpperCase(),
          "email": emailController.text,
          "mobile": mobileController.text.toUpperCase(),
          "Membership": membershipController.text.toUpperCase(),
          "livingstatus": livingStatusController.text.toUpperCase(),
          "bename": benameController.text.toUpperCase(),
          "fname": fnameController.text.toUpperCase(),
          "mname": mnameController.text.toUpperCase(),
          "status": statusController.text.toUpperCase(),
          "birthplace": birthplaceController.text.toUpperCase(),
          "birthstar": birthstarController.text.toUpperCase(),
          "bloodgroup": bloodgroupController.text.toUpperCase(),
          "children": childrenController.text.toUpperCase(),
          "nativeplace": nativeplaceController.text.toUpperCase(),
          "poffice": pofficeController.text.toUpperCase(),
          "subcaste": subcasteController.text.toUpperCase(),
          "subsector": subsectorController.text.toUpperCase(),
        },
        "Photo": {"PID": member?.pID ?? "", "ImagePath": imageDataUri ?? ""},
      };

      final response = member == null
          ? await http.post(
              uri,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(payload),
            )
          : await http.put(
              uri,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(payload),
            );
      print(payload);

      if (response.statusCode == 200) {
        selectedImage.value = null;
        Get.snackbar("Success", "Details updated successfully");

        fetchDetails(detailsModel.value.resID ?? 0);
        Get.to(DetailsScreen(newMember: false), transition: Transition.downToUp,
          duration: Duration(milliseconds: 300),);
      } else {
        Get.snackbar("Error", "Update failed: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      updateLoading.value = false;
    }
  }

  var isLoading = false.obs;
  var updateLoading = false.obs;
  var whatsAppLoading = false.obs;
  var downloadLoading = false.obs;
  var detailsModel = DetailsModel().obs;

  Future<void> fetchDetails(int id) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(ApiConstants.residentDetails(id.toString())),
      );
      log(response.body);
      if (response.statusCode == 200) {
        final model = DetailsModel.fromJson(json.decode(response.body));
        detailsModel.value = model;

        // Fill text fields with values
        addressController.text = model.address1 ?? '';
        phone1Controller.text = model.phone1 ?? '';
        phone2Controller.text = model.phone2 ?? '';
      } else {
        Get.snackbar("Error", "Failed to load data");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDetails(bool newMember) async {
    final body = newMember == true
        ? {
            "Address1": addressController.text,
            "AssociationID": detailsModel.value.associationID ?? 1,
            "Phone1": phone1Controller.text,
            "Phone2": phone2Controller.text,
          }
        : {
            "Address1": addressController.text,
            "AssociationID": detailsModel.value.associationID,
            "Code": detailsModel.value.code ?? "",
            "Phone1": phone1Controller.text,
            "Phone2": phone2Controller.text,
            "ResID": detailsModel.value.resID ?? "",
          };

    try {
      updateLoading.value = true;
      final response = newMember == true
          ? await http.post(
              Uri.parse(ApiConstants.residentDetails("")),
              headers: {"Content-Type": "application/json"},
              body: json.encode(body),
            )
          : await http.put(
              Uri.parse(
                ApiConstants.residentDetails(
                  detailsModel.value.resID.toString(),
                ),
              ),
              headers: {"Content-Type": "application/json"},
              body: json.encode(body),
            );

      if (response.statusCode == 200) {
        await Get.find<HomeController>().fetchHomeData();
        updateLoading.value = false;
        await Get.snackbar("Success", "Details updated successfully");
        await Get.off(HomePage());
      } else {
        Get.snackbar("Error", "Update failed");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      updateLoading.value = false;
    }
  }

  /// 🔗 Open WhatsApp with access message from API
  Future<void> openWhatsappWithAccessMessage(
    int associationId,
    int resId,
  ) async {
    try {
      whatsAppLoading.value = true;
      final response = await http.get(
        Uri.parse(
          'https://tras.nurac.com/api/create/user/get/$associationId/$resId',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final name = data['Name'] ?? '';
        final username = data['Username'] ?? '';
        final password = data['Password'] ?? '';
        final url = data['URL'] ?? '';

        final message = Uri.encodeComponent(
          "Hello $name, your login details:\n"
          "🔹 Username: $username\n"
          "🔹 Password: $password\n"
          "🔹 Login Link: $url",
        );

        String? phone = phone1Controller.text.trim().isNotEmpty
            ? phone1Controller.text.trim()
            : phone2Controller.text.trim();

        if (phone.isNotEmpty) {
          phone = phone.replaceAll(RegExp(r'[^\d]'), '');
          if (phone.startsWith('91')) phone = phone.substring(2);
          if (phone.startsWith('0')) phone = phone.substring(1);

          try {
            await launchUrl(
              Uri.parse("whatsapp://send?phone=91$phone&text=$message"),
              mode: LaunchMode.externalApplication,
            );
          } catch (e) {
            await launchUrl(
              Uri.parse("https://wa.me/91$phone?text=$message"),
              mode: LaunchMode.externalApplication,
            );
          }
        } else {
          Get.snackbar("Error", "No phone number found");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed: ${e.toString()}");
    } finally {
      whatsAppLoading.value = false;
    }
  }

  Future<void> downloadPDF(String url) async {
    try {
      downloadLoading.value = true;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final path =
            '${directory!.path}/downloaded_file_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        Get.snackbar('Success', 'File downloaded to $path');
        OpenFile.open(file.path); // Optional: opens the PDF after downloading
      } else {
        Get.snackbar('Error', 'Failed to download file');
      }
    } catch (e) {
      Get.snackbar('Error', 'Download failed: $e');
    } finally {
      downloadLoading.value = false;
    }
  }

  RxString nameText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      nameText.value = nameController.text;
    });
    controllers.forEach((key, _) {
      focusNodes[key] = FocusNode();
    });
  }

  @override
  void onClose() {
    // controllers.forEach((key, ctrl) => ctrl.dispose());
    focusNodes.forEach((key, node) => node.dispose());
    // Dispose controllers
    addressController.dispose();
    phone1Controller.dispose();
    phone2Controller.dispose();
    nameController.dispose();
    relationController.dispose();
    sexController.dispose();
    dobController.dispose();
    professionController.dispose();
    qualificationController.dispose();
    emailController.dispose();
    mobileController.dispose();
    livingStatusController.dispose();
    benameController.dispose();
    fnameController.dispose();
    mnameController.dispose();
    statusController.dispose();
    birthplaceController.dispose();
    birthstarController.dispose();
    bloodgroupController.dispose();
    childrenController.dispose();
    nativeplaceController.dispose();
    pofficeController.dispose();
    subcasteController.dispose();
    subsectorController.dispose();
    super.onClose();
  }

  void onClear() {
    memNOController.clear();
    membershipController.clear();
    nameController.clear();
    relationController.clear();
    sexController.clear();
    dobController.clear();
    professionController.clear();
    qualificationController.clear();
    emailController.clear();
    mobileController.clear();
    livingStatusController.clear();
    benameController.clear();
    fnameController.clear();
    mnameController.clear();
    statusController.clear();
    birthplaceController.clear();
    birthstarController.clear();
    bloodgroupController.clear();
    childrenController.clear();
    nativeplaceController.clear();
    pofficeController.clear();
    subcasteController.clear();
    subsectorController.clear();
  }

  void performGetRequest(String url) async {
    try {
      downloadLoading.value = true;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await Get.find<HomeController>().fetchHomeData();
        await fetchDetails(detailsModel.value.resID ?? 0);
        downloadLoading.value = false;
        Get.snackbar('Success', 'Operation successful');
        await Get.off(DetailsScreen(newMember: false));
      } else {
        Get.snackbar('Error', 'Failed: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      downloadLoading.value = false;
    }
  }
}
