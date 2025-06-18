import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  String? id;
  String name;
  String description;
  double price;
  int duration; // in minutes
  String? image;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  ServiceModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    this.image,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      duration: json['duration'],
      image: json['image'],
      isActive: json['isActive'] ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'image': image,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
