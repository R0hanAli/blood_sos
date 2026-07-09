import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/donation_history_controller.dart';
import '../../../donor/presentation/controllers/donor_profile_controller.dart';
import '../../../../core/theme/app_theme.dart';

class DonationHistoryScreen extends ConsumerWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(donationHistoryControllerProvider);
    final donorState = ref.watch(donorProfileControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Donations Timeline'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(donationHistoryControllerProvider.notifier).fetchHistory();
            ref.read(donorProfileControllerProvider.notifier).fetchProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                donorState.when(
                  data: (donor) {
                    if (donor == null) return const SizedBox();

                    final days = donor.daysUntilEligible;
                    if (days <= 0) {
                      return Card(
                        color: Colors.green.shade50,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green.shade200),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 28),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ready for Donation',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                                    ),
                                    SizedBox(height: 2),
                                    Text('You have no active cooldown restrictions and are eligible to save lives.'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    
                    final double progress = (90 - days) / 90.0;
                    return Card(
                      color: isDark ? const Color(0xFF2C1919) : Colors.red.shade50,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: isDark ? Colors.red.shade900 : Colors.red.shade200),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.hourglass_bottom_rounded, color: AppTheme.primaryRed, size: 26),
                                    SizedBox(width: 8),
                                    Text(
                                      'Cooldown Period Active',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ],
                                ),
                                Text(
                                  '$days Days Left',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryRed,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              color: AppTheme.primaryRed,
                              backgroundColor: Colors.grey.shade300,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Standard blood donations require a 90-day recovery cooldown between procedures to preserve red cell counts.',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  error: (_, __) => const SizedBox(),
                  loading: () => const Center(child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )),
                ),
                const SizedBox(height: 24),

                Text(
                  'Donation History',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                
                historyState.when(
                  data: (history) {
                    if (history.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          children: [
                            Icon(Icons.volunteer_activism_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            const Text(
                              'No donations logged yet.',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'When you donate at an affiliate center, your records and digital certifications will appear here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final donation = history[index];
                        final formattedDate = DateFormat('dd MMM yyyy').format(donation.date);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 22),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${donation.units} Units Given',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Center: ${donation.hospitalName}',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Recipient: ${donation.patientName}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const Divider(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      donation.certificateCode,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _showCertificate(context, donation),
                                      icon: const Icon(Icons.workspace_premium_outlined, size: 18),
                                      label: const Text('Certificate'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (err, _) => Center(child: Text('Error loading history: $err')),
                  loading: () => const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCertificate(BuildContext context, dynamic donation) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: AppTheme.primaryRed,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'CERTIFICATE OF APPRECIATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: AppTheme.primaryRed,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'BloodSOS Donation Network',
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 32),
                
                const Text(
                  'THIS IS CRITICALLY DECLARED TO VERIFY THAT',
                  style: TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  donation.donorName.toString().toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                ),
                const SizedBox(height: 12),
                
                Text(
                  'has successfully donated ${donation.units} units of critical blood type [${donation.bloodType}] on ${DateFormat('dd MMMM yyyy').format(donation.date)} at ${donation.hospitalName}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, height: 1.45),
                ),
                const SizedBox(height: 24),

                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border.all(color: Colors.green.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        donation.certificateCode,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
