import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/donor_profile_controller.dart';
import '../../../../core/theme/app_theme.dart';

class EligibilityCheckerScreen extends ConsumerStatefulWidget {
  const EligibilityCheckerScreen({super.key});

  @override
  ConsumerState<EligibilityCheckerScreen> createState() => _EligibilityCheckerScreenState();
}

class _EligibilityCheckerScreenState extends ConsumerState<EligibilityCheckerScreen> {
  bool _hasDiseases = false;
  bool _hasTattoosRecent = false;
  bool _hasTravelHistory = false;
  bool _hasMedications = false;
  bool _isLoading = false;

  Map<String, dynamic>? _result;

  void _runCheck() async {
    setState(() => _isLoading = true);
    try {
      final res = await ref.read(donorProfileControllerProvider.notifier).checkEligibility(
            hasDiseases: _hasDiseases,
            hasTattoosRecent: _hasTattoosRecent,
            hasTravelHistory: _hasTravelHistory,
            hasMedications: _hasMedications,
          );
      setState(() {
        _result = res;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eligibility check failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eligibility Checker'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_result == null) ...[
                Text(
                  'Quick Health Screening',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Answer these screening questions to evaluate your current donation eligibility.',
                  style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                ),
                const SizedBox(height: 28),

                
                _QuestionSwitch(
                  title: 'Chronic Diseases or Infections?',
                  subtitle: 'E.g., HIV, Hepatitis, active tuberculosis, heart conditions, or blood-borne illnesses.',
                  value: _hasDiseases,
                  onChanged: (val) => setState(() => _hasDiseases = val),
                  enabled: !_isLoading,
                ),
                const Divider(height: 24),

                
                _QuestionSwitch(
                  title: 'Recent Tattoos or Piercings?',
                  subtitle: 'Tattoos, body piercings, or acupuncture procedures performed within the last 6 months.',
                  value: _hasTattoosRecent,
                  onChanged: (val) => setState(() => _hasTattoosRecent = val),
                  enabled: !_isLoading,
                ),
                const Divider(height: 24),

                
                _QuestionSwitch(
                  title: 'Recent International Travel?',
                  subtitle: 'Travel outside the country or to malaria/dengue high-risk zones in the past 6 months.',
                  value: _hasTravelHistory,
                  onChanged: (val) => setState(() => _hasTravelHistory = val),
                  enabled: !_isLoading,
                ),
                const Divider(height: 24),

                
                _QuestionSwitch(
                  title: 'Active Heavy Medications?',
                  subtitle: 'Antibiotics or heavy prescription medications taken within the last 72 hours.',
                  value: _hasMedications,
                  onChanged: (val) => setState(() => _hasMedications = val),
                  enabled: !_isLoading,
                ),
                const Divider(height: 36),

                ElevatedButton(
                  onPressed: _isLoading ? null : _runCheck,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Evaluate Eligibility'),
                ),
              ] else ...[
                
                _buildResultsView(theme, isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsView(ThemeData theme, bool isDark) {
    final eligible = _result!['eligible'] as bool;
    final List reasons = _result!['reasons'] ?? [];

    return Column(
      children: [
        Icon(
          eligible ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
          size: 90,
          color: eligible ? Colors.green : AppTheme.primaryRed,
        ),
        const SizedBox(height: 24),
        Text(
          eligible ? 'You Are Eligible to Donate!' : 'You Are Temporarily Ineligible',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: eligible ? Colors.green : AppTheme.primaryRed,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            eligible
                ? 'Your health parameters conform to standard blood donation guidelines. You can register for donation camps or accept request alerts.'
                : 'Based on the screening answers, you cannot donate blood at this time. Please see detailed reasons below.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, height: 1.4),
          ),
        ),
        const SizedBox(height: 32),

        if (!eligible && reasons.isNotEmpty) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Detailed Reasons:',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Column(
              children: reasons
                  .map((reason) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.arrow_right, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                reason.toString(),
                                style: const TextStyle(height: 1.3, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 32),
        ],

        ElevatedButton(
          onPressed: () {
            setState(() {
              _result = null;
            });
          },
          child: const Text('Re-Evaluate / Clear'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back to Profile'),
        ),
      ],
    );
  }
}

class _QuestionSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const _QuestionSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
