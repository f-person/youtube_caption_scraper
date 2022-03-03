import 'dart:convert';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:youtube_captions_scraper/src/subtitle_line.dart';

import 'caption_track.dart';

class YouTubeCaptionScraper {
  YouTubeCaptionScraper({
    /// An optional [http.Client].
    /// Used for replacing the default [http.Client].
    ///
    /// This is useful when using a proxy or mocking the client for testing.
    http.Client? httpClient,
  }) {
    _httpClient = httpClient ?? http.Client();
  }

  late final http.Client _httpClient;

  /// Returns a list of [CaptionTrack]s parsed from [videoUrl].
  Future<List<CaptionTrack>> getCaptionTracks(String videoUrl) async {
    final response = await _httpClient.get(Uri.parse(videoUrl));
    final data = response.body;

    final hasCaptionTracks = data.contains('captionTracks');
    if (!hasCaptionTracks) {
      throw Exception('Could not find captions for video: $videoUrl');
    }

    final regex = RegExp(
      r'({"captionTracks":.*isTranslatable":(true|false)}])',
    );
    final match = regex.firstMatch(data);
    if (match == null) {
      throw Exception('No matches found');
    }
    final matchedData = data.substring(match.start, match.end);
    final json = jsonDecode('$matchedData}');

    return [
      for (final captionTrackJson in json['captionTracks'])
        CaptionTrack.fromJson(captionTrackJson)
    ];
  }

  Future<List<SubtitleLine>> getSubtitles(CaptionTrack captionTrack) async {
    final response = await _httpClient.get(Uri.parse(captionTrack.baseUrl));
    final lines = response.body
        .replaceFirst('<?xml version="1.0" encoding="utf-8" ?><transcript>', '')
        .replaceFirst('</transcript>', '')
        .split('</text>')
        .where((line) => line.trim().isNotEmpty)
        .map(_convertRawLineToSubtitle);

    return lines.toList();
  }

  SubtitleLine _convertRawLineToSubtitle(String line) {
    final startRegex = RegExp(r'start="([\d.]+)"');
    final durationRegex = RegExp(r'dur="([\d.]+)"');

    final startString = startRegex.firstMatch(line)!.group(1)!;
    final durationString = durationRegex.firstMatch(line)!.group(1)!;
    final start = _parseDuration(startString);
    final duration = _parseDuration(durationString);

    final htmlText = line
        .replaceAll(r'<text.+>', '')
        .replaceAll(r'/&amp;/gi', '&')
        .replaceAll(r'/<\/?[^>]+(>|$)/g', '');

    final text = _stripHtmlTags(htmlText)!;

    return SubtitleLine(
      start: start,
      duration: duration,
      text: text,
    );
  }

  Duration _parseDuration(String rawDuration) {
    final parts = rawDuration.split('.');
    final seconds = int.parse(parts[0]);
    final milliseconds = parts.length < 2 ? 0 : int.parse(parts[1]);

    return Duration(seconds: seconds, milliseconds: milliseconds);
  }

  String? _stripHtmlTags(String html) {
    final document = parse(html);
    final bodyText = document.body?.text;
    if (bodyText == null) {
      return null;
    }
    final strippedText = parse(bodyText).documentElement?.text;

    return strippedText;
  }
}
