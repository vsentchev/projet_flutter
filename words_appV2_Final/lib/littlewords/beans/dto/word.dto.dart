import 'package:json_annotation/json_annotation.dart';

// part 'word.dto.g.dart';

@JsonSerializable()
class WordDTO{

  WordDTO(this.uid, this.author, this.content, this.latitude, this.longitude);

  final int? uid;
  final String? author;
  final String? content;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => _$WordDTOToJson(this);

  factory WordDTO.fromJson(Map<String, dynamic> json) => _$WordDTOFromJson(json);

  static fromResultSet(Map<String, dynamic> map) => WordDTO.fromJson(map);


  Map<String, dynamic> _$WordDTOToJson(WordDTO instance) => <String, dynamic>{
      'uid': instance.uid,
      'author': instance.author,
      'content': instance.content,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

  static WordDTO _$WordDTOFromJson(Map<String, dynamic> json) => WordDTO(
        json['uid'] as int?,
        json['author'] as String?,
        json['content'] as String?,
        (json['latitude'] as double).toDouble(),
        (json['longitude'] as double).toDouble(),
    );
}