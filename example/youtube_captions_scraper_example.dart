import 'package:youtube_captions_scraper/youtube_captions_scraper.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1) {
    throw Exception('Incorrect usage.');
  }

  final videoUrl = arguments[0];

  final captionScraper = YouTubeCaptionScraper();
  final captionTracks = await captionScraper.getCaptionTracks(videoUrl);
  print(
    captionTracks.map(
      (c) => '${c.name} - ${c.languageCode} - ${c.baseUrl}',
    ),
  );
  print(captionTracks.length);
}
