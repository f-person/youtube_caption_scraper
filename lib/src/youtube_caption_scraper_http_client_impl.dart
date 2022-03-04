import 'package:http/http.dart' as http;

import 'package:youtube_captions_scraper/src/youtube_caption_scraper_http_client.dart';

/// The default [http]-based implementation of [YouTubeCaptionScraperHttpClient].
class YouTubeCaptionScraperHttpClientImpl
    implements YouTubeCaptionScraperHttpClient {
  @override
  Future<YouTubeCaptionScraperHttpResponse> get(Uri url) async {
    final response = await http.get(url);
    return YouTubeCaptionScraperHttpResponse(
      body: response.body,
      statusCode: response.statusCode,
    );
  }
}
