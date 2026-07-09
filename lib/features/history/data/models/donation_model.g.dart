// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DonationModelImpl _$$DonationModelImplFromJson(Map<String, dynamic> json) =>
    _$DonationModelImpl(
      id: json['id'] as String,
      donorId: json['donorId'] as String,
      donorName: json['donorName'] as String,
      bloodType: json['bloodType'] as String,
      units: (json['units'] as num).toInt(),
      hospitalId: json['hospitalId'] as String,
      hospitalName: json['hospitalName'] as String,
      patientName: json['patientName'] as String,
      date: json['date'] as String,
      certificateCode: json['certificateCode'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$DonationModelImplToJson(_$DonationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'donorId': instance.donorId,
      'donorName': instance.donorName,
      'bloodType': instance.bloodType,
      'units': instance.units,
      'hospitalId': instance.hospitalId,
      'hospitalName': instance.hospitalName,
      'patientName': instance.patientName,
      'date': instance.date,
      'certificateCode': instance.certificateCode,
      'status': instance.status,
    };
