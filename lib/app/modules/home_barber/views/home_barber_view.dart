import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_barber_controller.dart';

class HomeBarberView extends GetView<HomeBarberController> {
  const HomeBarberView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<HomeBarberController>(() => HomeBarberController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Anda'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (controller.bookings.isEmpty) {
          return const Center(child: Text("Belum ada jadwal."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Tanggal: ${booking.bookingDate}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        Text("Jam: ${booking.bookingTime}"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Status: ${booking.status}",
                          style: TextStyle(
                            color:
                                booking.status == 'menunggu'
                                    ? Colors.orange
                                    : Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (booking.status == 'menunggu')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => controller.markAsServed(booking),
                          icon: const Icon(Icons.check),
                          label: const Text(
                            "Tandai Dilayani",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      )
                    else
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 28,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
