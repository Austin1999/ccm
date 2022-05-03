import 'package:flutter/material.dart';

class PieData {
  PieData({
    required this.label,
    required this.value,
    required this.color,
    this.radius,
  });

  String label;
  double value;
  double? radius;
  Color color;
}
