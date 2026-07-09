import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/donation_entity.dart';

part 'donation_model.freezed.dart';
part 'donation_model.g.dart';

@freezed
class DonationModel with _$DonationModel {
  const factory DonationModel({
    required String id,
    required String donorId,
    required String donorName,
    required String bloodType,
    required int units,
    required String hospitalId,
    required String hospitalName,
    required String patientName,
    required String date,
    required String certificateCode,
    required String status,
  }) = _DonationModel;

  factory DonationModel.fromJson(Map<String, dynamic> json) => _$DonationModelFromJson(json);
}

extension DonationModelX on DonationModel {
  DonationEntity toEntity() {
    return DonationEntity(
      id: id,
      donorId: donorId,
      donorName: donorName,
      bloodType: bloodType,
      units: units,
      hospitalId: hospitalId,
      hospitalName: hospitalName,
      patientName: patientName,
      date: DateTime.parse(date),
      certificateCode: certificateCode,
      status: status,
    );
  }
}
