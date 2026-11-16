import '../../domain/entities/cast_member.dart';
import '../../network/api_config.dart';

class CastMemberModel {
  const CastMemberModel({
    required this.name,
    required this.character,
    required this.profilePath,
  });

  final String name;
  final String character;
  final String? profilePath;

  factory CastMemberModel.fromJson(Map<String, dynamic> json) =>
      CastMemberModel(
        name: (json['name'] as String?) ?? '',
        character: (json['character'] as String?) ?? '',
        profilePath: json['profile_path'] as String?,
      );

  CastMember toEntity() => CastMember(
    name: name,
    character: character,
    profileUrl: ApiConfig.profileUrl(profilePath),
  );
}
