/// Hold information about a single caption track of a YouTube video.
class CaptionTrack {
  const CaptionTrack({
    required this.baseUrl,
    required this.name,
    required this.languageCode,
    required this.kind,
  });

  /// Base URL of the caption track. This is used to get actual subtitles.
  final String baseUrl;

  /// The name of the caption track (e.g. `"English"`).
  final String name;

  /// The language code of the caption track.
  final String languageCode;

  /// The kind of the caption track. The kind of a caption track generated using automatic speech recognition will be 'asr'.
  final String kind;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CaptionTrack &&
        other.baseUrl == baseUrl &&
        other.name == name &&
        other.languageCode == languageCode &&
        other.kind == kind;
  }

  @override
  int get hashCode => baseUrl.hashCode ^ name.hashCode ^ languageCode.hashCode ^ kind.hashCode;

  @override
  String toString() =>
      'CaptionTrack(baseUrl: $baseUrl, name: $name, languageCode: $languageCode, kind: $kind)';
}
