import 'package:blood_sos/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:blood_sos/features/authentication/presentation/screens/login_screen.dart';
import 'package:blood_sos/features/authentication/presentation/screens/onboarding_screen.dart';
import 'package:blood_sos/features/authentication/presentation/screens/register_screen.dart';
import 'package:blood_sos/features/authentication/presentation/screens/splash_screen.dart';
import 'package:blood_sos/features/blood_request/domain/entities/blood_request_entity.dart';
import 'package:blood_sos/features/blood_request/presentation/screens/create_request_screen.dart';
import 'package:blood_sos/features/blood_request/presentation/screens/request_details_screen.dart';
import 'package:blood_sos/features/dashboard/presentation/screens/admin_dashboard_screen.dart';
import 'package:blood_sos/features/dashboard/presentation/screens/donor_dashboard_screen.dart';
import 'package:blood_sos/features/dashboard/presentation/screens/hospital_dashboard_screen.dart';
import 'package:blood_sos/features/dashboard/presentation/screens/patient_dashboard_screen.dart';
import 'package:blood_sos/features/donor/presentation/screens/edit_profile_screen.dart';
import 'package:blood_sos/features/donor/presentation/screens/eligibility_checker_screen.dart';
import 'package:blood_sos/features/donor/presentation/screens/profile_screen.dart';
import 'package:blood_sos/features/donor/presentation/screens/qr_card_screen.dart';
import 'package:blood_sos/features/donor/presentation/screens/search_donors_screen.dart';
import 'package:blood_sos/features/history/presentation/screens/donation_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/donor-dashboard',
        name: 'donor-dashboard',
        builder: (context, state) => const DonorDashboard(),
      ),
      GoRoute(
        path: '/patient-dashboard',
        name: 'patient-dashboard',
        builder: (context, state) => const PatientDashboard(),
      ),
      GoRoute(
        path: '/hospital-dashboard',
        name: 'hospital-dashboard',
        builder: (context, state) => const HospitalDashboard(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        name: 'admin-dashboard',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'profile-edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/qr-card',
        name: 'qr-card',
        builder: (context, state) => const QrCardScreen(),
      ),
      GoRoute(
        path: '/volunteer',
        name: 'volunteer',
        builder: (context, state) => const EligibilityCheckerScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search-donors',
        builder: (context, state) => const SearchDonorsScreen(),
      ),
      GoRoute(
        path: '/maps',
        name: 'maps',
        builder: (context, state) => const MapsScreen(),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const DonationHistoryScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/emergency-requests',
        name: 'emergency-requests',
        builder: (context, state) => const EmergencyRequestsScreen(),
      ),
      GoRoute(
        path: '/emergency-details/:id',
        name: 'emergency-details',
        builder: (context, state) {
          final requestId = state.pathParameters['id'] ?? '';
          return EmergencyDetailsScreen(requestId: requestId);
        },
      ),
      GoRoute(
        path: '/hospitals',
        name: 'hospitals',
        builder: (context, state) => const HospitalDirectoryScreen(),
      ),
      GoRoute(
        path: '/bloodbanks',
        name: 'bloodbanks',
        builder: (context, state) => const BloodBankDirectoryScreen(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/request/create',
        name: 'request-create',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return CreateRequestScreen(voiceSOSData: data);
        },
      ),
      GoRoute(
        path: '/request/details',
        name: 'request-details',
        builder: (context, state) {
          final request = state.extra as BloodRequestEntity;
          return RequestDetailsScreen(request: request);
        },
      ),
    ],
  );
});

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Maps Screen')));
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Notifications Screen')));
}

class EmergencyRequestsScreen extends StatelessWidget {
  const EmergencyRequestsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Emergency Requests Screen')));
}

class EmergencyDetailsScreen extends StatelessWidget {
  final String requestId;
  const EmergencyDetailsScreen({super.key, required this.requestId});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Emergency Details: $requestId')));
}

class HospitalDirectoryScreen extends StatelessWidget {
  const HospitalDirectoryScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Hospital Directory Screen')));
}

class BloodBankDirectoryScreen extends StatelessWidget {
  const BloodBankDirectoryScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Blood Bank Directory Screen')));
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('About Screen')));
}
