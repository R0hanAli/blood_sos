import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/donor_entity.dart';

part 'donor_model.freezed.dart';
part 'donor_model.g.dart';

@freezed
class DonorModel with _$DonorModel {
  const factory DonorModel({
    required String id,
    required String userId,
    required String fullName,
    required String phone,
    required String bloodGroup,
    required int age,
    required String gender,
    required double weight,
    required String city,
    required double latitude,
    required double longitude,
    required bool medicalEligibility,
    String? lastDonationDate,
    required bool availabilityStatus,
    String? profilePhoto,
    required int donationCount,
    String? nextEligibleDate,
    double? distance,
  }) = _DonorModel;

  factory DonorModel.fromJson(Map<String, dynamic> json) => _$DonorModelFromJson(json);
}

extension DonorModelX on DonorModel {
  DonorEntity toEntity() {
    return DonorEntity(
      id: id,
      userId: userId,
      fullName: fullName,
      phone: phone,
      bloodGroup: bloodGroup,
      age: age,
      gender: gender,
      weight: weight,
      city: city,
      latitude: latitude,
      longitude: longitude,
      medicalEligibility: medicalEligibility,
      lastDonationDate: lastDonationDate != null ? DateTime.tryParse(lastDonationDate!) : null,
      availabilityStatus: availabilityStatus,
      profilePhoto: profilePhoto,
      donationCount: donationCount,
      nextEligibleDate: nextEligibleDate != null ? DateTime.tryParse(nextEligibleDate!) : null,
      distance: distance,
    );
  }
}
