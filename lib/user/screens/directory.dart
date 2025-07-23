import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../admin/controlllers/details_controller.dart';
import '../../admin/controlllers/home_controller.dart';
import '../../admin/screens/details_screen.dart';

class DirectoryScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final ScrollController scrollController = ScrollController();

  DirectoryScreen({super.key}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          homeController.hasMore.value &&
          !homeController.directoryLoading.value) {
        homeController.fetchDirectory(); // Load more
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Directory"),
        backgroundColor: const Color(0xFF383C44),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: Obx(() => _buildFamilyList())),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyList() {
    final members = homeController.directoryMembers;

    if (homeController.directoryLoading.value && members.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0XFF383c44)),
      );
    }

    if (members.isEmpty) {
      return RefreshIndicator(
        color: const Color(0XFF383c44),
        onRefresh: () => homeController.fetchDirectory(),
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
      onRefresh: () => homeController.fetchDirectory(),
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
              Get.dialog(
                AlertDialog(
                  title: Text(
                    m.name ?? "Not available",
                    style: TextStyle(fontSize: 18,color: Colors.blue,fontWeight: FontWeight.w500),
                  ),
                  alignment: Alignment.center,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: m.photo != null && m.photo!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl:
                                      'https://tras.nurac.com/img/Uploads/${m.photo}',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      _placeholderImage(),
                                  errorWidget: (context, url, error) =>
                                      _placeholderImage(),
                                )
                              : _placeholderImage(),
                        ),
                      ),

                      const SizedBox(height: 8),
                      _infoRow("", m.address1?.replaceAll('\n', ', ') ?? ''),
                      const SizedBox(height: 8),
                      _infoRow("Phone:", m.phone1 ?? "Not available"),
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.pink, // 🔁 Replace with your color
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
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
                          m.mobile ?? 'Not Given',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
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

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Expanded(child: Text(value, style: TextStyle(fontSize: 14))),
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
              cursorColor: Colors.black,
              onChanged: homeController.filterMembers,
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
      ],
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
