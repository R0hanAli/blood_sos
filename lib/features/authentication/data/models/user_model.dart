import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    required String role,
    required String status,
    Map<String, dynamic>? profile,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      role: UserRole.fromString(role),
      status: status,
      profile: profile,
    );
  }
}
