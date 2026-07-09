enum UserRole {
  donor,
  patient,
  hospital,
  admin;

  String get key => toString().split('.').last.toUpperCase();

  static UserRole fromString(String val) {
    switch (val.toUpperCase()) {
      case 'DONOR':
        return UserRole.donor;
      case 'PATIENT':
        return UserRole.patient;
      case 'HOSPITAL':
        return UserRole.hospital;
      case 'ADMIN':
        return UserRole.admin;
      default:
        return UserRole.donor;
    }
  }
}
