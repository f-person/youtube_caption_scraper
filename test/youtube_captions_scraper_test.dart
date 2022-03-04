import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

import 'package:youtube_captions_scraper/youtube_captions_scraper.dart';

import 'mock_http_client.dart';
import 'test_data.dart';

void main() {
  final mockClient = MockHttpClient(
    (request) async {
      if (request.url.toString() == pageUrl) {
        return Response(pageResponse, 200, headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        });
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
      expect(captions.length, equals(2));
      expect(captions[0].name, equals('English'));
      expect(captions[0].languageCode, equals('en'));

      expect(captions[1].name, equals('English (auto-generated)'));
      expect(captions[1].languageCode, equals('en'));
    },
  );
}
