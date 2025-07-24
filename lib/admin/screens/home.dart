import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../user/screens/directory.dart';
import '../controlllers/auth_controller.dart';
import '../controlllers/details_controller.dart';
import '../controlllers/home_controller.dart';
import 'details_screen.dart';

class HomePage extends StatelessWidget {
  final homeController = Get.put(HomeController());
  final authController = Get.put(AuthController());
  final ScrollController scrollController = ScrollController();

  HomePage({super.key}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          homeController.hasMore.value &&
          !homeController.isLoading.value &&
          !homeController.isBirthdayView.value) {
        homeController.loadMore();
      }
    });
  }

  Future<String?> _getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userType');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userType = snapshot.data;

        return WillPopScope(
          onWillPop: () async {
            bool shouldClose = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Exit App'),
                content: const Text('Are you sure you want to close the app?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );
            return shouldClose;
          },
          child: userType == "User"
              ?  Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              leadingWidth: 25,
              backgroundColor: const Color(0XFF383c44),
              title: Hero(
                tag: "",
                child: Image.asset("assets/images/logo-white.png", height: 30),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    authController.logout();
                  },

                  icon: const Text(
                    "Logout  ",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final resId = prefs.getInt('resID');
                      Get.to(
                            () => DetailsScreen(PID: resId, newMember: false),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 300),
                      );

                      Get.put(DetailsController()).fetchDetails(resId ?? 0);
                    },
                    child: Container(
                      width: double.infinity,
                      color: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                      child: Text(
                        "FAMILY DETAILS",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () async {
                       homeController.fetchDirectory();

                     await Get.to(
                            () => DirectoryScreen(),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 300),
                      );

                    },
                    child: Container(
                      width: double.infinity,
                      color: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                      child: Text(
                        "DIRECTORY",
                        style: TextStyle(color: Colors.black, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          )
              : Scaffold(
                  drawer: _buildDrawer(context),
                  appBar: AppBar(
                    scrolledUnderElevation: 0,
                    leadingWidth: 25,
                    backgroundColor: const Color(0XFF383c44),
                    title: Hero(
                      tag: "",
                      child: Image.asset(
                        "assets/images/logo-white.png",
                        height: 30,
                      ),
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
                  body: Column(
                    children: [
                      _buildSearchBar(),
                      Expanded(child: _buildMemberList()),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 90,
            color: const Color(0XFF383c44),
            alignment: Alignment.center,
            child: Image.asset("assets/images/logo-white.png", height: 30),
          ),
          _buildDrawerItem('Home', () {
            homeController.isBirthdayView.value = false;
            Get.back();
          }),
          _buildDrawerItem('Birthday Reminder', () async {
            Get.back();
            homeController.isBirthdayView.value = true;
            await homeController.fetchBirthdayData();
          }),
          _buildDrawerItem('Logout', authController.logout),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
          onTap: onTap,
          selectedColor: Colors.orange,
          focusColor: Colors.orange,
        ),
        Divider(color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: TextField(
              controller:homeController.searchController ,
              cursorColor: Colors.black,
              onChanged: (value) {
                if (homeController.isBirthdayView.value) {
                  homeController.searchBirthdays(value);
                } else {
                  homeController.search(value);
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search Text',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.zero,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.zero,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await Get.delete<DetailsController>();
            Get.to(
              DetailsScreen(newMember: true),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 300),
            );
          },
          child: Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Text(
              "New Family",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberList() {
    return Obx(() {
      return homeController.isBirthdayView.value
          ? _buildBirthdayList()
          : _buildFamilyList();
    });
  }

  Widget _buildFamilyList() {
    final members = homeController.displayedMembers;

    if (homeController.isLoading.value && members.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0XFF383c44)),
      );
    }

    if (members.isEmpty) {
      return RefreshIndicator(
        color: const Color(0XFF383c44),
        onRefresh: () => homeController.fetchHomeData(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(
              height: 300,
              child: Center(child: Text("No members found")),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0XFF383c44),
      onRefresh: () => homeController.fetchHomeData(),
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: members.length + (homeController.hasMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == members.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: Color(0XFF383c44)),
              ),
            );
          }

          final m = members[index];
          return GestureDetector(
            onTap: () {
              Get.to(
                () => DetailsScreen(PID: m.pID, newMember: false),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: 300),
              );

              Get.put(DetailsController()).fetchDetails(m.resID ?? 0);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMemberImage(m.photo),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${m.code ?? ""}: ${m.name ?? "No name"}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.address1?.replaceAll('\n', ', ') ?? '',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Last Updated: ${m.aDate.toString()}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBirthdayList() {
    final birthdays = homeController.displayedBirthdays;

    if (homeController.isBirthdayLoading.value && birthdays.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0XFF383c44)),
      );
    }

    if (birthdays.isEmpty) {
      return RefreshIndicator(
        color: const Color(0XFF383c44),
        onRefresh: () => homeController.fetchBirthdayData(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(
              height: 300,
              child: Center(child: Text("No birthdays found")),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0XFF383c44),
      onRefresh: () => homeController.fetchBirthdayData(),
      child: Obx(() {
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount:
              birthdays.length +
              (homeController.hasMoreBirthdays.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == birthdays.length) {
              // Trigger load more when reaching the end
              if (homeController.hasMoreBirthdays.value &&
                  !homeController.isBirthdayLoading.value) {
                homeController.loadMoreBirthdays();
              }
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0XFF383c44)),
                ),
              );
            }

            final b = birthdays[index];
            return Obx(() {
              final isLoading =
                  homeController.downloadLoadingPID.value == b.pID.toString();
              return GestureDetector(
                onTap: isLoading
                    ? () {}
                    : () {
                        homeController.downloadPDF(
                          "https://tras.nurac.com/api/birthday/download/${b.pID}",
                          b.pID.toString(),
                        );
                      },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMemberImage(b.photo),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${b.code ?? ""}: ${b.name ?? "No name"}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  b.address1?.replaceAll('\n', ', ') ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "DOB: ${b.dob != null ? b.dob!.split('T').first : 'N/A'}",
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isLoading) Text("Downloading..."),
                    ],
                  ),
                ),
              );
            });
          },
        );
      }),
    );
  }

  Widget _buildMemberImage(String? photo) {
    final imageUrl = 'https://tras.nurac.com/img/Uploads/$photo';
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: photo != null && photo.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => _placeholderImage(),
              errorWidget: (context, url, error) => _placeholderImage(),
            )
          : _placeholderImage(),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[300],
      child: const Icon(Icons.person, color: Colors.white),
    );
  }
}
