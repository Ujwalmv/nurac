import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../constants/api_const.dart';
import '../model/home_model.dart';
import '../model/birthday_model.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  HomeModel? homeModel;

  RxBool isBirthdayView = false.obs;

  // For members
  var displayedMembers = <Family>[].obs;
  var searchQuery = ''.obs;
  var hasMore = true.obs;
  var pageSize = 25;

  // For birthdays
  var birthdayList = <BirthdayModel>[].obs;
  var displayedBirthdays = <BirthdayModel>[].obs;
  var birthdaySearchQuery = ''.obs;
  var hasMoreBirthdays = true.obs;
  var isBirthdayLoading = false.obs;

  final int associationId = 1; // Optional: make it dynamic from SharedPreferences later

  @override
  void onInit() {
    fetchHomeData();
    super.onInit();
  }

  // Fetch Home Members
  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      final url = Uri.parse(ApiConstants.members(associationId));
      final response = await http.get(url);
      log("Home Data: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        homeModel = HomeModel.fromJson(jsonData);

        if (homeModel?.family != null && homeModel!.family!.isNotEmpty) {
          displayedMembers.value = homeModel!.family!.take(pageSize).toList();
          hasMore.value = homeModel!.family!.length > pageSize;
        } else {
          displayedMembers.clear();
          hasMore.value = false;
        }
      } else {
        Get.snackbar("Error", "Failed to load data");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch Birthdays
  Future<void> fetchBirthdayData() async {
    isBirthdayLoading.value = true;
    try {
      final url = Uri.parse(ApiConstants.birthdays(associationId));
      final response = await http.get(url);
      log("Birthday Data: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        birthdayList.value =
            jsonList.map((e) => BirthdayModel.fromJson(e)).toList();

        displayedBirthdays.value = birthdayList.take(pageSize).toList();
        hasMoreBirthdays.value = birthdayList.length > pageSize;
      } else {
        Get.snackbar("Error", "Failed to load birthdays");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isBirthdayLoading.value = false;
    }
  }

  // Search Members
  void search(String query) {
    searchQuery.value = query.toLowerCase();

    final filtered = (homeModel?.family ?? []).where((m) {
      final name = m.name?.toLowerCase() ?? '';
      final resId = m.resID?.toString() ?? '';
      final code = m.code?.toString() ?? '';
      return name.contains(searchQuery.value) || resId.contains(searchQuery.value)||code.contains(searchQuery.value);
    }).toList();

    displayedMembers.value = filtered.take(pageSize).toList();
    hasMore.value = filtered.length > pageSize;
  }



  // Load More Members
  void loadMore() {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;
    Future.delayed(Duration(milliseconds: 300), () {
      final filtered = (homeModel?.family ?? []).where((m) {
        return m.name?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false;
      }).toList();

      final nextItems = filtered.skip(displayedMembers.length).take(pageSize).toList();

      if (nextItems.isEmpty) {
        hasMore.value = false;
      } else {
        displayedMembers.addAll(nextItems);
      }

      isLoading.value = false;
    });
  }

  // Search Birthdays
  void searchBirthdays(String query) {
    birthdaySearchQuery.value = query;

    final filtered = birthdayList.where((b) {
      final name = b.name?.toLowerCase() ?? '';
      final resId = b.resID?.toString() ?? '';
      final code = b.code?.toString() ?? '';
      return name.contains(query.toLowerCase()) ||
          resId.contains(query) ||
          code.contains(query);
    }).toList();

    displayedBirthdays.value = filtered.take(pageSize).toList();
    hasMoreBirthdays.value = filtered.length > pageSize;
  }


  // Load More Birthdays
  void loadMoreBirthdays() {
    if (isBirthdayLoading.value || !hasMoreBirthdays.value) return;

    isBirthdayLoading.value = true;
    Future.delayed(Duration(milliseconds: 300), () {
      final filtered = birthdayList.where((b) {
        return b.name
            ?.toLowerCase()
            .contains(birthdaySearchQuery.value.toLowerCase()) ??
            false;
      }).toList();

      final nextItems = filtered.skip(displayedBirthdays.length).take(pageSize).toList();

      if (nextItems.isEmpty) {
        hasMoreBirthdays.value = false;
      } else {
        displayedBirthdays.addAll(nextItems);
      }

      isBirthdayLoading.value = false;
    });
  }


  var downloadLoadingPID = ''.obs;
  Future<void> downloadPDF(String url,String pID) async {
    try {
      downloadLoadingPID.value = pID;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final path =
            '${directory!.path}/downloaded_file_${DateTime.now().millisecondsSinceEpoch}.jpeg';
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
      downloadLoadingPID.value = "";
    }
  }

}
