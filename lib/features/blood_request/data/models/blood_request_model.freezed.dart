// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blood_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BloodRequestModel _$BloodRequestModelFromJson(Map<String, dynamic> json) {
  return _BloodRequestModel.fromJson(json);
}

/// @nodoc
mixin _$BloodRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get patientName => throw _privateConstructorUsedError;
  String get hospitalName => throw _privateConstructorUsedError;
  String get bloodType => throw _privateConstructorUsedError;
  int get unitsRequired => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get patientPhone => throw _privateConstructorUsedError;
  String get urgency => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get createdById => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get acceptedById => throw _privateConstructorUsedError;
  String? get acceptedAt => throw _privateConstructorUsedError;

  /// Serializes this BloodRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BloodRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BloodRequestModelCopyWith<BloodRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BloodRequestModelCopyWith<$Res> {
  factory $BloodRequestModelCopyWith(
    BloodRequestModel value,
    $Res Function(BloodRequestModel) then,
  ) = _$BloodRequestModelCopyWithImpl<$Res, BloodRequestModel>;
  @useResult
  $Res call({
    String id,
    String patientName,
    String hospitalName,
    String bloodType,
    int unitsRequired,
    double latitude,
    double longitude,
    String patientPhone,
    String urgency,
    String status,
    String createdById,
    String createdAt,
    String? acceptedById,
    String? acceptedAt,
  });
}

/// @nodoc
class _$BloodRequestModelCopyWithImpl<$Res, $Val extends BloodRequestModel>
    implements $BloodRequestModelCopyWith<$Res> {
  _$BloodRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BloodRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientName = null,
    Object? hospitalName = null,
    Object? bloodType = null,
    Object? unitsRequired = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? patientPhone = null,
    Object? urgency = null,
    Object? status = null,
    Object? createdById = null,
    Object? createdAt = null,
    Object? acceptedById = freezed,
    Object? acceptedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            patientName: null == patientName
                ? _value.patientName
                : patientName // ignore: cast_nullable_to_non_nullable
                      as String,
            hospitalName: null == hospitalName
                ? _value.hospitalName
                : hospitalName // ignore: cast_nullable_to_non_nullable
                      as String,
            bloodType: null == bloodType
                ? _value.bloodType
                : bloodType // ignore: cast_nullable_to_non_nullable
                      as String,
            unitsRequired: null == unitsRequired
                ? _value.unitsRequired
                : unitsRequired // ignore: cast_nullable_to_non_nullable
                      as int,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            patientPhone: null == patientPhone
                ? _value.patientPhone
                : patientPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            urgency: null == urgency
                ? _value.urgency
                : urgency // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdById: null == createdById
                ? _value.createdById
                : createdById // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            acceptedById: freezed == acceptedById
                ? _value.acceptedById
                : acceptedById // ignore: cast_nullable_to_non_nullable
                      as String?,
            acceptedAt: freezed == acceptedAt
                ? _value.acceptedAt
                : acceptedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BloodRequestModelImplCopyWith<$Res>
    implements $BloodRequestModelCopyWith<$Res> {
  factory _$$BloodRequestModelImplCopyWith(
    _$BloodRequestModelImpl value,
    $Res Function(_$BloodRequestModelImpl) then,
  ) = __$$BloodRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String patientName,
    String hospitalName,
    String bloodType,
    int unitsRequired,
    double latitude,
    double longitude,
    String patientPhone,
    String urgency,
    String status,
    String createdById,
    String createdAt,
    String? acceptedById,
    String? acceptedAt,
  });
}

