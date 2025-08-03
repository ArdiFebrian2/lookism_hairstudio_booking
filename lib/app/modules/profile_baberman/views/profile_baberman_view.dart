// lib/app/modules/profile_baberman/views/profile_baberman_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_baberman_controller.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_logout_button.dart';

class ProfileBabermanView extends GetView<ProfileBabermanController> {
  const ProfileBabermanView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileBabermanController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody()),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Profil Baberman',
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF6366F1),
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
        ),
      );
    }

    final user = controller.userData;
    if (user.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ProfileHeader(userData: user),
          ProfileInfoSection(userData: user),
          const ProfileLogoutButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Data pengguna tidak ditemukan",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Silakan coba lagi nanti",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
