import 'user_role.dart';

class UserEntity {
  final String uid;
  final String email;
  final UserRole role;
  final String status;
  final Map<String, dynamic>? profile;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.role,
    required this.status,
    this.profile,
  });

  bool get isDonor => role == UserRole.donor;
  bool get isPatient => role == UserRole.patient;
  bool get isHospital => role == UserRole.hospital;
  bool get isAdmin => role == UserRole.admin;
}
