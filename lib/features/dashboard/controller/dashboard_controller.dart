import 'package:flutter/material.dart';

/// Controller for the Dashboard screen.
/// Manages navigation state and provides dashboard data.
class DashboardController extends ChangeNotifier {
  String _currentRoute = '/';

  String get currentRoute => _currentRoute;

  void setCurrentRoute(String route) {
    _currentRoute = route;
    notifyListeners();
  }

  void resetRoute() {
    _currentRoute = '/';
    notifyListeners();
  }
}
