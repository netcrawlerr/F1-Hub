import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:f1_hub/screens/news/widgets/news_card.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  void _launchUrl(BuildContext context) async {
    final Uri url = Uri.parse(widget.article.webUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open the article link.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.article.images.isNotEmpty)
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.article.images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final imageUrl = widget.article.images[index].url;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Image.asset(
                                    'assets/news-placeholder.png',
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.article.images.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                _currentImageIndex == index
                                    ? AppStyles.darkModeTextColor
                                    : AppStyles.darkModeTextColor.withOpacity(
                                      0.4,
                                    ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 16),

            Text(
              widget.article.headline,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: "F1",
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "By ${widget.article.byline}",
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontFamily: "F1",
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.article.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                fontFamily: "F1",
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => _launchUrl(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_outward_sharp,
                    size: 20,
                    color: Colors.red[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Open Web View',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "F1",
                      color: Colors.red[700],
                    ),
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
