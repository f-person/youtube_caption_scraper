import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';

class CaptionTrackDto {
  const CaptionTrackDto({
    required this.baseUrl,
    required this.name,
    required this.languageCode,
  });

  factory CaptionTrackDto.fromJson(Map<String, dynamic> json) {
    return CaptionTrackDto(
      baseUrl: json['baseUrl'],
      name: json['name'] == null ? '' : json['name']['simpleText'],
      languageCode: json['languageCode'],
    );
  }

  final String baseUrl;
  final String name;
  final String languageCode;

  CaptionTrack toEntity() => CaptionTrack(
        baseUrl: baseUrl,
        name: name,
        languageCode: languageCode,
      );
}
