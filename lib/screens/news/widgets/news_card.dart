import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Article {
  final int id;
  final String headline;
  final String description;
  final String published;
  final String webUrl;
  final List<ImageData> images;
  final String byline;

  Article({
    required this.id,
    required this.headline,
    required this.description,
    required this.published,
    required this.webUrl,
    required this.images,
    required this.byline,
  });
}

class ImageData {
  final String url;
  final String alt;

  ImageData({required this.url, required this.alt});
}

class NewsCard extends StatelessWidget {
  final Article article;
  final void Function()? onTap;

  const NewsCard({super.key, required this.article, this.onTap});

  @override
  Widget build(BuildContext context) {
    final DateTime publishedDate = DateTime.parse(article.published);
    final String formattedDate = timeago.format(publishedDate);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // img
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(
                article.images.isNotEmpty ? article.images[0].url : '',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Image.asset(
                      'assets/images/news-placeholder.png',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ),
            ),

            // content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.headline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: "F1",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                      fontFamily: "F1",
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final maxBylineWidth = constraints.maxWidth * 0.7;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: maxBylineWidth,
                            ),
                            child: Text(
                              article.byline,
                              softWrap: true,
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(
                                color: Colors.grey,
                                fontFamily: "F1",
                              ),
                            ),
                          ),

                          // f.date
                          Flexible(
                            child: Text(
                              formattedDate,
                              softWrap: true,
                              textAlign: TextAlign.right,
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(
                                color: Colors.grey,
                                fontFamily: "F1",
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
