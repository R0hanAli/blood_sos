import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedRole = 'DONOR';

  String _selectedBloodGroup = 'O+';
  String _selectedGender = 'Male';
  final _ageController = TextEditingController(text: '25');
  final _weightController = TextEditingController(text: '70');
  final _cityController = TextEditingController();

  final _hospitalNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _licenseController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _cityController.dispose();
    _hospitalNameController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final extraDetails = <String, dynamic>{};

      if (_selectedRole == 'DONOR') {
        extraDetails['bloodGroup'] = _selectedBloodGroup;
        extraDetails['gender'] = _selectedGender;
        extraDetails['age'] = int.tryParse(_ageController.text) ?? 25;
        extraDetails['weight'] =
            double.tryParse(_weightController.text) ?? 70.0;
        extraDetails['city'] = _cityController.text.trim();

        extraDetails['latitude'] = 0.0;
        extraDetails['longitude'] = 0.0;
      } else if (_selectedRole == 'HOSPITAL') {
        extraDetails['hospitalName'] = _hospitalNameController.text.trim();
        extraDetails['address'] = _addressController.text.trim();
        extraDetails['licenseNumber'] = _licenseController.text.trim();
        extraDetails['latitude'] = 0.0;
        extraDetails['longitude'] = 0.0;
      } else if (_selectedRole == 'PATIENT') {
        extraDetails['address'] = _addressController.text.trim();
        extraDetails['latitude'] = 0.0;
        extraDetails['longitude'] = 0.0;
      }

      ref
          .read(authControllerProvider.notifier)
          .register(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            role: _selectedRole,
            fullName: _selectedRole == 'HOSPITAL'
                ? _hospitalNameController.text.trim()
                : _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            extraDetails: extraDetails,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen(authControllerProvider, (previous, next) {
      next?.when(
        data: (user) {
          if (user != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration completed successfully!'),
                backgroundColor: Colors.green,
              ),
            );

            switch (user.role.key) {
              case 'DONOR':
                context.go('/donor-dashboard');
                break;
              case 'PATIENT':
                context.go('/patient-dashboard');
                break;
              case 'HOSPITAL':
                context.go('/hospital-dashboard');
                break;
              case 'ADMIN':
                context.go('/admin-dashboard');
                break;
            }
          }
        },
        error: (err, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err.toString()),
              backgroundColor: Colors.redAccent,
            ),
          );
        },
        loading: () {},
      );
    });

    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Join the Network',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select your account type to register',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  initialValue: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Register As',
                    prefixIcon: Icon(Icons.people_alt_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'DONOR',
                      child: Text('Blood Donor'),
                    ),
                    DropdownMenuItem(
                      value: 'PATIENT',
                      child: Text('Patient / Recipient'),
                    ),
                    DropdownMenuItem(
                      value: 'HOSPITAL',
                      child: Text('Hospital / Clinic'),
                    ),
                  ],
                  onChanged: isLoading
                      ? null
                      : (val) {
                          if (val != null) {
                            setState(() {
                              _selectedRole = val;
                            });
                          }
                        },
                ),
                const SizedBox(height: 24),

                Text(
                  'Account Credentials',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter email.';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Enter a valid email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter password.';
                    if (value.length < 6)
                      return 'Must be at least 6 characters.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_reset_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Confirm password.';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                Text(
                  'Profile Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (_selectedRole != 'HOSPITAL') ...[
                  TextFormField(
                    controller: _nameController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter your name.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter phone.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                if (_selectedRole == 'DONOR') ...[
                  DropdownButtonFormField<String>(
                    initialValue: _selectedBloodGroup,
                    decoration: const InputDecoration(
                      labelText: 'Blood Group',
                      prefixIcon: Icon(Icons.opacity),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'A+', child: Text('A+')),
                      DropdownMenuItem(value: 'A-', child: Text('A-')),
                      DropdownMenuItem(value: 'B+', child: Text('B+')),
                      DropdownMenuItem(value: 'B-', child: Text('B-')),
                      DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                      DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                      DropdownMenuItem(value: 'O+', child: Text('O+')),
                      DropdownMenuItem(value: 'O-', child: Text('O-')),
                    ],
                    onChanged: (val) {
                      if (val != null)
                        setState(() => _selectedBloodGroup = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          enabled: !isLoading,
                          decoration: const InputDecoration(labelText: 'Age'),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.transgender_rounded),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedGender = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cityController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      prefixIcon: Icon(Icons.location_city_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                ],

                if (_selectedRole == 'HOSPITAL') ...[
                  TextFormField(
                    controller: _hospitalNameController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Hospital Name',
                      prefixIcon: Icon(Icons.local_hospital_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _licenseController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      labelText: 'License / Registration ID',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Hospital Address',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                ],

                if (_selectedRole == 'PATIENT') ...[
                  TextFormField(
                    controller: _addressController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Home / Delivery Address',
                      prefixIcon: Icon(Icons.home_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                ],

                const SizedBox(height: 36),
                ElevatedButton(
                  onPressed: isLoading ? null : _handleRegister,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Register Account'),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
