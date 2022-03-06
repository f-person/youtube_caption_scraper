[![codecov](https://codecov.io/gh/f-person/youtube_caption_scraper/branch/master/graph/badge.svg)](https://codecov.io/gh/f-person/youtube_caption_scraper)
[![Pub version](https://img.shields.io/pub/v/youtube_caption_scraper?logo=flutter&style=plastic)](https://pub.dev/packages/youtube_caption_scraper)

A Dart package that parses lyrics from YouTube. No authentication is required.

## Usage
```dart
// Instantiate the scraper.
final captionScraper = YouTubeCaptionScraper(); 

// Fetch caption tracks – these are objects containing info like
// base url for the caption track and language code.
final captionTracks = await captionScraper.getCaptionTracks('video-url');

// Fetch the subtitles by providing it with a `CaptionTrack`
// from `getCaptionTracks`.
final subtitles = await captionScraper.getSubtitles(captionTracks[0]);

// Use the subtitles however you want.
for (final subtitle in subtitles) {
  print('${subtitle.start} - ${subtitle.duration} - ${subtitle.text}');
}
```

For more info see
[example](https://github.com/f-person/youtube_captions_scraper/blob/master/example/youtube_caption_scraper_example.dart)
or check the
[API reference](https://pub.dev/documentation/youtube_caption_scraper/latest/).

## Credits
The package is heavily inspired by
[algolia/youtube-captions-scraper](https://github.com/algolia/youtube-captions-scraper).
