import 'dart:convert';

import 'package:http/http.dart' as http;

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
}
