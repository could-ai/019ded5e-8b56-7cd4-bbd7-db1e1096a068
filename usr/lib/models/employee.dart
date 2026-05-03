enum Department {
  engineering,
  sales,
  marketing,
  hr,
  design,
  finance,
}

enum EmployeeStatus {
  active,
  onLeave,
  terminated,
}

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String jobTitle;
  final Department department;
  final EmployeeStatus status;
  final String avatarUrl;
  final DateTime hireDate;
  final String phoneNumber;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.jobTitle,
    required this.department,
    required this.status,
    required this.avatarUrl,
    required this.hireDate,
    required this.phoneNumber,
  });

  String get fullName => '$firstName $lastName';
  
  String get departmentName {
    switch (department) {
      case Department.engineering: return 'Engineering';
      case Department.sales: return 'Sales';
      case Department.marketing: return 'Marketing';
      case Department.hr: return 'Human Resources';
      case Department.design: return 'Design';
      case Department.finance: return 'Finance';
    }
  }
}
