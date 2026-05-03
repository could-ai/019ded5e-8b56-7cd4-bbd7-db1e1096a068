import 'package:couldai_user_app/models/employee.dart';

enum LeaveType {
  annual,
  sick,
  personal,
  maternity,
  paternity,
  unpaid,
}

enum LeaveStatus {
  pending,
  approved,
  rejected,
}

class LeaveRequest {
  final String id;
  final Employee employee;
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final LeaveStatus status;
  final DateTime appliedOn;

  LeaveRequest({
    required this.id,
    required this.employee,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.appliedOn,
  });

  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }
  
  String get typeName {
    switch (type) {
      case LeaveType.annual: return 'Annual Leave';
      case LeaveType.sick: return 'Sick Leave';
      case LeaveType.personal: return 'Personal Leave';
      case LeaveType.maternity: return 'Maternity Leave';
      case LeaveType.paternity: return 'Paternity Leave';
      case LeaveType.unpaid: return 'Unpaid Leave';
    }
  }
}
