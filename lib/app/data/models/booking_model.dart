import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String userId;
  final String serviceName;
  final String bookingTime;
  final String day;
  final String status;
  final DateTime bookingDate;
  final String barbermanName; // tambahkan ini

  BookingModel({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.bookingTime,
    required this.day,
    required this.status,
    required this.bookingDate,
    this.barbermanName = '',
  });

  factory BookingModel.fromMap(
    String id,
    Map<String, dynamic> map, {
    String barbermanName = '',
  }) {
    return BookingModel(
      id: id,
      userId: map['userId'] ?? '',
      serviceName: map['serviceName'] ?? '',
      bookingTime: map['bookingTime'] ?? '',
      day: map['day'] ?? '',
      status: map['status'] ?? '',
      bookingDate: _parseDate(map['datetime']),
      barbermanName: barbermanName,
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
