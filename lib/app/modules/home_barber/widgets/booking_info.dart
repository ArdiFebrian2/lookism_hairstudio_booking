import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import yang hilang
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_info_row.dart';

class BookingInfo extends StatelessWidget {
  final DateTime dateTime;

  const BookingInfo({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    final day = DateFormat.EEEE('id_ID').format(dateTime);
    final date = DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
    final time = DateFormat.Hm('id_ID').format(dateTime);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          BookingInfoRow(icon: Icons.calendar_today, label: 'Hari', value: day),
          const SizedBox(height: 8),
          BookingInfoRow(icon: Icons.date_range, label: 'Tanggal', value: date),
          const SizedBox(height: 8),
          BookingInfoRow(
            icon: Icons.access_time,
            label: 'Jam',
            value: '$time WIB',
          ),
        ],
      ),
    );
  }
}
