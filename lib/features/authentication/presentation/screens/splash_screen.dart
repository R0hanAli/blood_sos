import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkNavigation());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _checkNavigation() {
    final authState = ref.read(authControllerProvider);
    authState.when(
      data: (user) => _navigateToNext(user),
      error: (_, __) => context.go('/login'),
      loading: () {
        ref.listenManual(authControllerProvider, (previous, next) {
          next?.when(
            data: (user) => _navigateToNext(user),
            error: (_, __) => context.go('/login'),
            loading: () {},
          );
        });
      },
    );
  }

  void _navigateToNext(dynamic user) {
    if (user == null) {
      context.go('/onboarding');
    } else {
      final String role = user.role.key;
      switch (role) {
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
        default:
          context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryRed,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/logo.png',
                width: 140,
                height: 140,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.local_hospital_rounded,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'BloodSOS',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Smart Blood & Emergency Network',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 60),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
