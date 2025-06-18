import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String customerName;
  final String comment;
  final double rating;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.customerName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory ReviewModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      customerName: data['customerName'] ?? '',
      comment: data['comment'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
