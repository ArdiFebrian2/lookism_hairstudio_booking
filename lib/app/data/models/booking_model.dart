import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String status;
  final String serviceName;
  final DateTime datetime;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.status,
    required this.serviceName,
    required this.datetime,
    required this.createdAt,
  });

  factory BookingModel.fromMap(String id, Map<String, dynamic> data) {
    return BookingModel(
      id: id,
      status: data['status'] ?? '',
      serviceName: data['serviceName'] ?? '',
      datetime: (data['datetime'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Getter opsional jika ingin ambil tanggal dan jam terpisah
  String get bookingDate =>
      "${datetime.year}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}";
  String get bookingTime =>
      "${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";
  String get day => _getDayName(datetime.weekday);

  static String _getDayName(int weekday) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[(weekday - 1) % 7];
  }
}
