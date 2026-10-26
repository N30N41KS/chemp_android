import 'package:flutter/material.dart';

class ScheduledGame {
  final String name;
  final String category;
  final String price;
  final String description;
  final DateTime from;
  final DateTime to;
  final bool reminder;

  const ScheduledGame({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.from,
    required this.to,
    required this.reminder,
  });
}

/// Простое глобальное состояние прототипа.
class AppState {
  static final ValueNotifier<List<ScheduledGame>> games =
      ValueNotifier<List<ScheduledGame>>(<ScheduledGame>[]);

  static final ValueNotifier<String> language = ValueNotifier<String>('English');
  static final ValueNotifier<String> skin = ValueNotifier<String>('Combat Pink');

  static void addGame(ScheduledGame g) {
    games.value = [...games.value, g];
  }
}

const List<String> _weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
const List<String> _months = [
  'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];

/// "MON, NOV 4, 2019"
String formatDate(DateTime d) {
  return '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}, ${d.year}';
}

/// "12:30 AM"
String formatTime(TimeOfDay t) {
  final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
  final m = t.minute.toString().padLeft(2, '0');
  final p = t.period == DayPeriod.am ? 'AM' : 'PM';
  return '$h:$m $p';
}
