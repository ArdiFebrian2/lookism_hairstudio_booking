// widgets/riwayat_booking_list.dart
import 'package:flutter/material.dart';
import '../widgets/riwayat_booking_card.dart';

class RiwayatBookingList extends StatelessWidget {
  final List<dynamic> bookings; // Replace with your Booking model

  const RiwayatBookingList({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return RiwayatBookingCard(booking: booking, index: index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${bookings.length} Booking',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6366F1),
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Terbaru',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(width: 4),
          Icon(Icons.arrow_downward, size: 16, color: Colors.grey[600]),
        ],
      ),
    );
  }
}
