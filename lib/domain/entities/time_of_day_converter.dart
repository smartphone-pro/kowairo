import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(String json) {
    if (json.isEmpty) {
      // 必要に応じてデフォルトを決める or throw
      return const TimeOfDay(hour: 0, minute: 0);
    }

    // "HH:MM:SS" or "HH:MM" を想定
    final parts = json.split(':');
    if (parts.length < 2) {
      return const TimeOfDay(hour: 0, minute: 0);
    }

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  String toJson(TimeOfDay time) {
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    // 秒も欲しければ 00 を付け足す
    return '$hh:$mm:00';
  }
}
