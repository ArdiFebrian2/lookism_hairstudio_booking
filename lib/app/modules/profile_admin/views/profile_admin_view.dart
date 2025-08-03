import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_admin_controller.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_info_card_widget.dart';
import '../widgets/admin_actions_widget.dart';
import '../widgets/logout_button_widget.dart';

class ProfileAdminView extends GetView<ProfileAdminController> {
  const ProfileAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileAdminController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const ProfileHeaderWidget(),
                const SizedBox(height: 30),
                const ProfileInfoCardWidget(),
                const SizedBox(height: 25),
                // const AdminActionsWidget(),
                const SizedBox(height: 40),
                LogoutButtonWidget(onPressed: controller.logout),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Profil Administrator',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF3F51B5),
      foregroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
          ),
        ),
      ),
    );
  }
}
