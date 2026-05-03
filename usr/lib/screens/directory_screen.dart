import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couldai_user_app/providers/hr_provider.dart';
import 'package:couldai_user_app/models/employee.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String _searchQuery = '';
  Department? _selectedDepartment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Directory', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Consumer<HrProvider>(
        builder: (context, provider, child) {
          var filteredEmployees = provider.employees.where((emp) {
            final matchesSearch = emp.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                                  emp.jobTitle.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesDept = _selectedDepartment == null || emp.department == _selectedDepartment;
            return matchesSearch && matchesDept;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search employees...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Department?>(
                          value: _selectedDepartment,
                          hint: const Text('All Departments'),
                          icon: const Icon(Icons.filter_list),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('All Departments')),
                            ...Department.values.map((dept) {
                              // basic capitalize
                              final name = dept.name[0].toUpperCase() + dept.name.substring(1);
                              return DropdownMenuItem(value: dept, child: Text(name));
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartment = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final emp = filteredEmployees[index];
                    return _EmployeeCard(employee: emp);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final Employee employee;

  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _showEmployeeDetails(context, employee);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(employee.avatarUrl),
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: employee.status == EmployeeStatus.active 
                        ? Colors.green 
                        : (employee.status == EmployeeStatus.onLeave ? Colors.orange : Colors.red),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              employee.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              employee.jobTitle,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                employee.departmentName,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.email_outlined, size: 20),
                  color: const Color(0xFF64748B),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.phone_outlined, size: 20),
                  color: const Color(0xFF64748B),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showEmployeeDetails(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Employee Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(employee.avatarUrl),
            ),
            const SizedBox(height: 16),
            Text(employee.fullName, style: Theme.of(context).textTheme.titleLarge),
            Text(employee.jobTitle, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(employee.email),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(employee.phoneNumber),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: Text(employee.departmentName),
              dense: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
