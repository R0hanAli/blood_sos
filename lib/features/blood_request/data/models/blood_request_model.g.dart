// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BloodRequestModelImpl _$$BloodRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$BloodRequestModelImpl(
  id: json['id'] as String,
  patientName: json['patientName'] as String,
  hospitalName: json['hospitalName'] as String,
  bloodType: json['bloodType'] as String,
  unitsRequired: (json['unitsRequired'] as num).toInt(),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  patientPhone: json['patientPhone'] as String,
  urgency: json['urgency'] as String,
  status: json['status'] as String,
  createdById: json['createdById'] as String,
  createdAt: json['createdAt'] as String,
  acceptedById: json['acceptedById'] as String?,
  acceptedAt: json['acceptedAt'] as String?,
);

Map<String, dynamic> _$$BloodRequestModelImplToJson(
  _$BloodRequestModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'patientName': instance.patientName,
  'hospitalName': instance.hospitalName,
  'bloodType': instance.bloodType,
  'unitsRequired': instance.unitsRequired,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'patientPhone': instance.patientPhone,
  'urgency': instance.urgency,
  'status': instance.status,
  'createdById': instance.createdById,
  'createdAt': instance.createdAt,
  'acceptedById': instance.acceptedById,
  'acceptedAt': instance.acceptedAt,
};
