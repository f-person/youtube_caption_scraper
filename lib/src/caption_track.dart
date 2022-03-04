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
}
