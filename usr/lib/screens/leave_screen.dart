import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:couldai_user_app/providers/hr_provider.dart';
import 'package:couldai_user_app/models/leave_request.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leave Management', style: TextStyle(fontWeight: FontWeight.w600)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
            indicatorColor: Color(0xFF2563EB),
            labelColor: Color(0xFF2563EB),
            unselectedLabelColor: Color(0xFF64748B),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: FilledButton.icon(
                onPressed: () {
                  // Stub for applying leave
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Apply Leave modal placeholder')),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Apply Leave'),
              ),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            _LeaveList(status: LeaveStatus.pending),
            _LeaveList(status: LeaveStatus.approved),
            _LeaveList(status: LeaveStatus.rejected),
          ],
        ),
      ),
    );
  }
}

class _LeaveList extends StatelessWidget {
  final LeaveStatus status;

  const _LeaveList({required this.status});

  @override
  Widget build(BuildContext context) {
    return Consumer<HrProvider>(
      builder: (context, provider, child) {
        final requests = provider.leaveRequests.where((r) => r.status == status).toList();

        if (requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.insert_drive_file_outlined,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${status.name} requests found.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(24.0),
          itemCount: requests.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final req = requests[index];
            return _LeaveRequestCard(request: req);
          },
        );
      },
    );
  }
}

class _LeaveRequestCard extends StatelessWidget {
  final LeaveRequest request;

  const _LeaveRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (request.status) {
      case LeaveStatus.pending:
        statusColor = Colors.orange;
        break;
      case LeaveStatus.approved:
        statusColor = Colors.green;
        break;
      case LeaveStatus.rejected:
        statusColor = Colors.red;
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(request.employee.avatarUrl),
                      radius: 20,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.employee.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Applied on ${DateFormat('MMM d, yyyy').format(request.appliedOn)}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    request.status.name.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _InfoTile(label: 'Leave Type', value: request.typeName),
                const SizedBox(width: 40),
                _InfoTile(label: 'Duration', value: '${request.durationInDays} days'),
                const SizedBox(width: 40),
                _InfoTile(
                  label: 'Dates',
                  value: '${DateFormat('MMM d').format(request.startDate)} - ${DateFormat('MMM d').format(request.endDate)}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Reason', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(request.reason),
            if (request.status == LeaveStatus.pending) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.read<HrProvider>().updateLeaveRequestStatus(request.id, LeaveStatus.rejected);
                    },
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () {
                      context.read<HrProvider>().updateLeaveRequestStatus(request.id, LeaveStatus.approved);
                    },
                    style: FilledButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Approve'),
                  ),
                ],
              )
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
