/// Hold information about a single caption track of a YouTube video.
class CaptionTrack {
  const CaptionTrack({
    required this.baseUrl,
    required this.name,
    required this.languageCode,
  });

  /// Base URL of the caption track. This is used to get actual subtitles.
  final String baseUrl;

  /// The name of the caption track (e.g. `"English"`).
  final String name;

  /// The language code of the caption track.
  final String languageCode;

  factory CaptionTrack.fromJson(Map<String, dynamic> json) {
    return CaptionTrack(
      baseUrl: json['baseUrl'],
      name: json['name'] == null ? '' : json['name']['simpleText'],
      languageCode: json['languageCode'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CaptionTrack &&
        other.baseUrl == baseUrl &&
        other.name == name &&
        other.languageCode == languageCode;
  }

  @override
  int get hashCode => baseUrl.hashCode ^ name.hashCode ^ languageCode.hashCode;

  @override
  String toString() =>
      'CaptionTrack(baseUrl: $baseUrl, name: $name, languageCode: $languageCode)';
}
