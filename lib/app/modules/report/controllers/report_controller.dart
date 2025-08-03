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

      final snapshot = await query.orderBy('month', descending: true).get();
      List<Map<String, dynamic>> tempReports = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        final String serviceName = data['serviceName'] ?? '-';
        int servicePrice = 0;

        // Cari harga berdasarkan nama service dari koleksi 'services'
        if (serviceName.isNotEmpty && serviceName != '-') {
          final serviceSnap =
              await FirebaseFirestore.instance
                  .collection('services')
                  .where('name', isEqualTo: serviceName)
                  .limit(1)
                  .get();

          if (serviceSnap.docs.isNotEmpty) {
            final serviceData = serviceSnap.docs.first.data();
            servicePrice = (serviceData['price'] ?? 0).toInt();
          }
        }

        data['servicePrice'] = servicePrice;
        data['totalRevenue'] = (data['totalBookings'] ?? 0) * servicePrice;

        tempReports.add(data);
      }

      reports.value = tempReports;
    } catch (e) {
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
                'Laporan Pendapatan Umum',
                style: pw.TextStyle(fontSize: 20),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Total Booking: $totalBookings'),
              pw.SizedBox(height: 8),
              pw.Text('Total Pendapatan: ${currency.format(totalRevenue)}'),
              pw.SizedBox(height: 20),
              pw.Text('Detail Per Layanan:', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Layanan', 'Harga', 'Jumlah Booking', 'Pendapatan'],
                data:
                    reports.map((item) {
                      return [
                        item['serviceName'] ?? '-',
                        currency.format(item['servicePrice'] ?? 0),
                        item['totalBookings'].toString(),
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
