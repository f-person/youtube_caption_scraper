/// The HTTP client used for getting video info from YouTube.
abstract class YouTubeCaptionScraperHttpClient {
  Future<YouTubeCaptionScraperHttpResponse> get(Uri url);
}

/// Response returned by functions of [YouTubeCaptionScraperHttpClient].
class YouTubeCaptionScraperHttpResponse {
  YouTubeCaptionScraperHttpResponse({
    required this.body,
    required this.statusCode,
  });

  final String body;
  final int statusCode;
}
