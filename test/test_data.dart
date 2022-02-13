import 'dart:io';

const pageUrl = 'https://www.youtube.com/watch?v=4KXePjjdoF0';
Future<String> pageResponse() {
  return File('test/page_response.html').readAsString();
}
