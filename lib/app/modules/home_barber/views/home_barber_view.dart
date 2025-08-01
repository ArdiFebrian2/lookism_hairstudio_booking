import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_barber_controller.dart';
import '../widgets/booking_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_booking_widget.dart';

class HomeBarberView extends StatelessWidget {
  const HomeBarberView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeBarberController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody(controller)),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Booking Masuk',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      shadowColor: Colors.black12,
    );
  }

  Widget _buildBody(HomeBarberController controller) {
    if (controller.isLoading.value) {
      return const LoadingWidget();
    }

    if (controller.bookings.isEmpty) {
      return const EmptyBookingWidget();
    }

    return RefreshIndicator(
      onRefresh: () async => controller.fetchBookings(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.bookings.length,
        itemBuilder: (context, index) {
          final booking = controller.bookings[index];
          return BookingCard(
            booking: booking,
            onAccept:
                () => controller.updateBookingStatus(booking['id'], 'accepted'),
            onReject:
                () => controller.updateBookingStatus(booking['id'], 'rejected'),
            onComplete:
                () => controller.updateBookingStatus(booking['id'], 'selesai'),
          );
        },
      ),
    );
  }
}
