import 'package:flutter/material.dart';

class LabItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;

  LabItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });
}
