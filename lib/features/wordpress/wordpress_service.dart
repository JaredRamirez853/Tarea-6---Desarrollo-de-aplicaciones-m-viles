import '../../core/api_client.dart';
import '../../core/text_utils.dart';

/// Sitio WordPress que consume la app. Cambia esta URL para usar otro.
/// API: <sitio>/wp-json/wp/v2/posts
const wordpressSiteUrl = 'https://wordpress.org/news';

class WordpressSite {
  const WordpressSite({required this.name, required this.iconUrl});

  final String name;
  final String? iconUrl;
}

class WordpressPost {
  const WordpressPost({
    required this.title,
    required this.summary,
    required this.link,
  });

  final String title;
  final String summary;
  final String link;
}

class WordpressFeed {
  const WordpressFeed({required this.site, required this.posts});

  final WordpressSite site;
  final List<WordpressPost> posts;
}

Future<WordpressFeed> fetchWordpressFeed() async {
  final results = await Future.wait([
    getJson(Uri.parse('$wordpressSiteUrl/wp-json/')),
    getJson(
      Uri.parse('$wordpressSiteUrl/wp-json/wp/v2/posts').replace(
        queryParameters: {'per_page': '3', '_fields': 'link,title,excerpt'},
      ),
    ),
  ]);

  final siteJson = results[0] as Map<String, dynamic>;
  final icon = siteJson['site_icon_url'] as String?;
  final site = WordpressSite(
    name: siteJson['name'] as String? ?? 'Sitio WordPress',
    iconUrl: (icon == null || icon.isEmpty) ? null : icon,
  );

  final posts = (results[1] as List).map((item) {
    final json = item as Map<String, dynamic>;
    return WordpressPost(
      title: htmlToText((json['title'] as Map<String, dynamic>)['rendered'] as String),
      summary:
          htmlToText((json['excerpt'] as Map<String, dynamic>)['rendered'] as String),
      link: json['link'] as String,
    );
  }).toList();

  return WordpressFeed(site: site, posts: posts);
}
