import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';

class CaptionTrackDto {
  const CaptionTrackDto({
    required this.baseUrl,
    required this.name,
    required this.languageCode,
    required this.kind,
  });

  factory CaptionTrackDto.fromJson(Map<String, dynamic> json) {
    return CaptionTrackDto(
      baseUrl: json['baseUrl'],
      name: json['name'] == null ? '' : json['name']['simpleText'],
      languageCode: json['languageCode'],
      kind: json['kind'] == null ? '' : json['kind'],
    );
  }

  final String baseUrl;
  final String name;
  final String languageCode;
  final String kind;

  CaptionTrack toEntity() => CaptionTrack(
        baseUrl: baseUrl,
        name: name,
        languageCode: languageCode,
        kind: kind,
      );
}
