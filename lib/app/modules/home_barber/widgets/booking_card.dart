import 'package:flutter/material.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_action_buttons.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_header.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_info.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_status.dart';
import 'package:lookism_hairstudio_booking/app/modules/home_barber/widgets/booking_utils.dart';

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;

  const BookingCard({
    super.key,
    required this.booking,
    this.onAccept,
    this.onReject,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime =
        DateTime.tryParse(booking['datetime'] ?? '') ?? DateTime.now();
    final status = booking['status'] ?? 'unknown';
    final statusColor = BookingUtils.getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, statusColor.withOpacity(0.02)],
            ),
            border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Header with Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: BookingHeader(serviceName: booking['serviceName']),
                    ),
                    const SizedBox(width: 12),
                    BookingStatus(status: status),
                  ],
                ),

                const SizedBox(height: 20),

                // Customer Information Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 18,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Informasi Customer',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Customer Name
                      _buildInfoRow(
                        Icons.person,
                        'Nama',
                        booking['customerName'] ?? 'Tidak diketahui',
                        isPrimary: true,
                      ),

                      const SizedBox(height: 8),

                      // Customer Email
                      _buildInfoRow(
                        Icons.email_outlined,
                        'Email',
                        booking['customerEmail'] ?? '-',
                      ),

                      const SizedBox(height: 8),

                      // Customer Phone
                      _buildInfoRow(
                        Icons.phone_outlined,
                        'Telepon',
                        booking['customerPhone'] ?? '-',
                      ),
                      Text('Harga: Rp ${booking['price']}'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Booking DateTime Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.2)),
                  ),
                  child: BookingInfo(dateTime: dateTime),
                ),

                // Action Buttons (only for pending status)
                if (status == 'pending' &&
                    onAccept != null &&
                    onReject != null) ...[
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    child: BookingActionButtons(
                      onAccept: onAccept!,
                      onReject: onReject!,
                    ),
                  ),
                ] else if (status == 'accepted' && onComplete != null) ...[
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16),
                    child: ElevatedButton.icon(
                      onPressed: onComplete,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Tandai Selesai'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isPrimary = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: isPrimary ? Colors.blue[600] : Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                  color: isPrimary ? Colors.grey[800] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
