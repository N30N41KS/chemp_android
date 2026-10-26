import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_first_app/app_state.dart';

void main() {
  test('formatDate выдаёт формат из макета', () {
    expect(formatDate(DateTime(2019, 11, 4)), 'MON, NOV 4, 2019');
  });

  test('formatTime переводит в 12-часовой формат', () {
    expect(formatTime(const TimeOfDay(hour: 0, minute: 30)), '12:30 AM');
    expect(formatTime(const TimeOfDay(hour: 15, minute: 5)), '3:05 PM');
  });

  test('addGame добавляет игру в общий список', () {
    AppState.games.value = [];
    AppState.addGame(ScheduledGame(
      name: 'Test',
      category: 'Action',
      price: '10',
      description: '',
      from: DateTime(2026, 1, 1, 10),
      to: DateTime(2026, 1, 1, 12),
      reminder: true,
    ));
    expect(AppState.games.value.length, 1);
  });
}
