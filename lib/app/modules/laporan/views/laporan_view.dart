import 'package:flutter/material.dart';

class LaporanView extends StatefulWidget {
  const LaporanView({super.key});

  @override
  State<LaporanView> createState() => _LaporanViewState();
}

class _LaporanViewState extends State<LaporanView> {
  // Data dropdown
  final List<String> statusList = [
    'Semua',
    'Selesai',
    'Menunggu',
    'Dibatalkan',
  ];
  final List<String> metodeList = ['Semua', 'Tunai', 'Transfer'];

  // Nilai terpilih
  String selectedStatus = 'Semua';
  String selectedMetode = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Pemesanan'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown filter status
            Row(
              children: [
                const Text("Status: "),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedStatus,
                    isExpanded: true,
                    items:
                        statusList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dropdown filter metode pembayaran
            Row(
              children: [
                const Text("Metode Pembayaran: "),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedMetode,
                    isExpanded: true,
                    items:
                        metodeList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedMetode = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {
                // Di sini bisa tambahkan logic generate PDF berdasarkan filter
                debugPrint(
                  'Generate PDF: Status=$selectedStatus, Metode=$selectedMetode',
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Generate Laporan (PDF)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
