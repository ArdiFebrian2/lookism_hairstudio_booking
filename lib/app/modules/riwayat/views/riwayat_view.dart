import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/riwayat_controller.dart';

class RiwayatView extends StatelessWidget {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RiwayatController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Booking'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bookings.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada riwayat booking',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.bookings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Service Name + Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            booking.serviceName.isNotEmpty
                                ? booking.serviceName
                                : 'Layanan tidak tersedia',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _buildStatusChip(booking.status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Date & Time
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.deepPurple,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${booking.day}, ${DateFormat('dd MMM yyyy').format(booking.bookingDate)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.deepPurple,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Pukul ${booking.bookingTime}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Barberman: ${booking.barbermanName.isNotEmpty ? booking.barbermanName : "-"}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
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

  Widget _buildStatusChip(String status) {
    final color = getStatusColor(status);
    final icon = getStatusIcon(status);

    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 16),
      label: Text(
        status.capitalizeFirst ?? '',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'done':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'accepted':
        return Icons.check_circle_outline;
      case 'done':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info_outline;
    }
  }
}
