import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({super.key});

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  final ScrollController _scrollController = ScrollController();
  List<NewsArticle> _articles = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchArticles();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = MediaQuery.of(context).size.height * 0.2; // 20% of screen height

    if (maxScroll - currentScroll <= delta && !_isLoading && _hasMore) {
      _fetchMoreArticles();
    }
  }

  Future<void> _fetchArticles({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _articles.clear();
        _hasError = false;
        _hasMore = true;
      });
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final articles = await NewsService.fetchArticles(
        page: _currentPage,
        perPage: 6,
      );

      if (mounted) {
        setState(() {
          if (refresh) {
            _articles = articles;
          } else {
            _articles.addAll(articles);
          }
          _hasMore = articles.length == 6; // If we got less than 6, no more pages
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchMoreArticles() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _currentPage++;
    });

    await _fetchArticles();
  }

  Future<void> _refresh() async {
    await _fetchArticles(refresh: true);
  }

  Future<void> _launchURL(String urlStr) async {
    try {
      // Clean the URL string by removing any trailing whitespace or "browser" text
      final cleanedUrlStr = urlStr.trim().replaceAll(RegExp(r'\s+browser\s*$'), '');
      final uri = Uri.parse(cleanedUrlStr);
      
      // Validate scheme to prevent launching potentially harmful URLs
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        throw Exception('Invalid URL scheme: ${uri.scheme}');
      }

      if (!uri.hasAbsolutePath || uri.path.isEmpty) { // Basic check for a path
         throw Exception('URL has no valid path');
      }
      
      debugPrint('Attempting to launch URL: $uri');

      final canLaunch = await canLaunchUrl(uri);
      debugPrint('Can launch URL ($uri): $canLaunch');
      
      if (canLaunch) {
        final result = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        debugPrint('Launch URL result for $uri: $result');
        
        if (!result) {
          throw Exception('Failed to launch URL after canLaunch returned true. Result: $result');
        }
      } else {
        // Provide a more detailed error message when canLaunch fails
        String errorDetails = 'Could not launch URL';
        if (cleanedUrlStr.isEmpty) {
            errorDetails += ': URL is empty.';
        } else if (!uri.hasScheme || !['http', 'https'].contains(uri.scheme)) {
            errorDetails += ': Invalid scheme (${uri.scheme}). Only http/https are supported by default.';
        } else if (uri.host.isEmpty) {
            errorDetails += ': Host is missing.';
        } else {
            // Try to give a generic reason if we can't pinpoint it.
            // This might be due to a lack of an app to handle the specific host/scheme combination,
            // or other OS-level restrictions.
            errorDetails += '. No application found to handle this URL (scheme: ${uri.scheme}, host: ${uri.host}).';
        }
        throw Exception(errorDetails);
      }
    } catch (e, stackTrace) {
      String message = 'Error launching article';
      if (e is FormatException) {
        message = 'Invalid URL format: $urlStr';
      } else if (e.toString().contains('Invalid URL scheme')) {
        message = e.toString(); // Use the specific scheme error
      } else if (e.toString().contains('URL has no valid path')) {
        message = e.toString(); // Use the specific path error
      }
       else {
         // Catch-all for other exceptions, providing more context.
          message = 'Could not launch article: ${e.toString()}. URL: $urlStr';
      }

      debugPrint('Launch URL Error: $message\nStack Trace: $stackTrace'); 

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Genset News',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_articles.isNotEmpty)
                TextButton(
                  onPressed: _refresh,
                  child: const Text(
                    'Refresh',
                    style: TextStyle(
                      color: Color(0xFF7B1FA2),
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Content
        if (_hasError)
          _buildErrorWidget()
        else if (_articles.isEmpty && !_isLoading)
          _buildEmptyWidget()
        else
          _buildNewsList(),

        // Loading indicator at bottom
        if (_isLoading && _articles.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7B1FA2),
              ),
            ),
          ),

        // No more articles indicator
        if (!_hasMore && _articles.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'No more articles',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNewsList() {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.7;
    
    return Container(
      constraints: BoxConstraints(
        minHeight: 300,
        maxHeight: maxHeight > 300 ? maxHeight : 300,
      ),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Sticky header
          SliverPersistentHeader(
            pinned: true,
            delegate: _NewsHeaderDelegate(
              articleCount: _articles.length,
              onViewAll: () {
                // TODO: Navigate to full news page
              },
            ),
          ),
          // News list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Show loading indicator at the beginning
                if (index == 0 && _isLoading && _articles.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(
                        color: Color(0xFF7B1FA2),
                      ),
                    ),
                  );
                }

                // Calculate actual article index
                final articleIndex = _isLoading && _articles.isEmpty ? index - 1 : index;
                
                if (articleIndex >= _articles.length) return const SizedBox.shrink();

                final article = _articles[articleIndex];
                return _buildArticleCard(article);
              },
              childCount: _articles.length + (_isLoading && _articles.isEmpty ? 1 : 0),
            ),
          ),
          // Loading indicator at bottom
          if (_isLoading && _articles.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF7B1FA2),
                  ),
                ),
              ),
            ),
          // No more articles indicator
          if (!_hasMore && _articles.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No more articles',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(NewsArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to article detail page
          _showArticleDetail(article);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: article.featuredMedia != null
                      ? CachedNetworkImage(
                          imageUrl: article.featuredMedia!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.article,
                          color: Colors.grey,
                          size: 30,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Article content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Excerpt
                    Text(
                      article.shortExcerpt,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Date and categories
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          article.date,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (article.categories.isNotEmpty)
                          Expanded(
                            child: Wrap(
                              spacing: 4,
                              children: article.categories.take(2).map((category) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7B1FA2).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Color(0xFF7B1FA2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'Failed to load news',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B1FA2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No articles available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for the latest news',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showArticleDetail(NewsArticle article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // All content inside Expanded will be scrollable
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.featuredMedia != null)
                        CachedNetworkImage(
                          imageUrl: article.featuredMedia!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 40),
                          ),
                        ),
                      if (article.featuredMedia != null)
                        const SizedBox(height: 16), // Spacing below image
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Meta info
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            article.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            article.authorName ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Content
                      Text(
                        article.content.isNotEmpty ? article.content : article.excerpt,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // Read more button (outside Expanded, so it stays at the bottom)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _launchURL(article.link);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B1FA2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Read Full Article'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int articleCount;
  final VoidCallback onViewAll;

  _NewsHeaderDelegate({
    required this.articleCount,
    required this.onViewAll,
  });

  // Calculated height based on content (padding + text line heights)
  // Vertical padding: 8+8 = 16
  // Text 'X articles' approx. 12 logical pixels, 'View All' approx. 14 logical pixels.
  // Row with mainAxisAlignment.spaceBetween centers them vertically within available space.
  // Total is slightly less than 50 (e.g., ~48-49). Using 49.0 for both min and max extent.
  @override
  double get minExtent => 49.0;

  @override
  double get maxExtent => 49.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$articleCount articles',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            child: const Text(
              'View All',
              style: TextStyle(
                color: Color(0xFF7B1FA2),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_NewsHeaderDelegate oldDelegate) {
    return articleCount != oldDelegate.articleCount;
  }
}
