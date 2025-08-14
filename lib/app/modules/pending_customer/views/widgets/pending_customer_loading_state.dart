// TODO Implement this library.
import 'package:flutter/material.dart';

class PendingCustomerLoadingState extends StatelessWidget {
  const PendingCustomerLoadingState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D8C)),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data customer...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
