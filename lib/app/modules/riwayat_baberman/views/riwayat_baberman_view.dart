import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_card.dart';
import 'package:lookism_hairstudio_booking/app/modules/riwayat_baberman/controllers/riwayat_baberman_controller.dart';

class RiwayatBabermanView extends StatelessWidget {
  RiwayatBabermanView({super.key});

  final RiwayatBabermanController controller = Get.put(
    RiwayatBabermanController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Selesai'),
        backgroundColor: Colors.green,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookings = controller.completedBookings;

        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchCompletedBookings();
          },
          child:
              bookings.isEmpty
                  ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(child: CircularProgressIndicator()),
                    ],
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return BookingCard(booking: booking, onComplete: null);
                    },
                  ),
        );
      }),
    );
  }
}
