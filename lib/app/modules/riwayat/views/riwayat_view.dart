// riwayat_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayat_controller.dart';
import '../widgets/riwayat_app_bar.dart';
import '../widgets/riwayat_empty_state.dart';
import '../widgets/riwayat_loading_state.dart';
import '../widgets/riwayat_booking_list.dart';

class RiwayatView extends StatelessWidget {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RiwayatController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurpleAccent, // Indigo
              Color(0xFF8B5CF6), // Purple
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const RiwayatAppBar(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _buildBody(controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(RiwayatController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const RiwayatLoadingState();
      }

      return RefreshIndicator(
        onRefresh: () async {
          controller.fetchBookings();
        },
        child:
            controller.bookings.isEmpty
                ? const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: RiwayatEmptyState(),
                )
                : RiwayatBookingList(bookings: controller.bookings),
      );
    });
  }
}
