import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/blood_request_entity.dart';

part 'blood_request_model.freezed.dart';
part 'blood_request_model.g.dart';

@freezed
class BloodRequestModel with _$BloodRequestModel {
  const factory BloodRequestModel({
    required String id,
    required String patientName,
    required String hospitalName,
    required String bloodType,
    required int unitsRequired,
    required double latitude,
    required double longitude,
    required String patientPhone,
    required String urgency,
    required String status,
    required String createdById,
    required String createdAt,
    String? acceptedById,
    String? acceptedAt,
  }) = _BloodRequestModel;

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) => _$BloodRequestModelFromJson(json);
}

extension BloodRequestModelX on BloodRequestModel {
  BloodRequestEntity toEntity() {
    return BloodRequestEntity(
      id: id,
      patientName: patientName,
      hospitalName: hospitalName,
      bloodType: bloodType,
      unitsRequired: unitsRequired,
      latitude: latitude,
      longitude: longitude,
      patientPhone: patientPhone,
      urgency: urgency,
      status: status,
      createdById: createdById,
      createdAt: DateTime.parse(createdAt),
      acceptedById: acceptedById,
      acceptedAt: acceptedAt != null ? DateTime.tryParse(acceptedAt!) : null,
    );
  }
}
