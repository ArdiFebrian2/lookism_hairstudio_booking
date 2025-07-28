import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

class ReportService {
  final _reportCollection = FirebaseFirestore.instance.collection('reports');

  Future<List<ReportModel>> fetchReports({
    String? barberId,
    DateTime? start,
    DateTime? end,
  }) async {
    Query query = _reportCollection.where('status', isEqualTo: 'selesai');

    if (barberId != null && barberId.isNotEmpty) {
      query = query.where('barberId', isEqualTo: barberId);
    }

    if (start != null && end != null) {
      query = query
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(end));
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => ReportModel.fromFirestore(doc)).toList();
  }
}
