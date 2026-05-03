import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:couldai_user_app/providers/hr_provider.dart';
import 'package:couldai_user_app/models/employee.dart';
import 'package:couldai_user_app/models/leave_request.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=33'),
              radius: 16,
            ),
          ),
        ],
      ),
      body: Consumer<HrProvider>(
        builder: (context, provider, child) {
          final totalEmployees = provider.employees.length;
          final onLeaveCount = provider.employees.where((e) => e.status == EmployeeStatus.onLeave).length;
          final pendingLeaves = provider.leaveRequests.where((r) => r.status == LeaveStatus.pending).length;

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              Text(
                'Welcome back, Admin',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 600;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _StatCard(
                        title: 'Total Employees',
                        value: totalEmployees.toString(),
                        icon: Icons.people_alt,
                        color: Colors.blue,
                        width: isMobile ? constraints.maxWidth : (constraints.maxWidth - 32) / 3,
                      ),
                      _StatCard(
                        title: 'On Leave Today',
                        value: onLeaveCount.toString(),
                        icon: Icons.beach_access,
                        color: Colors.orange,
                        width: isMobile ? constraints.maxWidth : (constraints.maxWidth - 32) / 3,
                      ),
                      _StatCard(
                        title: 'Pending Requests',
                        value: pendingLeaves.toString(),
                        icon: Icons.pending_actions,
                        color: Colors.purple,
                        width: isMobile ? constraints.maxWidth : (constraints.maxWidth - 32) / 3,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _RecentLeaveRequests(provider: provider),
                  ),
                  if (MediaQuery.of(context).size.width >= 900) ...[
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: _UpcomingBirthdays(provider: provider),
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final MaterialColor color;
  final double width;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color.shade600, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentLeaveRequests extends StatelessWidget {
  final HrProvider provider;

  const _RecentLeaveRequests({required this.provider});

  @override
  Widget build(BuildContext context) {
    final pendingRequests = provider.leaveRequests
        .where((r) => r.status == LeaveStatus.pending)
        .take(5)
        .toList();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pending Leave Requests',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Leave tab
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (pendingRequests.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'No pending requests.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pendingRequests.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final request = pendingRequests[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(request.employee.avatarUrl),
                  ),
                  title: Text(request.employee.fullName),
                  subtitle: Text(
                    '${request.typeName} · ${DateFormat('MMM d').format(request.startDate)} - ${DateFormat('MMM d').format(request.endDate)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => provider.updateLeaveRequestStatus(request.id, LeaveStatus.approved),
                        tooltip: 'Approve',
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => provider.updateLeaveRequestStatus(request.id, LeaveStatus.rejected),
                        tooltip: 'Reject',
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _UpcomingBirthdays extends StatelessWidget {
  final HrProvider provider;

  const _UpcomingBirthdays({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Upcoming Work Anniversaries',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3, // Mock data limit
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              if (index >= provider.employees.length) return const SizedBox.shrink();
              final emp = provider.employees[index];
              final years = DateTime.now().year - emp.hireDate.year;
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(emp.avatarUrl),
                ),
                title: Text(emp.fullName),
                subtitle: Text('$years years on ${DateFormat('MMMM d').format(emp.hireDate)}'),
                trailing: const Icon(Icons.celebration, color: Colors.orange),
              );
            },
          ),
        ],
      ),
    );
  }
}
