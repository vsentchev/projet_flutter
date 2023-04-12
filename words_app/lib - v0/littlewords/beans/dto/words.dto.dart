import 'package:json_annotation/json_annotation.dart';
import 'package:words_app/littlewords/beans/dto/word.dto.dart';

// part 'words.dto.g.dart';

@JsonSerializable()
class WordsDTO {
  WordsDTO(this.data);

  final List<WordDTO>? data;

  Map<String, dynamic> toJson() => _$WordsDTOToJson(this);

  factory WordsDTO.fromJson(Map<String, dynamic> json) =>
      _$WordsDTOFromJson(json);

  Map<String, dynamic> _$WordsDTOToJson(WordsDTO instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

  static WordsDTO _$WordsDTOFromJson(Map<String, dynamic> json) => WordsDTO(
        (json['data'] as List<dynamic>?)
            ?.map((e) => WordDTO.fromJson(e as Map<String, dynamic>))
            .toList(),
  );
}
