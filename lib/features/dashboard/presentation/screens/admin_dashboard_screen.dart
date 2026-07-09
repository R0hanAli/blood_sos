import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../blood_request/presentation/controllers/blood_request_controller.dart';
import '../../../../features/admin/presentation/controllers/admin_controller.dart';
import '../../../../features/authentication/domain/entities/user_role.dart';
import '../../../../core/theme/app_theme.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  final TextEditingController _broadcastController = TextEditingController();
  bool _isBroadcasting = false;

  @override
  void dispose() {
    _broadcastController.dispose();
    super.dispose();
  }

  Future<void> _triggerBroadcast() async {
    final msg = _broadcastController.text.trim();
    if (msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a broadcast announcement.')),
      );
      return;
    }

    setState(() => _isBroadcasting = true);
    try {
      await ref.read(adminUsersControllerProvider.notifier).sendBroadcast(msg);
      _broadcastController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Announcement broadcasted to all active sessions!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Broadcast failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isBroadcasting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestsState = ref.watch(bloodRequestControllerProvider);
    final adminUsersState = ref.watch(adminUsersControllerProvider);
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BloodSOS System Admin'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_pin_outlined),
              onPressed: () => context.push('/profile'),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppTheme.primaryRed,
            labelColor: AppTheme.primaryRed,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.people_alt_outlined), text: 'Users'),
              Tab(icon: Icon(Icons.campaign_outlined), text: 'Broadcast'),
              Tab(icon: Icon(Icons.list_alt_rounded), text: 'Requests'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              
              adminUsersState.when(
                data: (users) {
                  if (users.isEmpty) {
                    return const Center(child: Text('No users in system.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final usr = users[index];
                      final isHospital = usr.role == UserRole.hospital;
                      final isSuspended = usr.profile?['isSuspended'] == true;
                      final isVerified = usr.profile?['isVerified'] == true;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: isSuspended
                                ? Colors.grey
                                : (isHospital ? Colors.purple.shade100 : Colors.red.shade100),
                            child: Icon(
                              isHospital ? Icons.local_hospital : Icons.person,
                              color: isSuspended
                                  ? Colors.white
                                  : (isHospital ? Colors.purple : AppTheme.primaryRed),
                            ),
                          ),
                          title: Text(
                            usr.profile?['fullName'] ?? usr.email,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Role: ${usr.role.name.toUpperCase()}'),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              if (isSuspended)
                                const Chip(
                                  label: Text('Suspended', style: TextStyle(color: Colors.white, fontSize: 10)),
                                  backgroundColor: Colors.grey,
                                  padding: EdgeInsets.zero,
                                ),
                              if (isHospital && isVerified)
                                const Chip(
                                  label: Text('Verified', style: TextStyle(color: Colors.white, fontSize: 10)),
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.zero,
                                ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: isSuspended ? Colors.green : Colors.red,
                                      side: BorderSide(color: isSuspended ? Colors.green : Colors.red),
                                    ),
                                    onPressed: () {
                                      ref.read(adminUsersControllerProvider.notifier).suspendUserToggle(usr.uid, !isSuspended);
                                    },
                                    icon: Icon(isSuspended ? Icons.check_circle_outline : Icons.block),
                                    label: Text(isSuspended ? 'Lift Lock' : 'Suspend'),
                                  ),
                                  const SizedBox(width: 12),

                                  
                                  if (isHospital)
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isVerified ? Colors.amber : Colors.green,
                                      ),
                                      onPressed: () {
                                        ref.read(adminUsersControllerProvider.notifier).verifyHospitalToggle(usr.uid, !isVerified);
                                      },
                                      icon: Icon(isVerified ? Icons.cancel_outlined : Icons.verified),
                                      label: Text(isVerified ? 'Unverify' : 'Verify'),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                error: (err, _) => Center(child: Text('Error: $err')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),

              
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Dispatch System Broadcast',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Broadcast emergency updates, safety notifications, or alerts directly to all online sessions.',
                      style: TextStyle(color: Colors.grey, height: 1.3),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _broadcastController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Type critical system announcement here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _isBroadcasting ? null : _triggerBroadcast,
                      icon: _isBroadcasting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.campaign),
                      label: const Text('Transmit Broadcast Notice'),
                    ),
                  ],
                ),
              ),

              
              requestsState.when(
                data: (requests) {
                  if (requests.isEmpty) {
                    return const Center(child: Text('No active emergency requests.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final req = requests[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text('${req.patientName} (${req.bloodType})'),
                          subtitle: Text('Hospital: ${req.hospitalName} | Status: ${req.status}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              ref.read(bloodRequestControllerProvider.notifier).updateStatus(req.id, 'CANCELLED');
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (err, _) => Center(child: Text('Error: $err')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
