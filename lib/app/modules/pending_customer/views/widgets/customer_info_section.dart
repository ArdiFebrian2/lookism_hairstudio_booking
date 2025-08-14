// TODO Implement this library.
import 'package:flutter/material.dart';

class CustomerInfoSection extends StatelessWidget {
  final Map<String, dynamic> customerData;

  const CustomerInfoSection({Key? key, required this.customerData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.email_outlined, size: 20, color: Colors.grey[600]),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  customerData['email'] ?? 'Email tidak tersedia',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 20, color: Colors.grey[600]),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  customerData['phone'] ?? 'Nomor tidak tersedia',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
