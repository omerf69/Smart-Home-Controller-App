/// Mixin: Schedulable
/// 
/// Demonstrates the Mixin concept in Dart.
/// Mixins allow code reuse across multiple class hierarchies without multiple inheritance.
/// Classes can include this mixin using the 'with' keyword.
mixin Schedulable {
  String? _scheduledTime;
  bool _hasSchedule = false;

  bool get hasSchedule => _hasSchedule;
  String? get scheduledTime => _scheduledTime;

  /// Sets a scheduled time for an automated device routine.
  void setSchedule(String time) {
    _scheduledTime = time;
    _hasSchedule = true;
  }

  /// Cancels any active schedule.
  void clearSchedule() {
    _scheduledTime = null;
    _hasSchedule = false;
  }

  /// Returns a formatted summary of the schedule.
  String getScheduleSummary() {
    if (_hasSchedule && _scheduledTime != null) {
      return 'Scheduled at $_scheduledTime';
    }
    return 'No active schedule';
  }
}

