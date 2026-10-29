import 'package:flutter/material.dart';

import '../../core/feature.dart';
import '../../core/launcher.dart';
import '../../core/widgets/future_view.dart';
import '../../core/widgets/state_views.dart';
import 'wordpress_service.dart';

final wordpressFeature = Feature(
  title: 'Noticias de WordPress',
  subtitle: 'Las últimas 3 publicaciones de un sitio',
  icon: Icons.newspaper,
  builder: (_) => const WordpressScreen(),
);

class WordpressScreen extends StatefulWidget {
  const WordpressScreen({super.key});

  @override
  State<WordpressScreen> createState() => _WordpressScreenState();
}

class _WordpressScreenState extends State<WordpressScreen> {
  late Future<WordpressFeed> _future = fetchWordpressFeed();

  void _reload() => setState(() => _future = fetchWordpressFeed());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias de WordPress')),
      body: FutureView<WordpressFeed>(
        future: _future,
        onRetry: _reload,
        builder: (context, feed) {
          if (feed.posts.isEmpty) {
            return const MessageView(
              icon: Icons.article_outlined,
              message: 'Este sitio no tiene publicaciones todavía.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SiteHeader(site: feed.site),
              const SizedBox(height: 16),
              for (final post in feed.posts) _PostCard(post: post),
            ],
          );
        },
      ),
    );
  }
}

class _SiteHeader extends StatelessWidget {
  const _SiteHeader({required this.site});

  final WordpressSite site;

  @override
  Widget build(BuildContext context) {
    final icon = site.iconUrl;
    const fallback = Icon(Icons.public, size: 56);
    return Row(
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: icon == null
              ? fallback
              : Image.network(
                  icon,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => fallback,
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            site.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final WordpressPost post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(post.summary, maxLines: 5, overflow: TextOverflow.ellipsis),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => openUrl(context, post.link),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Visitar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
