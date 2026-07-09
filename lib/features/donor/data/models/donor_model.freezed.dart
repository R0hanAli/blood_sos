// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'donor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DonorModel _$DonorModelFromJson(Map<String, dynamic> json) {
  return _DonorModel.fromJson(json);
}

/// @nodoc
mixin _$DonorModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get bloodGroup => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  bool get medicalEligibility => throw _privateConstructorUsedError;
  String? get lastDonationDate => throw _privateConstructorUsedError;
  bool get availabilityStatus => throw _privateConstructorUsedError;
  String? get profilePhoto => throw _privateConstructorUsedError;
  int get donationCount => throw _privateConstructorUsedError;
  String? get nextEligibleDate => throw _privateConstructorUsedError;
  double? get distance => throw _privateConstructorUsedError;

  /// Serializes this DonorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DonorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DonorModelCopyWith<DonorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DonorModelCopyWith<$Res> {
  factory $DonorModelCopyWith(
    DonorModel value,
    $Res Function(DonorModel) then,
  ) = _$DonorModelCopyWithImpl<$Res, DonorModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String fullName,
    String phone,
    String bloodGroup,
    int age,
    String gender,
    double weight,
    String city,
    double latitude,
    double longitude,
    bool medicalEligibility,
    String? lastDonationDate,
    bool availabilityStatus,
    String? profilePhoto,
    int donationCount,
    String? nextEligibleDate,
    double? distance,
  });
}

/// @nodoc
class _$DonorModelCopyWithImpl<$Res, $Val extends DonorModel>
    implements $DonorModelCopyWith<$Res> {
  _$DonorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DonorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fullName = null,
    Object? phone = null,
    Object? bloodGroup = null,
    Object? age = null,
    Object? gender = null,
    Object? weight = null,
    Object? city = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? medicalEligibility = null,
    Object? lastDonationDate = freezed,
    Object? availabilityStatus = null,
    Object? profilePhoto = freezed,
    Object? donationCount = null,
    Object? nextEligibleDate = freezed,
    Object? distance = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            bloodGroup: null == bloodGroup
                ? _value.bloodGroup
                : bloodGroup // ignore: cast_nullable_to_non_nullable
                      as String,
            age: null == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int,
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            medicalEligibility: null == medicalEligibility
                ? _value.medicalEligibility
                : medicalEligibility // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastDonationDate: freezed == lastDonationDate
                ? _value.lastDonationDate
                : lastDonationDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            availabilityStatus: null == availabilityStatus
                ? _value.availabilityStatus
                : availabilityStatus // ignore: cast_nullable_to_non_nullable
                      as bool,
            profilePhoto: freezed == profilePhoto
                ? _value.profilePhoto
                : profilePhoto // ignore: cast_nullable_to_non_nullable
                      as String?,
            donationCount: null == donationCount
                ? _value.donationCount
                : donationCount // ignore: cast_nullable_to_non_nullable
                      as int,
            nextEligibleDate: freezed == nextEligibleDate
                ? _value.nextEligibleDate
                : nextEligibleDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            distance: freezed == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DonorModelImplCopyWith<$Res>
    implements $DonorModelCopyWith<$Res> {
  factory _$$DonorModelImplCopyWith(
    _$DonorModelImpl value,
    $Res Function(_$DonorModelImpl) then,
  ) = __$$DonorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String fullName,
    String phone,
    String bloodGroup,
    int age,
    String gender,
    double weight,
    String city,
    double latitude,
    double longitude,
    bool medicalEligibility,
    String? lastDonationDate,
    bool availabilityStatus,
    String? profilePhoto,
    int donationCount,
    String? nextEligibleDate,
    double? distance,
  });
}

