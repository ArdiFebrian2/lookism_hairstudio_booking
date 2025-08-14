// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pending_customer_card.dart';

class PendingCustomerList extends StatelessWidget {
  final List<QueryDocumentSnapshot> pendingCustomers;
  final Future<void> Function() onRefresh;
  final void Function(String uid) onApprove;
  final void Function(String uid) onReject;

  const PendingCustomerList({
    Key? key,
    required this.pendingCustomers,
    required this.onRefresh,
    required this.onApprove,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Color(0xFF2E7D8C),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: pendingCustomers.length,
        itemBuilder: (context, index) {
          final data = pendingCustomers[index].data() as Map<String, dynamic>;

          return PendingCustomerCard(
            customerData: data,
            onApprove: () => onApprove(data['uid']),
            onReject: () => onReject(data['uid']),
          );
        },
      ),
    );
  }
}
