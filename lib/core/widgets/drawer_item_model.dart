import 'package:flutter/material.dart';

class DrawerItem {
  final String id;
  final String label;
  final IconData icon;
  final String route;
  final int? badge;

  DrawerItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.route,
    this.badge,
  });
}
