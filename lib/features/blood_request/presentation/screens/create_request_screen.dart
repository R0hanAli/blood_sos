import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/blood_request_controller.dart';
import '../../../../core/theme/app_theme.dart';

class CreateRequestScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? voiceSOSData;
  const CreateRequestScreen({super.key, this.voiceSOSData});

  @override
  ConsumerState<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends ConsumerState<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _patientNameController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _unitsController = TextEditingController(text: '1');
  
  String _selectedBloodType = 'A+';
  String _selectedUrgency = 'NORMAL';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.voiceSOSData != null) {
      _patientNameController.text = widget.voiceSOSData!['patientName'] ?? '';
      _hospitalNameController.text = widget.voiceSOSData!['hospitalName'] ?? '';
      _phoneController.text = widget.voiceSOSData!['phone'] ?? '';
      _unitsController.text = widget.voiceSOSData!['units']?.toString() ?? '1';
      if (widget.voiceSOSData!['bloodType'] != null) {
        _selectedBloodType = widget.voiceSOSData!['bloodType'];
      }
      if (widget.voiceSOSData!['urgency'] != null) {
        _selectedUrgency = widget.voiceSOSData!['urgency'];
      }
    }
  }

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _urgencies = ['NORMAL', 'URGENT', 'IMMEDIATE'];

  @override
  void dispose() {
    _patientNameController.dispose();
    _hospitalNameController.dispose();
    _phoneController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  void _submitRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        
        double latitude = 42.3601;
        double longitude = -71.0589;

        await ref.read(bloodRequestControllerProvider.notifier).createRequest({
          'patientName': _patientNameController.text.trim(),
          'hospitalName': _hospitalNameController.text.trim(),
          'bloodType': _selectedBloodType,
          'unitsRequired': int.tryParse(_unitsController.text) ?? 1,
          'patientPhone': _phoneController.text.trim(),
          'urgency': _selectedUrgency,
          'latitude': latitude,
          'longitude': longitude,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Emergency blood request broadcast successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to post request: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Emergency Request'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Request Details',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Provide patient details and specify the urgency levels. This request will be instantly broadcast to all local eligible donors.',
                  style: TextStyle(color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _patientNameController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Patient Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Patient name is required.' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _hospitalNameController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Hospital Name / Location',
                    prefixIcon: Icon(Icons.local_hospital_outlined),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Hospital location is required.' : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedBloodType,
                        decoration: const InputDecoration(labelText: 'Blood Type'),
                        items: _bloodTypes.map((type) {
                          return DropdownMenuItem(value: type, child: Text(type));
                        }).toList(),
                        onChanged: _isLoading ? null : (val) {
                          if (val != null) setState(() => _selectedBloodType = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _unitsController,
                        keyboardType: TextInputType.number,
                        enabled: !_isLoading,
                        decoration: const InputDecoration(labelText: 'Units Needed'),
                        validator: (val) {
                          final num = int.tryParse(val ?? '');
                          if (num == null || num <= 0) return 'Must be >= 1';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Contact Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Contact number is required.' : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _selectedUrgency,
                  decoration: const InputDecoration(labelText: 'Urgency Priority'),
                  items: _urgencies.map((urg) {
                    return DropdownMenuItem(value: urg, child: Text(urg));
                  }).toList(),
                  onChanged: _isLoading ? null : (val) {
                    if (val != null) setState(() => _selectedUrgency = val);
                  },
                ),
                const SizedBox(height: 36),

                ElevatedButton(
                  onPressed: _isLoading ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedUrgency == 'IMMEDIATE' 
                        ? const Color(0xFFC62828) 
                        : AppTheme.primaryRed,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Broadcast Emergency Request'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
