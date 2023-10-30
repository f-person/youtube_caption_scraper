import 'dart:convert';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:youtube_caption_scraper/src/exceptions.dart';
import 'package:youtube_caption_scraper/src/youtube_caption_scraper_http_client.dart';
import 'package:youtube_caption_scraper/src/youtube_caption_scraper_http_client_impl.dart';

import 'dtos.dart';
import 'youtube_caption_scraper.dart';
import 'caption_track.dart';
import 'subtitle_line.dart';

class YouTubeCaptionScraperImpl implements YouTubeCaptionScraper {
  /// {@template YouTubeCaptionScraperImpl}
  /// The default implementation of [YouTubeCaptionScraper].
  ///
  /// [httpClient] is used for performing HTTP operations. The default value
  /// is [YouTubeCaptionScraperHttpClientImpl] which uses [http.Client].
  /// This can be useful when using a proxy or using a different implementation
  /// for the HTTP requests (e.g. Dio).
  /// {@endtemplate}
  YouTubeCaptionScraperImpl({
    YouTubeCaptionScraperHttpClient? httpClient,
  }) {
    _httpClient = httpClient ?? YouTubeCaptionScraperHttpClientImpl();
  }

  late final YouTubeCaptionScraperHttpClient _httpClient;

  @override
  Future<List<CaptionTrack>> getCaptionTracks(String videoUrl) async {
    final response = await _httpClient.get(Uri.parse(videoUrl));
    if (response.statusCode == 404) {
      throw const VideoNotFound();
    }

    final data = response.body;
    final hasCaptionTracks = data.contains('captionTracks');
    if (!hasCaptionTracks) {
      throw const CaptionTracksNotFound();
    } else {
      return _parseCaptionTracks(data);
    }
  }

  List<CaptionTrack> _parseCaptionTracks(String responseBody) {
    const trailingString = ',"audioTracks"';
    final regex = RegExp(
      '("captionTracks":.*}]$trailingString)',
    );
    final match = regex.firstMatch(responseBody)!;
    final matchedData =
        responseBody.substring(match.start, match.end - trailingString.length);
    final json = jsonDecode('{$matchedData}');

    final List captionTracks = json['captionTracks'];
    return List.generate(
      captionTracks.length,
      (index) => CaptionTrackDto.fromJson(captionTracks[index]).toEntity(),
    );
  }

  @override
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

    /// Force unwrapping because [startString] and [durationString] should
    /// always be there.
    final startString = startRegex.firstMatch(line)!.group(1)!;
    final durationString = durationRegex.firstMatch(line)!.group(1)!;

    final start = _parseDuration(startString);
    final duration = _parseDuration(durationString);

    final htmlText = line
        .replaceAll(r'<text.+>', '')
        .replaceAll(r'/&amp;/gi', '&')
        .replaceAll(r'/<\/?[^>]+(>|$)/g', '');

    final text = _stripHtmlTags(htmlText);

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

  String _stripHtmlTags(String html) {
    final document = parse(html);
    final bodyText = document.body!.text;
    final strippedText = parse(bodyText).documentElement!.text;

    return strippedText;
  }
}