/// @nodoc
class __$$BloodRequestModelImplCopyWithImpl<$Res>
    extends _$BloodRequestModelCopyWithImpl<$Res, _$BloodRequestModelImpl>
    implements _$$BloodRequestModelImplCopyWith<$Res> {
  __$$BloodRequestModelImplCopyWithImpl(
    _$BloodRequestModelImpl _value,
    $Res Function(_$BloodRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BloodRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientName = null,
    Object? hospitalName = null,
    Object? bloodType = null,
    Object? unitsRequired = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? patientPhone = null,
    Object? urgency = null,
    Object? status = null,
    Object? createdById = null,
    Object? createdAt = null,
    Object? acceptedById = freezed,
    Object? acceptedAt = freezed,
  }) {
    return _then(
      _$BloodRequestModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        patientName: null == patientName
            ? _value.patientName
            : patientName // ignore: cast_nullable_to_non_nullable
                  as String,
        hospitalName: null == hospitalName
            ? _value.hospitalName
            : hospitalName // ignore: cast_nullable_to_non_nullable
                  as String,
        bloodType: null == bloodType
            ? _value.bloodType
            : bloodType // ignore: cast_nullable_to_non_nullable
                  as String,
        unitsRequired: null == unitsRequired
            ? _value.unitsRequired
            : unitsRequired // ignore: cast_nullable_to_non_nullable
                  as int,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        patientPhone: null == patientPhone
            ? _value.patientPhone
            : patientPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        urgency: null == urgency
            ? _value.urgency
            : urgency // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdById: null == createdById
            ? _value.createdById
            : createdById // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        acceptedById: freezed == acceptedById
            ? _value.acceptedById
            : acceptedById // ignore: cast_nullable_to_non_nullable
                  as String?,
        acceptedAt: freezed == acceptedAt
            ? _value.acceptedAt
            : acceptedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BloodRequestModelImpl implements _BloodRequestModel {
  const _$BloodRequestModelImpl({
    required this.id,
    required this.patientName,
    required this.hospitalName,
    required this.bloodType,
    required this.unitsRequired,
    required this.latitude,
    required this.longitude,
    required this.patientPhone,
    required this.urgency,
    required this.status,
    required this.createdById,
    required this.createdAt,
    this.acceptedById,
    this.acceptedAt,
  });

  factory _$BloodRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BloodRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String patientName;
  @override
  final String hospitalName;
  @override
  final String bloodType;
  @override
  final int unitsRequired;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String patientPhone;
  @override
  final String urgency;
  @override
  final String status;
  @override
  final String createdById;
  @override
  final String createdAt;
  @override
  final String? acceptedById;
  @override
  final String? acceptedAt;

  @override
  String toString() {
    return 'BloodRequestModel(id: $id, patientName: $patientName, hospitalName: $hospitalName, bloodType: $bloodType, unitsRequired: $unitsRequired, latitude: $latitude, longitude: $longitude, patientPhone: $patientPhone, urgency: $urgency, status: $status, createdById: $createdById, createdAt: $createdAt, acceptedById: $acceptedById, acceptedAt: $acceptedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BloodRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.hospitalName, hospitalName) ||
                other.hospitalName == hospitalName) &&
            (identical(other.bloodType, bloodType) ||
                other.bloodType == bloodType) &&
            (identical(other.unitsRequired, unitsRequired) ||
                other.unitsRequired == unitsRequired) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.patientPhone, patientPhone) ||
                other.patientPhone == patientPhone) &&
            (identical(other.urgency, urgency) || other.urgency == urgency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdById, createdById) ||
                other.createdById == createdById) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.acceptedById, acceptedById) ||
                other.acceptedById == acceptedById) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    patientName,
    hospitalName,
    bloodType,
    unitsRequired,
    latitude,
    longitude,
    patientPhone,
    urgency,
    status,
    createdById,
    createdAt,
    acceptedById,
    acceptedAt,
  );

  /// Create a copy of BloodRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BloodRequestModelImplCopyWith<_$BloodRequestModelImpl> get copyWith =>
      __$$BloodRequestModelImplCopyWithImpl<_$BloodRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BloodRequestModelImplToJson(this);
  }
}

abstract class _BloodRequestModel implements BloodRequestModel {
  const factory _BloodRequestModel({
    required final String id,
    required final String patientName,
    required final String hospitalName,
    required final String bloodType,
    required final int unitsRequired,
    required final double latitude,
    required final double longitude,
    required final String patientPhone,
    required final String urgency,
    required final String status,
    required final String createdById,
    required final String createdAt,
    final String? acceptedById,
    final String? acceptedAt,
  }) = _$BloodRequestModelImpl;

  factory _BloodRequestModel.fromJson(Map<String, dynamic> json) =
      _$BloodRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get patientName;
  @override
  String get hospitalName;
  @override
  String get bloodType;
  @override
  int get unitsRequired;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get patientPhone;
  @override
  String get urgency;
  @override
  String get status;
  @override
  String get createdById;
  @override
  String get createdAt;
  @override
  String? get acceptedById;
  @override
  String? get acceptedAt;

  /// Create a copy of BloodRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BloodRequestModelImplCopyWith<_$BloodRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
