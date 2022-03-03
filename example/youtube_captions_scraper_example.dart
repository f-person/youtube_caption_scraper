import 'package:youtube_captions_scraper/youtube_captions_scraper.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1) {
    throw Exception('Incorrect usage.');
  }

  final videoUrl = arguments[0];

  final captionScraper = YouTubeCaptionScraper();
  final captionTracks = await captionScraper.getCaptionTracks(videoUrl);

  final subtitles = await captionScraper.getSubtitles(captionTracks[0]);
  for (final subtitle in subtitles) {
    print(
      '${_formatDuration(subtitle.start)} - '
      '${_formatDuration(subtitle.duration)} - '
      '${subtitle.text}',
    );
  }
}

String _formatDuration(Duration duration) {
  return '${duration.inHours}:'
      '${duration.inMinutes.remainder(60)}:'
      '${duration.inSeconds.remainder(60)}:'
      '${duration.inMilliseconds.remainder(60)}';
}
