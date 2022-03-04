abstract class YouTubeCaptionScraperHttpClient {
  Future<YouTubeCaptionScraperHttpResponse> get(Uri url);
}

class YouTubeCaptionScraperHttpResponse {
  YouTubeCaptionScraperHttpResponse({
    required this.body,
    required this.statusCode,
  });

  final String body;
  final int statusCode;
}
