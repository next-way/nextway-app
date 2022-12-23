import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  const Profile({
    required this.username,
    required this.email,
    required this.fullName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  final String username;
  final String email;
  @JsonKey(name: "full_name")
  final String fullName;
}
