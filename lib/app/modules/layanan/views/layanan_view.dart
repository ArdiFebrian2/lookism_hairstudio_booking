import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/layanan_controller.dart';

class LayananView extends GetView<LayananController> {
  const LayananView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LayananController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Layanan'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.layananList.isEmpty) {
          return const Center(child: Text("Belum ada layanan tersedia"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.layananList.length,
          itemBuilder: (context, index) {
            final layanan = controller.layananList[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      layanan['nama'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      layanan['deskripsi'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${layanan['harga']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // navigasi ke halaman booking
                            Get.snackbar(
                              "Booking",

                              "Layanan ${layanan['nama']} dipilih",
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Booking",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
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
