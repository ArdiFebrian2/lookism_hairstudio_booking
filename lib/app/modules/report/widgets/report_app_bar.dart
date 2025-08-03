// widgets/report_app_bar.dart
import 'package:flutter/material.dart';

class ReportAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onGeneratePdf;

  const ReportAppBar({super.key, required this.onGeneratePdf});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Laporan Pendapatan',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      backgroundColor: Colors.deepPurpleAccent,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton.outlined(
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
            onPressed: onGeneratePdf,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              side: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            tooltip: 'Generate PDF',
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
