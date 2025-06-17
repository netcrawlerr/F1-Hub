class ImageData {
  final String url;
  final String alt;

  ImageData({required this.url, required this.alt});
}

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

  factory Article.fromJson(Map<String, dynamic> json) {
    final imagesJson = json['images'] as List<dynamic>? ?? [];
    final images =
        imagesJson
            .map(
              (img) => ImageData(url: img['url'] ?? '', alt: img['alt'] ?? ''),
            )
            .toList();

    return Article(
      id: json['id'] ?? 0,
      headline: json['headline'] ?? '',
      description: json['description'] ?? '',
      published: json['published'] ?? '',
      webUrl: json['webUrl'] ?? '',
      images: images,
      byline: json['byline'] ?? '',
    );
  }
}
