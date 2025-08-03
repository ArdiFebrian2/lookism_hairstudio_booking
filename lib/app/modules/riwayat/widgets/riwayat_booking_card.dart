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
      child: Column(
        children: [
          Row(
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
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoItem(
                Icons.attach_money_rounded,
                'Harga',
                NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(booking.servicePrice),
              ),
            ],
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
          // Icon(icon, size: 16, color: const Color(0xFF6366F1)),
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

  bool _shouldShowActions() {
    final status = booking.status.toLowerCase();
    return status == 'pending' || status == 'accepted' || status == 'selesai';
  }
}
