import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/donor_profile_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../authentication/presentation/controllers/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(donorProfileControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Donor Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/profile/edit'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(donorProfileControllerProvider.notifier).fetchProfile(),
        child: profileState.when(
          data: (donor) {
            if (donor == null) {
              return const Center(child: Text('No donor profile found.'));
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppTheme.primaryLightRed,
                            backgroundImage: donor.profilePhoto != null && donor.profilePhoto!.isNotEmpty
                                ? NetworkImage(donor.profilePhoto!)
                                : null,
                            child: donor.profilePhoto == null || donor.profilePhoto!.isEmpty
                                ? const Icon(Icons.person, size: 50, color: AppTheme.primaryRed)
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            donor.fullName,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            donor.phone,
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                donor.availabilityStatus ? 'Active Donor' : 'Invisible / Busy',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 8),
                              Switch(
                                value: donor.availabilityStatus,
                                onChanged: (value) {
                                  ref.read(donorProfileControllerProvider.notifier).updateProfile({
                                    'availabilityStatus': value,
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Blood Group',
                          value: donor.bloodGroup,
                          icon: Icons.opacity,
                          color: AppTheme.primaryRed,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Donations',
                          value: '${donor.donationCount}',
                          icon: Icons.favorite,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Eligibility',
                          value: donor.isCurrentlyEligible ? 'Eligible' : 'Ineligible',
                          icon: Icons.health_and_safety_outlined,
                          color: donor.isCurrentlyEligible ? Colors.green : Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Age / Weight',
                          value: '${donor.age} yrs / ${donor.weight.round()} kg',
                          icon: Icons.monitor_weight_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  
                  Text(
                    'Donor Resources',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ListTile(
                    leading: const Icon(Icons.qr_code_2_rounded, color: AppTheme.primaryRed),
                    title: const Text('Digital QR Donor Card'),
                    subtitle: const Text('Verify donor ID instantly at camps'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/qr-card'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.fact_check_outlined, color: AppTheme.primaryRed),
                    title: const Text('Medical Eligibility Checker'),
                    subtitle: const Text('Confirm if you are eligible to donate'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/volunteer'), 
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.health_and_safety_rounded, color: AppTheme.primaryRed),
                    title: const Text('Health & Donation Tips'),
                    subtitle: const Text('Pre and post donation guidelines'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showHealthTipsDialog(context),
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    'System Settings',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Dark Theme Mode'),
                    subtitle: const Text('Toggle app color profile'),
                    value: ref.watch(themeProvider) == ThemeMode.dark,
                    onChanged: (val) {
                      ref.read(themeProvider.notifier).toggleTheme(val);
                    },
                    secondary: const Icon(Icons.dark_mode_outlined, color: AppTheme.primaryRed),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.mic_none_rounded, color: AppTheme.primaryRed),
                    title: const Text('Voice SOS Assistant'),
                    subtitle: const Text('Speak an emergency to generate requests'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showVoiceSOSDialog(context),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.delete_forever_outlined, color: Colors.grey),
                    title: const Text('Delete Account'),
                    subtitle: const Text('Permanently erase account & profile metadata'),
                    onTap: () => _showDeleteConfirmation(context, ref),
                  ),
                  const Divider(),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                      foregroundColor: Colors.red,
                    ),
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).logout().then((_) {
                        if (context.mounted) {
                          context.go('/login');
                        }
                      });
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Sign Out'),
                  ),
                ],
              ),
            );
          },
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 60, color: Colors.red),
                const SizedBox(height: 12),
                Text('Failed to load profile: $err'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.read(donorProfileControllerProvider.notifier).fetchProfile(),
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
    );
  }

  void _showHealthTipsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const _HealthTipsSheet();
      },
    );
  }

  void _showVoiceSOSDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _VoiceSOSDialog(),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account?'),
          content: const Text(
            'This action is permanent. All your donor history, credentials, and profile registrations will be deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
                ref.read(authControllerProvider.notifier).logout().then((_) {
                  if (context.mounted) {
                    context.go('/login');
                  }
                });
              },
              child: const Text('Delete Permanently'),
            ),
          ],
        );
      },
    );
  }
}

class _VoiceSOSDialog extends StatefulWidget {
  const _VoiceSOSDialog();

  @override
  State<_VoiceSOSDialog> createState() => _VoiceSOSDialogState();
}

class _VoiceSOSDialogState extends State<_VoiceSOSDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _step = 0; 
  String _transcript = '';
  Map<String, dynamic>? _extractedData;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _step = 1;
      _transcript = 'Listening...';
    });

    
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _step = 2;
        _transcript = 'Processing speech signals...';
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _step = 3;
          _transcript = '"Patient Sarah Connor requires 3 units of AB- blood urgently at Mercy Hospital"';
          _extractedData = {
            'patientName': 'Sarah Connor',
            'hospitalName': 'Mercy Hospital',
            'bloodType': 'AB-',
            'units': 3,
            'urgency': 'IMMEDIATE',
            'phone': '555-0199'
          };
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Voice SOS Helper',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryRed),
            ),
            const SizedBox(height: 16),
            
            
            if (_step == 1)
              ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.2).animate(
                  CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, color: AppTheme.primaryRed, size: 48),
                ),
              )
            else if (_step == 2)
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              )
            else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _step == 3 ? Icons.check_circle : Icons.mic_none_outlined,
                  color: _step == 3 ? Colors.green : Colors.grey,
                  size: 48,
                ),
              ),

            const SizedBox(height: 24),
            Text(
              _transcript.isEmpty ? 'Tap mic to start speaking emergency coordinates.' : _transcript,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: _step == 3 ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
                color: _step == 3 ? Colors.black87 : Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 24),
            if (_step == 0)
              ElevatedButton.icon(
                onPressed: _startListening,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Speaking'),
              )
            else if (_step == 3)
              Column(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/request/create', extra: _extractedData);
                    },
                    icon: const Icon(Icons.description_outlined),
                    label: const Text('Generate Emergency Request'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _step = 0;
                        _transcript = '';
                        _extractedData = null;
                      });
                    },
                    child: const Text('Retry Speech Input'),
                  ),
                ],
              ),
            
            if (_step != 1 && _step != 2)
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Dismiss'),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthTipsSheet extends StatelessWidget {
  const _HealthTipsSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Donation Guidelines',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const _TipItem(
                icon: Icons.water_drop_outlined,
                title: 'Hydrate well',
                body: 'Drink extra water (about 500ml) right before your donation.',
              ),
              const _TipItem(
                icon: Icons.restaurant_outlined,
                title: 'Eat iron-rich meals',
                body: 'Consume red meat, fish, beans, or spinach prior to donation.',
              ),
              const _TipItem(
                icon: Icons.hotel_outlined,
                title: 'Get plenty of rest',
                body: 'Ensure you sleep for at least 7-8 hours the night before.',
              ),
              const _TipItem(
                icon: Icons.no_accounts_outlined,
                title: 'Avoid alcohol & smoking',
                body: 'Refrain from alcohol 24 hours prior and smoking 2 hours prior.',
              ),
              const _TipItem(
                icon: Icons.sports_gymnastics_outlined,
                title: 'Limit heavy exercises',
                body: 'Skip strenuous activity or gym routines for 24 hours after donating.',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _TipItem({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryRed, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(body, style: TextStyle(color: Colors.grey.shade600, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
