import 'package:flutter/material.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_action_buttons.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_header.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_info.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_status.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_utils.dart';

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime =
        DateTime.tryParse(booking['datetime'] ?? '') ?? DateTime.now();
    final status = booking['status'] ?? 'unknown';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: BookingUtils.getStatusColor(status).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookingHeader(serviceName: booking['serviceName']),
                const SizedBox(height: 8),

                // Informasi Customer
                Text(
                  'Customer: ${booking['customerName'] ?? 'Tidak diketahui'}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Email: ${booking['customerEmail'] ?? '-'}',
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  'Telepon: ${booking['customerPhone'] ?? '-'}',
                  style: const TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 12),
                BookingInfo(dateTime: dateTime),
                const SizedBox(height: 12),
                BookingStatus(status: status),

                if (status == 'pending') ...[
                  const SizedBox(height: 16),
                  BookingActionButtons(onAccept: onAccept, onReject: onReject),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
