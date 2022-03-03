import 'package:http/http.dart' as http;
import 'package:youtube_captions_scraper/src/subtitle_line.dart';

import 'caption_track.dart';
import 'youtube_caption_scraper_impl.dart';

/// YouTube caption/subtitle scraper.
///
/// In order to get subtitles of a YouTube video, you first
/// need to get caption tracks via [getCaptionTracks],
/// and pass a caption track to [getSubtitles]:
///
/// ```dart
/// final captionScraper = YouTubeCaptionScraper();
///
/// final captionTracks = await captionScraper.getCaptionTracks('example-video-url');
/// final subtitles = await captionScraper.getSubtitles(captionTracks.first);
///
/// for (final subtitleLine in subtitles) {
///   print('${subtitleLine.start} - ${subtitleLine.duration} - ${subtitleLine.text}');
/// }
/// ```
abstract class YouTubeCaptionScraper {
  /// {@macro YouTubeCaptionScraperImpl}
  factory YouTubeCaptionScraper({
    http.Client? httpClient,
  }) {
    return YouTubeCaptionScraperImpl(httpClient: httpClient);
  }

  /// Gets caption tracks of the video on [videoUrl].
  Future<List<CaptionTrack>> getCaptionTracks(String videoUrl);

  /// Gets subtitles based on [captionTrack.baseUrl].
  ///
  /// You can get [captionTrack] by calling [getCaptionTracks] with
  /// the video URL you're interested in.
  Future<List<SubtitleLine>> getSubtitles(CaptionTrack captionTrack);
}
