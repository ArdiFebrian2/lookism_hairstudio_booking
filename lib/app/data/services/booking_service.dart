import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference bookingsRef = FirebaseFirestore.instance.collection(
    'bookings',
  );

  // Create a new booking
  Future<void> addBooking(Map<String, dynamic> data) async {
    await bookingsRef.add(data);
  }

  // Get all bookings
  Stream<QuerySnapshot> getBookingsStream() {
    return bookingsRef.orderBy('bookingTime', descending: true).snapshots();
  }

  // Get bookings by customer UID
  Stream<QuerySnapshot> getBookingsByCustomer(String uid) {
    return bookingsRef.where('customerId', isEqualTo: uid).snapshots();
  }

  // Get bookings by barber UID
  Stream<QuerySnapshot> getBookingsByBarber(String uid) {
    return bookingsRef.where('barberId', isEqualTo: uid).snapshots();
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await bookingsRef.doc(bookingId).update({'status': status});
  }

  // Delete booking
  Future<void> deleteBooking(String bookingId) async {
    await bookingsRef.doc(bookingId).delete();
  }
}
