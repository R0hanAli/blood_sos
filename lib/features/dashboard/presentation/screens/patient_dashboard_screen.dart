import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../blood_request/presentation/controllers/blood_request_controller.dart';
import '../../../authentication/presentation/controllers/auth_controller.dart';
import '../../../../core/theme/app_theme.dart';

class PatientDashboard extends ConsumerWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authControllerProvider);
    final requestsState = ref.watch(bloodRequestControllerProvider);
    final theme = Theme.of(context);

    final currentUser = userState.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BloodSOS Patient'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_pin_outlined),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${currentUser?.profile?['fullName'] ?? "User"}',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Need blood urgently? You can create and broadcast a request immediately.',
                    style: TextStyle(color: Colors.grey, height: 1.3),
                  ),
                  const SizedBox(height: 20),

                  
                  ElevatedButton.icon(
                    onPressed: () => context.push('/request/create'),
                    icon: const Icon(Icons.add_alert_rounded),
                    label: const Text('Create Emergency Request'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryRed,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Text(
                'My Active Requests',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(bloodRequestControllerProvider.notifier).fetchOpenRequests(),
                child: requestsState.when(
                  data: (requests) {
                    
                    final myRequests = requests
                        .where((r) => currentUser != null && (r.createdById == currentUser.uid || r.status == 'IN_PROGRESS'))
                        .toList();

                    if (myRequests.isEmpty) {
                      return ListView(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                          const Center(
                            child: Column(
                              children: [
                                Icon(Icons.history, size: 48, color: Colors.grey),
                                SizedBox(height: 12),
                                Text(
                                  'No current active requests.',
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: myRequests.length,
                      itemBuilder: (context, index) {
                        final req = myRequests[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppTheme.primaryRed.withValues(alpha: 0.1),
                              child: Text(
                                req.bloodType,
                                style: const TextStyle(
                                  color: AppTheme.primaryRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              '${req.unitsRequired} Units - ${req.patientName}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Location: ${req.hospitalName}'),
                            trailing: Chip(
                              label: Text(
                                req.status,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: req.status == 'OPEN' 
                                  ? Colors.green.shade50 
                                  : Colors.amber.shade50,
                            ),
                            onTap: () {
                              context.push('/request/details', extra: req);
                            },
                          ),
                        );
                      },
                    );
                  },
                  error: (err, stack) => Center(child: Text('Error loading requests: $err')),
                  loading: () => const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
