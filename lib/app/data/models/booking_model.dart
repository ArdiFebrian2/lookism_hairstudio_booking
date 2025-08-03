import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String userId;
  final String name; // Nama customer
  final String serviceName;
  final String bookingTime;
  final String day;
  final String status;
  final DateTime bookingDate;
  final String barbermanName;
  final double servicePrice;

  BookingModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.serviceName,
    required this.bookingTime,
    required this.day,
    required this.status,
    required this.bookingDate,
    this.barbermanName = '',
    required this.servicePrice,
  });

  factory BookingModel.fromMap(
    String id,
    Map<String, dynamic> map, {
    String barbermanName = '',
    double? priceOverride, // <- perbaikan disini
  }) {
    return BookingModel(
      id: id,
      userId: map['userId'] ?? '',
      name: map['nama'] ?? 'Tanpa Nama',
      serviceName: map['serviceName'] ?? '-',
      bookingTime: map['bookingTime'] ?? '-',
      day: map['day'] ?? 'Tidak diketahui',
      status: map['status'] ?? '-',
      bookingDate: _parseDate(map['datetime']),
      barbermanName: barbermanName,
      servicePrice: priceOverride ?? (map['price']?.toDouble() ?? 0.0),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else {
      return DateTime.now();
    }
  }
}
