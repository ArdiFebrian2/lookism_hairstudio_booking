import 'package:cloud_firestore/cloud_firestore.dart';

class RiwayatBabermanModel {
  final String id;
  final String bookingId;
  final String userId;
  final String barbermanId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String serviceName;
  final String bookingTime;
  final String day;
  final String status;
  final DateTime datetime;
  final String barbermanName;

  RiwayatBabermanModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.barbermanId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.serviceName,
    required this.bookingTime,
    required this.day,
    required this.status,
    required this.datetime,
    required this.barbermanName,
  });

  factory RiwayatBabermanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RiwayatBabermanModel(
      id: doc.id,
      bookingId: data['bookingId'] ?? '',
      userId: data['userId'] ?? '',
      barbermanId: data['barbermanId'] ?? '',
      customerName: data['customerName'] ?? '-',
      customerEmail: data['customerEmail'] ?? '-',
      customerPhone: data['customerPhone'] ?? '-',
      serviceName: data['serviceName'] ?? '-',
      bookingTime: data['bookingTime'] ?? '-',
      day: data['day'] ?? '-',
      status: data['status'] ?? '-',
      datetime: _parseDate(data['datetime']),
      barbermanName: data['barbermanName'] ?? '-',
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

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'barbermanId': barbermanId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'serviceName': serviceName,
      'bookingTime': bookingTime,
      'day': day,
      'status': status,
      'datetime': datetime.toIso8601String(),
      'barbermanName': barbermanName,
    };
  }
}
