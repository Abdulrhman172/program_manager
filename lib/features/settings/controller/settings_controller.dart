import 'package:flutter/material.dart';

/// Controller for the Settings screen.
/// Manages tab state and notification toggle preferences.
class SettingsController extends ChangeNotifier {
  bool _emailNotifications = true;
  bool _newResearchNotifications = true;
  bool _deadlineNotifications = true;
  bool _approvalNotifications = true;

  bool get emailNotifications => _emailNotifications;
  bool get newResearchNotifications => _newResearchNotifications;
  bool get deadlineNotifications => _deadlineNotifications;
  bool get approvalNotifications => _approvalNotifications;

  void setEmailNotifications(bool value) {
    _emailNotifications = value;
    notifyListeners();
  }

  void setNewResearchNotifications(bool value) {
    _newResearchNotifications = value;
    notifyListeners();
  }

  void setDeadlineNotifications(bool value) {
    _deadlineNotifications = value;
    notifyListeners();
  }

  void setApprovalNotifications(bool value) {
    _approvalNotifications = value;
    notifyListeners();
  }
}
