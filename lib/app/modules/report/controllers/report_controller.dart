import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportController extends GetxController {
  final reports = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  String? selectedMonth;
  int? selectedYear;
  DateTime? selectedDate;

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  void fetchReports({String? month, int? year, DateTime? date}) async {
    isLoading.value = true;

    try {
      Query query = FirebaseFirestore.instance.collection('reports');

      if (date != null) {
        final start = DateTime(date.year, date.month, date.day);
        final end = start.add(const Duration(days: 1));
        query = query
            .where('createdAt', isGreaterThanOrEqualTo: start)
            .where('createdAt', isLessThan: end);
      } else {
        if (month != null) {
          query = query.where('month', isEqualTo: month);
        }
        if (year != null) {
          query = query
              .where('month', isGreaterThanOrEqualTo: '$year-01')
              .where('month', isLessThanOrEqualTo: '$year-12');
        }
      }

      // Hindari orderBy error jika month bisa null → urutkan berdasarkan createdAt saja
      final snapshot = await query.orderBy('createdAt', descending: true).get();

      List<Map<String, dynamic>> tempReports = [];

      // Ambil semua user baberman
      final barberSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'baberman')
              .get();

      final barberMap = {
        for (var doc in barberSnapshot.docs)
          doc.id: (doc.data() as Map<String, dynamic>)['nama'] ?? '-',
      };

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        // Fallback ambil ID baberman
        final babermanId = data['barbermanId'] ?? data['serviceId'];

        // Ambil nama baberman → kalau tidak ada di users, pakai yang tersimpan di reports
        data['barbermanName'] =
            barberMap[babermanId] ?? (data['barbermanName'] ?? '-');

        // Ambil hari & tanggal dari createdAt
        if (data['createdAt'] is Timestamp) {
          final createdDate = (data['createdAt'] as Timestamp).toDate();
          data['day'] = DateFormat.EEEE('id_ID').format(createdDate); // Senin
          data['date'] = DateFormat(
            'dd MMM yyyy',
            'id_ID',
          ).format(createdDate); // 12 Agu 2025
        } else if (data['createdAt'] is DateTime) {
          data['day'] = DateFormat.EEEE('id_ID').format(data['createdAt']);
          data['date'] = DateFormat(
            'dd MMM yyyy',
            'id_ID',
          ).format(data['createdAt']);
        } else {
          data['day'] = '-';
          data['date'] = '-';
        }

        tempReports.add(data);
      }

      reports.value = tempReports;
    } catch (e, st) {
      print('❌ Error di fetchReports: $e');
      print(st);
      Get.snackbar('Error', 'Gagal mengambil data laporan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final totalRevenue = reports.fold<int>(
      0,
      (sum, item) => sum + ((item['totalRevenue'] ?? 0) as int),
    );

    final totalBookings = reports.fold<int>(
      0,
      (sum, item) => sum + ((item['totalBookings'] ?? 0) as int),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Laporan Pendapatan Lookism Hairstudio',
                style: pw.TextStyle(fontSize: 20),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Total Booking: $totalBookings'),
              pw.SizedBox(height: 8),
              pw.Text('Total Pendapatan: ${currency.format(totalRevenue)}'),
              pw.SizedBox(height: 20),
              pw.Text('Detail Laporan:', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: [
                  // 'Bulan',
                  'Tanggal',
                  'Hari',
                  'Nama Baberman',
                  'Total Booking',
                  'Total Pendapatan',
                ],
                data:
                    reports.map((item) {
                      return [
                        // item['month'] ?? '-',
                        item['date'] ?? '-',
                        item['day'] ?? '-',
                        item['barbermanName'] ?? '-',
                        item['totalBookings']?.toString() ?? '0',
                        currency.format(item['totalRevenue'] ?? 0),
                      ];
                    }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
