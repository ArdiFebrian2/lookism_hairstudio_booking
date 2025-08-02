import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String? serviceId;
  final String? barbermanName;
  final String? month;
  final int totalBookings;
  final int servicePrice;
  final int totalRevenue;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    this.serviceId,
    this.barbermanName,
    this.month,
    required this.totalBookings,
    required this.servicePrice,
    required this.totalRevenue,
    required this.createdAt,
  });

  factory ReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp createdTimestamp = data['createdAt'] ?? Timestamp.now();

    return ReportModel(
      id: doc.id,
      serviceId: data['serviceId'],
      barbermanName: data['barbermanName'],
      month: data['month'],
      totalBookings: data['totalBookings'] ?? 0,
      servicePrice: data['servicePrice'] ?? 0,
      totalRevenue: data['totalRevenue'] ?? 0,
      createdAt: createdTimestamp.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceId': serviceId,
      'barbermanName': barbermanName,
      'month': month,
      'totalBookings': totalBookings,
      'servicePrice': servicePrice,
      'totalRevenue': totalRevenue,
      'createdAt': createdAt,
    };
  }
}
