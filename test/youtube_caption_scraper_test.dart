import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';

import 'mock_http_client.dart';
import 'test_data.dart';

void main() {
  final mockClient = MockHttpClient(
    (request) async {
      if (request.url.toString() == pageUrl) {
        return Response(
          pageResponse,
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        );
      } else if (request.url.toString() ==
          expectedCaptionTracks.first.baseUrl) {
        return Response(
          subtitlesResponse,
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        );
      } else {
        throw Exception('url not registered');
      }
    },
  );

  test(
    '`getCaptionTracks` parses caption tracks correctly',
    () async {
      final scraper = YouTubeCaptionScraper(
        httpClient: mockClient,
      );

      final captions = await scraper.getCaptionTracks(pageUrl);

      expect(captions, expectedCaptionTracks);
    },
  );

  test(
    '`getSubtitles` parses subtitles correctly',
    () async {
      final scraper = YouTubeCaptionScraper(httpClient: mockClient);
      final captions = await scraper.getCaptionTracks(pageUrl);
      final subtitles = await scraper.getSubtitles(captions.first);

      expect(
        subtitles.first,
        SubtitleLine(
          start: const Duration(milliseconds: 8),
          duration: const Duration(seconds: 6, milliseconds: 48),
          text: 'September 8th was my last day at Google, \n'
              'after 13 years of working for this company.  ',
        ),
      );

      expect(
        subtitles[6],
        SubtitleLine(
          start: const Duration(seconds: 37, milliseconds: 68),
          duration: const Duration(seconds: 1, milliseconds: 36),
          text: "they didn't know Google.",
        ),
      );

      expect(
        subtitles.last,
        SubtitleLine(
          start: const Duration(minutes: 6, seconds: 8, milliseconds: 16),
          duration: const Duration(seconds: 6, milliseconds: 16),
          text: "I'll see you around.",
        ),
      );
    },
  );
}
