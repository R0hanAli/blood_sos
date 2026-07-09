import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/blood_request_controller.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../../../../features/authentication/presentation/controllers/auth_controller.dart';
import '../../../../core/theme/app_theme.dart';

class RequestDetailsScreen extends ConsumerStatefulWidget {
  final BloodRequestEntity request;

  const RequestDetailsScreen({
    super.key,
    required this.request,
  });

  @override
  ConsumerState<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends ConsumerState<RequestDetailsScreen> {
  bool _isLoading = false;

  void _acceptRequest() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(bloodRequestControllerProvider.notifier).acceptRequest(widget.request.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request accepted successfully! Contact coordinates shared.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _updateStatus(String status) async {
    setState(() => _isLoading = true);
    try {
      await ref.read(bloodRequestControllerProvider.notifier).updateStatus(widget.request.id, status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request marked as $status.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
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
    final userState = ref.watch(authControllerProvider);
    final user = userState.value;
    
    final isCreator = user != null && widget.request.createdById == user.uid;
    final isAcceptedDonor = user != null && widget.request.acceptedById == user.uid;
    
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(widget.request.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Badge(
                    text: widget.request.urgency,
                    color: widget.request.urgency == 'NORMAL' 
                        ? Colors.blue 
                        : widget.request.urgency == 'URGENT' 
                            ? Colors.orange 
                            : Colors.red,
                  ),
                  _Badge(
                    text: widget.request.status,
                    color: widget.request.status == 'OPEN' 
                        ? Colors.green 
                        : widget.request.status == 'IN_PROGRESS' 
                            ? Colors.amber 
                            : Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.opacity, color: AppTheme.primaryRed, size: 36),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.request.unitsRequired} Units Required',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Blood Type: ${widget.request.bloodType}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.primaryRed,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _DetailRow(
                        icon: Icons.person_outline,
                        label: 'Patient Name',
                        value: widget.request.patientName,
                      ),
                      const SizedBox(height: 16),
                      _DetailRow(
                        icon: Icons.local_hospital_outlined,
                        label: 'Hospital',
                        value: widget.request.hospitalName,
                      ),
                      const SizedBox(height: 16),
                      _DetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Requested At',
                        value: formattedDate,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              
              if (isCreator || isAcceptedDonor) ...[
                Card(
                  color: Colors.green.shade50,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green.shade200),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.phone, color: Colors.green, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'Contact Information',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          icon: Icons.call,
                          label: 'Patient Contact',
                          value: widget.request.patientPhone,
                          textColor: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.map_outlined, size: 40, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Location: ${widget.request.latitude.toStringAsFixed(4)}, ${widget.request.longitude.toStringAsFixed(4)}',
                        style: const TextStyle(color: Colors.grey, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              
              if (_isLoading) ...[
                const Center(child: CircularProgressIndicator())
              ] else ...[
                
                if (widget.request.isOpen && user != null && user.isDonor) ...[
                  ElevatedButton.icon(
                    onPressed: _acceptRequest,
                    icon: const Icon(Icons.volunteer_activism_outlined),
                    label: const Text('Accept Emergency Request'),
                  ),
                ],

                
                if (widget.request.isInProgress && (isCreator || isAcceptedDonor)) ...[
                  ElevatedButton.icon(
                    onPressed: () => _updateStatus('COMPLETED'),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Mark Donation Completed'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _updateStatus('CANCELLED'),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancel Request'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppTheme.primaryRed),
                  ),
                ],

                
                if (widget.request.isOpen && isCreator) ...[
                  OutlinedButton.icon(
                    onPressed: () => _updateStatus('CANCELLED'),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancel Emergency Request'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppTheme.primaryRed),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? textColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor ?? Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
