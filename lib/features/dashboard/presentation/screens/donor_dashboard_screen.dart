import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../blood_request/presentation/controllers/blood_request_controller.dart';
import '../../../../core/services/providers.dart';
import '../../../../core/theme/app_theme.dart';

class DonorDashboard extends ConsumerStatefulWidget {
  const DonorDashboard({super.key});

  @override
  ConsumerState<DonorDashboard> createState() => _DonorDashboardState();
}

class _DonorDashboardState extends ConsumerState<DonorDashboard> {
  String? _selectedFilter;

  final List<String> _bloodTypes = ['ALL', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  Widget build(BuildContext context) {
    final requestsState = ref.watch(bloodRequestControllerProvider);
    final socketService = ref.watch(socketServiceProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BloodSOS Donor'),
        actions: [
          
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: socketService.isConnected ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                socketService.isConnected ? 'Live' : 'Offline',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 12),
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
            
            Container(
              padding: const EdgeInsets.all(20.0),
              color: isDark ? const Color(0xFF1E1E1E) : Colors.red.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergency Requests Stream',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Showing active emergency requests in your area. Accept requests to coordinate donation.',
                    style: TextStyle(color: Colors.grey, height: 1.3),
                  ),
                ],
              ),
            ),

            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: _bloodTypes.map((type) {
                  final isSelected = (_selectedFilter == null && type == 'ALL') || (_selectedFilter == type);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedFilter = type == 'ALL' ? null : type;
                        });
                        ref.read(bloodRequestControllerProvider.notifier).fetchOpenRequests(
                              bloodType: _selectedFilter,
                            );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(bloodRequestControllerProvider.notifier).fetchOpenRequests(
                      bloodType: _selectedFilter,
                    ),
                child: requestsState.when(
                  data: (requests) {
                    if (requests.isEmpty) {
                      return ListView(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                          const Center(
                            child: Column(
                              children: [
                                Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                                SizedBox(height: 12),
                                Text(
                                  'No Active Emergency Requests',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Thank you for standing by!',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final req = requests[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: req.isUrgent ? Colors.red.shade100 : Colors.blue.shade100,
                              child: Text(
                                req.bloodType,
                                style: TextStyle(
                                  color: req.isUrgent ? Colors.red : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              '${req.unitsRequired} Units Required - ${req.patientName}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Location: ${req.hospitalName}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: req.isUrgent ? Colors.red.shade50 : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                req.urgency,
                                style: TextStyle(
                                  color: req.isUrgent ? Colors.red : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            onTap: () {
                              context.push('/request/details', extra: req);
                            },
                          ),
                        );
                      },
                    );
                  },
                  error: (err, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 50, color: Colors.red),
                        const SizedBox(height: 12),
                        Text('Failed to sync requests: $err'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => ref.read(bloodRequestControllerProvider.notifier).fetchOpenRequests(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
