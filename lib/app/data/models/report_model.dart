import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String barberId;
  final String barberName;
  final double amount;
  final String serviceName;
  final String status;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.barberId,
    required this.barberName,
    required this.amount,
    required this.serviceName,
    required this.status,
    required this.createdAt,
  });

  factory ReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReportModel(
      id: doc.id,
      barberId: data['barberId'] ?? '',
      barberName: data['barberName'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      serviceName: data['serviceName'] ?? '',
      status: data['status'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
