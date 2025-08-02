// widgets/riwayat_booking_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lookism_hairstudio_booking/app/modules/riwayat/widgets/status_helper.dart';

class RiwayatBookingCard extends StatelessWidget {
  final dynamic booking; // Replace with your Booking model
  final int index;

  const RiwayatBookingCard({
    super.key,
    required this.booking,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          // onTap: () => _showBookingDetail(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildServiceInfo(),
                const SizedBox(height: 12),
                _buildBookingDetails(),
                if (_shouldShowActions()) ...[
                  const SizedBox(height: 16),
                  // _buildActionButtons(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.cut_rounded,
            color: Color(0xFF6366F1),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.serviceName.isNotEmpty
                    ? booking.serviceName
                    : 'Layanan tidak tersedia',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 2),
              // Text(
              //   'Booking #${(index + 1).toString().padLeft(3, '0')}',
              //   style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              // ),
            ],
          ),
        ),
        StatusHelper.buildStatusChip(booking.status),
      ],
    );
  }

  Widget _buildServiceInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        children: [
          _buildInfoItem(
            Icons.person_outline,
            'Barberman',
            booking.barbermanName.isNotEmpty
                ? booking.barbermanName
                : 'Belum ditentukan',
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            Icons.calendar_today_outlined,
            'Tanggal',
            DateFormat('dd MMM yyyy').format(booking.bookingDate),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDetailItem(
            Icons.access_time_outlined,
            'Waktu',
            DateFormat('HH:mm').format(booking.bookingDate),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6366F1)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildActionButtons(BuildContext context) {
  //   return Row(
  //     children: [
  //       if (booking.status.toLowerCase() == 'pending') ...[
  //         Expanded(
  //           child: OutlinedButton(
  //             onPressed: () => _cancelBooking(),
  //             style: OutlinedButton.styleFrom(
  //               side: const BorderSide(color: Color(0xFFEF4444)),
  //               foregroundColor: const Color(0xFFEF4444),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               padding: const EdgeInsets.symmetric(vertical: 8),
  //             ),
  //             child: const Text(
  //               'Batalkan',
  //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //       ],
  //       // Expanded(
  //       //   child: ElevatedButton(
  //       //     onPressed: () => _showBookingDetail(context),
  //       //     style: ElevatedButton.styleFrom(
  //       //       backgroundColor: const Color(0xFF6366F1),
  //       //       foregroundColor: Colors.white,
  //       //       shape: RoundedRectangleBorder(
  //       //         borderRadius: BorderRadius.circular(8),
  //       //       ),
  //       //       padding: const EdgeInsets.symmetric(vertical: 8),
  //       //       elevation: 0,
  //       //     ),
  //       //     child: const Text(
  //       //       'Detail',
  //       //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  //       //     ),
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

  bool _shouldShowActions() {
    final status = booking.status.toLowerCase();
    return status == 'pending' || status == 'accepted' || status == 'selesai';
  }

  // void _showBookingDetail(BuildContext context) {
  //   // Navigate to booking detail page
  //   // Get.to(() => BookingDetailView(booking: booking));

  //   // For now, show a snackbar
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Detail booking ${booking.serviceName}'),
  //       backgroundColor: const Color(0xFF6366F1),
  //       behavior: SnackBarBehavior.floating,
  //       margin: const EdgeInsets.all(16),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     ),
  //   );
  // }

  // void _cancelBooking() {
  //   // Implement cancel booking logic
  //   // controller.cancelBooking(booking.id);
  // }
}
