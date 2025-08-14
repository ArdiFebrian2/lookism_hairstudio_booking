// TODO Implement this library.
import 'package:flutter/material.dart';
import 'confirm_dialog.dart';

class CustomerActionButtons extends StatelessWidget {
  final String customerName;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const CustomerActionButtons({
    Key? key,
    required this.customerName,
    required this.onApprove,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showRejectDialog(context),
            // icon: Icon(Icons.close, size: 20),
            label: Text('Tolak', style: TextStyle(fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red[700],
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.red.withOpacity(0.3)),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showApproveDialog(context),
            // icon: Icon(Icons.check, size: 20),
            label: Text(
              'Setujui',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showRejectDialog(BuildContext context) {
    ConfirmDialog.show(
      title: 'Tolak Customer',
      message: 'Apakah Anda yakin ingin menolak customer $customerName?',
      confirmText: 'TOLAK',
      color: Colors.red,
      onConfirm: onReject,
    );
  }

  void _showApproveDialog(BuildContext context) {
    ConfirmDialog.show(
      title: 'Setujui Customer',
      message: 'Apakah Anda yakin ingin menyetujui customer $customerName?',
      confirmText: 'SETUJUI',
      color: Colors.green,
      onConfirm: onApprove,
    );
  }
}