/// @nodoc
class __$$DonorModelImplCopyWithImpl<$Res>
    extends _$DonorModelCopyWithImpl<$Res, _$DonorModelImpl>
    implements _$$DonorModelImplCopyWith<$Res> {
  __$$DonorModelImplCopyWithImpl(
    _$DonorModelImpl _value,
    $Res Function(_$DonorModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DonorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fullName = null,
    Object? phone = null,
    Object? bloodGroup = null,
    Object? age = null,
    Object? gender = null,
    Object? weight = null,
    Object? city = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? medicalEligibility = null,
    Object? lastDonationDate = freezed,
    Object? availabilityStatus = null,
    Object? profilePhoto = freezed,
    Object? donationCount = null,
    Object? nextEligibleDate = freezed,
    Object? distance = freezed,
  }) {
    return _then(
      _$DonorModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        bloodGroup: null == bloodGroup
            ? _value.bloodGroup
            : bloodGroup // ignore: cast_nullable_to_non_nullable
                  as String,
        age: null == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        medicalEligibility: null == medicalEligibility
            ? _value.medicalEligibility
            : medicalEligibility // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastDonationDate: freezed == lastDonationDate
            ? _value.lastDonationDate
            : lastDonationDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        availabilityStatus: null == availabilityStatus
            ? _value.availabilityStatus
            : availabilityStatus // ignore: cast_nullable_to_non_nullable
                  as bool,
        profilePhoto: freezed == profilePhoto
            ? _value.profilePhoto
            : profilePhoto // ignore: cast_nullable_to_non_nullable
                  as String?,
        donationCount: null == donationCount
            ? _value.donationCount
            : donationCount // ignore: cast_nullable_to_non_nullable
                  as int,
        nextEligibleDate: freezed == nextEligibleDate
            ? _value.nextEligibleDate
            : nextEligibleDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        distance: freezed == distance
            ? _value.distance
            : distance // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DonorModelImpl implements _DonorModel {
  const _$DonorModelImpl({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.bloodGroup,
    required this.age,
    required this.gender,
    required this.weight,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.medicalEligibility,
    this.lastDonationDate,
    required this.availabilityStatus,
    this.profilePhoto,
    required this.donationCount,
    this.nextEligibleDate,
    this.distance,
  });

  factory _$DonorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DonorModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String bloodGroup;
  @override
  final int age;
  @override
  final String gender;
  @override
  final double weight;
  @override
  final String city;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final bool medicalEligibility;
  @override
  final String? lastDonationDate;
  @override
  final bool availabilityStatus;
  @override
  final String? profilePhoto;
  @override
  final int donationCount;
  @override
  final String? nextEligibleDate;
  @override
  final double? distance;

  @override
  String toString() {
    return 'DonorModel(id: $id, userId: $userId, fullName: $fullName, phone: $phone, bloodGroup: $bloodGroup, age: $age, gender: $gender, weight: $weight, city: $city, latitude: $latitude, longitude: $longitude, medicalEligibility: $medicalEligibility, lastDonationDate: $lastDonationDate, availabilityStatus: $availabilityStatus, profilePhoto: $profilePhoto, donationCount: $donationCount, nextEligibleDate: $nextEligibleDate, distance: $distance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DonorModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.bloodGroup, bloodGroup) ||
                other.bloodGroup == bloodGroup) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.medicalEligibility, medicalEligibility) ||
                other.medicalEligibility == medicalEligibility) &&
            (identical(other.lastDonationDate, lastDonationDate) ||
                other.lastDonationDate == lastDonationDate) &&
            (identical(other.availabilityStatus, availabilityStatus) ||
                other.availabilityStatus == availabilityStatus) &&
            (identical(other.profilePhoto, profilePhoto) ||
                other.profilePhoto == profilePhoto) &&
            (identical(other.donationCount, donationCount) ||
                other.donationCount == donationCount) &&
            (identical(other.nextEligibleDate, nextEligibleDate) ||
                other.nextEligibleDate == nextEligibleDate) &&
            (identical(other.distance, distance) ||
                other.distance == distance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    fullName,
    phone,
    bloodGroup,
    age,
    gender,
    weight,
    city,
    latitude,
    longitude,
    medicalEligibility,
    lastDonationDate,
    availabilityStatus,
    profilePhoto,
    donationCount,
    nextEligibleDate,
    distance,
  );

  /// Create a copy of DonorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DonorModelImplCopyWith<_$DonorModelImpl> get copyWith =>
      __$$DonorModelImplCopyWithImpl<_$DonorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DonorModelImplToJson(this);
  }
}

abstract class _DonorModel implements DonorModel {
  const factory _DonorModel({
    required final String id,
    required final String userId,
    required final String fullName,
    required final String phone,
    required final String bloodGroup,
    required final int age,
    required final String gender,
    required final double weight,
    required final String city,
    required final double latitude,
    required final double longitude,
    required final bool medicalEligibility,
    final String? lastDonationDate,
    required final bool availabilityStatus,
    final String? profilePhoto,
    required final int donationCount,
    final String? nextEligibleDate,
    final double? distance,
  }) = _$DonorModelImpl;

  factory _DonorModel.fromJson(Map<String, dynamic> json) =
      _$DonorModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get fullName;
  @override
  String get phone;
  @override
  String get bloodGroup;
  @override
  int get age;
  @override
  String get gender;
  @override
  double get weight;
  @override
  String get city;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  bool get medicalEligibility;
  @override
  String? get lastDonationDate;
  @override
  bool get availabilityStatus;
  @override
  String? get profilePhoto;
  @override
  int get donationCount;
  @override
  String? get nextEligibleDate;
  @override
  double? get distance;

  /// Create a copy of DonorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DonorModelImplCopyWith<_$DonorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
