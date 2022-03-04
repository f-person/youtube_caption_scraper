class SubtitleLine {
  SubtitleLine({
    required this.start,
    required this.duration,
    required this.text,
  });

  final Duration start;
  final Duration duration;
  final String text;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubtitleLine &&
        other.start == start &&
        other.duration == duration &&
        other.text == text;
  }

  @override
  int get hashCode => start.hashCode ^ duration.hashCode ^ text.hashCode;
}
