import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class LaporanController extends GetxController {
  final statusList = ['Semua', 'Selesai', 'Menunggu', 'Dibatalkan'];
  final metodeList = ['Semua', 'Tunai', 'Transfer'];
  final periodeList = ['Harian', 'Bulanan', 'Tahunan'];

  final selectedStatus = 'Semua'.obs;
  final selectedMetode = 'Semua'.obs;
  final selectedPeriode = 'Harian'.obs;

  final dummyIncome = {
    'Harian': 150000,
    'Bulanan': 4500000,
    'Tahunan': 52000000,
  };

  int get totalPenghasilan => dummyIncome[selectedPeriode.value] ?? 0;

  /// Generate & download PDF
  Future<void> generateLaporanPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Laporan Pemesanan",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text("Periode: ${selectedPeriode.value}"),
              pw.Text("Status: ${selectedStatus.value}"),
              pw.Text("Metode Pembayaran: ${selectedMetode.value}"),
              pw.SizedBox(height: 16),
              pw.Text(
                "Total Penghasilan: Rp $totalPenghasilan",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Langsung download file PDF
    final Uint8List bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'laporan_${selectedPeriode.value.toLowerCase()}.pdf',
    );
  }
}
