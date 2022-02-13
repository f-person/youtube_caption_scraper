class CaptionTrack {
  const CaptionTrack({
    required this.baseUrl,
    required this.name,
    required this.languageCode,
  });

  final String baseUrl;
  final String name;
  final String languageCode;

  factory CaptionTrack.fromJson(Map<String, dynamic> json) {
    return CaptionTrack(
      baseUrl: json['baseUrl'],
      name: json['name'] == null ? '' : json['name']['simpleText'],
      languageCode: json['languageCode'],
    );
  }
}
