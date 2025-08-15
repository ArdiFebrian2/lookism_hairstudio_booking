// time_utils.dart
import 'package:flutter/material.dart';

class TimeUtils {
  // Format TimeOfDay ke 24 jam (HH:mm)
  static String formatTimeOfDay24(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  // Cek apakah waktu dalam rentang 09:00 - 22:00
  static bool isTimeInRange(TimeOfDay time) {
    const minHour = 9;
    const maxHour = 22;
    return time.hour >= minHour && time.hour <= maxHour;
  }

  // Konversi string time ke TimeOfDay
  static TimeOfDay? parseTimeString(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  // Cek apakah end time lebih besar dari start time
  static bool isEndTimeAfterStartTime(String startTime, String endTime) {
    final start = parseTimeString(startTime);
    final end = parseTimeString(endTime);

    if (start == null || end == null) return false;

    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return endMinutes > startMinutes;
  }

  // Cek apakah dua waktu overlap
  static bool isTimeOverlap(
    String startA,
    String endA,
    String startB,
    String endB,
  ) {
    final startMinutesA =
        parseTimeString(startA)!.hour * 60 + parseTimeString(startA)!.minute;
    final endMinutesA =
        parseTimeString(endA)!.hour * 60 + parseTimeString(endA)!.minute;
    final startMinutesB =
        parseTimeString(startB)!.hour * 60 + parseTimeString(startB)!.minute;
    final endMinutesB =
        parseTimeString(endB)!.hour * 60 + parseTimeString(endB)!.minute;

    return (startMinutesB < endMinutesA) && (endMinutesB > startMinutesA);
  }

  // Hitung durasi dalam menit
  static int calculateDurationInMinutes(String startTime, String endTime) {
    final start = parseTimeString(startTime);
    final end = parseTimeString(endTime);

    if (start == null || end == null) return 0;

    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return endMinutes > startMinutes ? endMinutes - startMinutes : 0;
  }

  // Format durasi dalam jam dan menit
  static String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) {
      return '$remainingMinutes menit';
    } else if (remainingMinutes == 0) {
      return '$hours jam';
    } else {
      return '$hours jam $remainingMinutes menit';
    }
  }

  // Validasi rentang waktu + cek bentrok
  static String? validateTimeRange(
    String? startTime,
    String? endTime,
    List<Map<String, String>> existingSchedules,
  ) {
    if (startTime == null || startTime.isEmpty) {
      return 'Jam mulai harus diisi';
    }

    if (endTime == null || endTime.isEmpty) {
      return 'Jam selesai harus diisi';
    }

    final start = parseTimeString(startTime);
    final end = parseTimeString(endTime);

    if (start == null || end == null) {
      return 'Format waktu tidak valid';
    }

    if (!isTimeInRange(start)) {
      return 'Jam mulai harus antara 09:00 - 22:00';
    }

    if (!isTimeInRange(end)) {
      return 'Jam selesai harus antara 09:00 - 22:00';
    }

    if (!isEndTimeAfterStartTime(startTime, endTime)) {
      return 'Jam selesai harus lebih dari jam mulai';
    }

    // 🔹 Cek bentrok dengan jadwal yang ada
    for (var schedule in existingSchedules) {
      final existingStart = schedule['startTime']!;
      final existingEnd = schedule['endTime']!;
      if (isTimeOverlap(existingStart, existingEnd, startTime, endTime)) {
        return 'Waktu ini bentrok dengan jadwal yang sudah ada';
      }
    }

    return null; // Valid
  }

  // Get time suggestions untuk dropdown
  static List<TimeOfDay> getTimeSuggestions() {
    final List<TimeOfDay> suggestions = [];

    for (int hour = 9; hour <= 22; hour++) {
      suggestions.add(TimeOfDay(hour: hour, minute: 0));
      if (hour != 22) {
        suggestions.add(TimeOfDay(hour: hour, minute: 30));
      }
    }

    return suggestions;
  }

  // Format TimeOfDay ke format 12 jam
  static String formatTimeOfDay12(TimeOfDay time) {
    final hour12 = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour12:$minute $period";
  }

  // Cek apakah tanggal adalah hari ini atau masa depan
  static bool isDateTodayOrFuture(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);

    return checkDate.isAtSameMomentAs(today) || checkDate.isAfter(today);
  }

  // Format tanggal untuk display
  static String formatDisplayDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate.isAtSameMomentAs(today)) {
      return 'Hari ini';
    } else if (checkDate.isAtSameMomentAs(tomorrow)) {
      return 'Besok';
    } else {
      const List<String> dayNames = [
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
        'Minggu',
      ];
      const List<String> monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];

      final dayName = dayNames[date.weekday - 1];
      final monthName = monthNames[date.month - 1];

      return '$dayName, ${date.day} $monthName ${date.year}';
    }
  }
}
