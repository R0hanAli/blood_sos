// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DonorModelImpl _$$DonorModelImplFromJson(Map<String, dynamic> json) =>
    _$DonorModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      bloodGroup: json['bloodGroup'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      weight: (json['weight'] as num).toDouble(),
      city: json['city'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      medicalEligibility: json['medicalEligibility'] as bool,
      lastDonationDate: json['lastDonationDate'] as String?,
      availabilityStatus: json['availabilityStatus'] as bool,
      profilePhoto: json['profilePhoto'] as String?,
      donationCount: (json['donationCount'] as num).toInt(),
      nextEligibleDate: json['nextEligibleDate'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$DonorModelImplToJson(_$DonorModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'bloodGroup': instance.bloodGroup,
      'age': instance.age,
      'gender': instance.gender,
      'weight': instance.weight,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'medicalEligibility': instance.medicalEligibility,
      'lastDonationDate': instance.lastDonationDate,
      'availabilityStatus': instance.availabilityStatus,
      'profilePhoto': instance.profilePhoto,
      'donationCount': instance.donationCount,
      'nextEligibleDate': instance.nextEligibleDate,
      'distance': instance.distance,
    };
