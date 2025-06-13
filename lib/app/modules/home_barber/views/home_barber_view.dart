import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_barber_controller.dart';

class HomeBarberView extends GetView<HomeBarberController> {
  const HomeBarberView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Anda'), centerTitle: true),
      body: Obx(() {
        if (controller.bookings.isEmpty) {
          return const Center(child: Text("Belum ada jadwal."));
        }

        return ListView.builder(
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];

            return Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text("Tanggal: ${booking.bookingDate}"),
                subtitle: Text(
                  "Jam: ${booking.bookingTime}\nStatus: ${booking.status}",
                ),
                trailing:
                    booking.status == 'menunggu'
                        ? ElevatedButton(
                          onPressed: () => controller.markAsServed(booking),
                          child: const Text("Tandai Dilayani"),
                        )
                        : const Icon(Icons.check_circle, color: Colors.green),
              ),
            );
          },
        );
      }),
    );
  }
}
