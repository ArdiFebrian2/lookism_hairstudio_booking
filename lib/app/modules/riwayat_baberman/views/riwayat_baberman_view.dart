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
        final bookings = controller.completedBookings;

        if (bookings.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada booking yang selesai.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];

            return BookingCard(
              booking: booking,
              onComplete: null, // ✅ Sudah selesai
            );
          },
        );
      }),
    );
  }
}
