import 'package:http/testing.dart';
import 'package:youtube_caption_scraper/src/youtube_caption_scraper_http_client.dart';

class MockHttpClient implements YouTubeCaptionScraperHttpClient {
  MockHttpClient(this.clientHandler);

  final MockClientHandler clientHandler;

  late final _httpClient = MockClient(clientHandler);

  @override
  Future<YouTubeCaptionScraperHttpResponse> get(Uri url) async {
    final response = await _httpClient.get(url);
    return YouTubeCaptionScraperHttpResponse(
      body: response.body,
      statusCode: response.statusCode,
    );
  }
}
