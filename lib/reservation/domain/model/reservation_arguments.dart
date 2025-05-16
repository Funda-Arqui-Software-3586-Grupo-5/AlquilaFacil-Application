import 'package:flutter/material.dart';

class ReservationArguments {
  
  final double price;
  final DateTime? selectedDay;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  ReservationArguments({
    required this.price,
    required this.selectedDay,
    required this.startTime,
    required this.endTime,
  });
}