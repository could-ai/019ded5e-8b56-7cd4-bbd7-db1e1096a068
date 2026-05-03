import 'package:flutter/foundation.dart';
import 'package:couldai_user_app/models/employee.dart';
import 'package:couldai_user_app/models/leave_request.dart';

class HrProvider extends ChangeNotifier {
  List<Employee> _employees = [];
  List<LeaveRequest> _leaveRequests = [];

  List<Employee> get employees => _employees;
  List<LeaveRequest> get leaveRequests => _leaveRequests;

  HrProvider() {
    _initMockData();
  }

  void _initMockData() {
    _employees = [
      Employee(
        id: 'EMP001',
        firstName: 'Sarah',
        lastName: 'Connor',
        email: 'sarah.connor@example.com',
        jobTitle: 'Senior Software Engineer',
        department: Department.engineering,
        status: EmployeeStatus.active,
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        hireDate: DateTime(2021, 3, 15),
        phoneNumber: '+1 555-0101',
      ),
      Employee(
        id: 'EMP002',
        firstName: 'John',
        lastName: 'Smith',
        email: 'john.smith@example.com',
        jobTitle: 'Product Designer',
        department: Department.design,
        status: EmployeeStatus.active,
        avatarUrl: 'https://i.pravatar.cc/150?img=11',
        hireDate: DateTime(2022, 6, 1),
        phoneNumber: '+1 555-0102',
      ),
      Employee(
        id: 'EMP003',
        firstName: 'Emily',
        lastName: 'Davis',
        email: 'emily.davis@example.com',
        jobTitle: 'Marketing Director',
        department: Department.marketing,
        status: EmployeeStatus.onLeave,
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        hireDate: DateTime(2019, 11, 20),
        phoneNumber: '+1 555-0103',
      ),
      Employee(
        id: 'EMP004',
        firstName: 'Michael',
        lastName: 'Chen',
        email: 'michael.chen@example.com',
        jobTitle: 'HR Manager',
        department: Department.hr,
        status: EmployeeStatus.active,
        avatarUrl: 'https://i.pravatar.cc/150?img=8',
        hireDate: DateTime(2020, 1, 10),
        phoneNumber: '+1 555-0104',
      ),
      Employee(
        id: 'EMP005',
        firstName: 'Jessica',
        lastName: 'Taylor',
        email: 'jessica.taylor@example.com',
        jobTitle: 'Sales Executive',
        department: Department.sales,
        status: EmployeeStatus.active,
        avatarUrl: 'https://i.pravatar.cc/150?img=9',
        hireDate: DateTime(2023, 2, 14),
        phoneNumber: '+1 555-0105',
      ),
      Employee(
        id: 'EMP006',
        firstName: 'David',
        lastName: 'Wilson',
        email: 'david.wilson@example.com',
        jobTitle: 'Financial Analyst',
        department: Department.finance,
        status: EmployeeStatus.active,
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        hireDate: DateTime(2018, 8, 5),
        phoneNumber: '+1 555-0106',
      ),
    ];

    _leaveRequests = [
      LeaveRequest(
        id: 'LR001',
        employee: _employees[2], // Emily
        type: LeaveType.maternity,
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        endDate: DateTime.now().add(const Duration(days: 80)),
        reason: 'Maternity Leave',
        status: LeaveStatus.approved,
        appliedOn: DateTime.now().subtract(const Duration(days: 30)),
      ),
      LeaveRequest(
        id: 'LR002',
        employee: _employees[0], // Sarah
        type: LeaveType.annual,
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 10)),
        reason: 'Family vacation',
        status: LeaveStatus.pending,
        appliedOn: DateTime.now().subtract(const Duration(days: 2)),
      ),
      LeaveRequest(
        id: 'LR003',
        employee: _employees[1], // John
        type: LeaveType.sick,
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 1)),
        reason: 'Flu',
        status: LeaveStatus.pending,
        appliedOn: DateTime.now().subtract(const Duration(days: 1)),
      ),
      LeaveRequest(
        id: 'LR004',
        employee: _employees[4], // Jessica
        type: LeaveType.personal,
        startDate: DateTime.now().add(const Duration(days: 20)),
        endDate: DateTime.now().add(const Duration(days: 21)),
        reason: 'Personal errands',
        status: LeaveStatus.approved,
        appliedOn: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  void updateLeaveRequestStatus(String requestId, LeaveStatus newStatus) {
    final index = _leaveRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      final req = _leaveRequests[index];
      _leaveRequests[index] = LeaveRequest(
        id: req.id,
        employee: req.employee,
        type: req.type,
        startDate: req.startDate,
        endDate: req.endDate,
        reason: req.reason,
        status: newStatus,
        appliedOn: req.appliedOn,
      );
      notifyListeners();
    }
  }
}
