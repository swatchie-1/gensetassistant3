class NewsArticle {
  final int id;
  final String title;
  final String excerpt;
  final String content;
  final String date;
  final String link;
  final String? featuredMedia;
  final String? authorName;
  final List<String> categories;

  NewsArticle({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.date,
    required this.link,
    this.featuredMedia,
    this.authorName,
    required this.categories,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    // Clean HTML tags from title and excerpt
    String cleanTitle = _removeHtmlTags(json['title']['rendered'] ?? '');
    String cleanExcerpt = _removeHtmlTags(json['excerpt']['rendered'] ?? '');
    String cleanContent = _removeHtmlTags(json['content']['rendered'] ?? '');
    
    // Parse date
    String dateStr = json['date'] ?? '';
    DateTime parsedDate = DateTime.tryParse(dateStr) ?? DateTime.now();
    String formattedDate = _formatDate(parsedDate);

    // Extract categories
    List<int> categoryIds = List<int>.from(json['categories'] ?? []);
    List<String> categoryNames = categoryIds.map((id) => _getCategoryName(id)).toList();

    // Extract featured image URL from embedded media
    String? featuredImageUrl;
    if (json['_embedded'] != null && 
        json['_embedded']['wp:featuredmedia'] != null && 
        json['_embedded']['wp:featuredmedia'].isNotEmpty) {
      var featuredMedia = json['_embedded']['wp:featuredmedia'][0];
      if (featuredMedia['media_type'] == 'image' && 
          featuredMedia['source_url'] != null) {
        featuredImageUrl = featuredMedia['source_url'];
      }
    }

    return NewsArticle(
      id: json['id'] ?? 0,
      title: cleanTitle,
      excerpt: cleanExcerpt,
      content: cleanContent,
      date: formattedDate,
      link: json['link'] ?? '',
      featuredMedia: featuredImageUrl,
      authorName: json['_embedded']?['author']?[0]?['name'] ?? 'Unknown Author',
      categories: categoryNames,
    );
  }

  static String _removeHtmlTags(String htmlString) {
    // Remove HTML tags
    String withoutTags = htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
    // Decode common HTML entities
    withoutTags = withoutTags
        .replaceAll('&', '&')
        .replaceAll('<', '<')
        .replaceAll('>', '>')
        .replaceAll('"', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');
    // Trim whitespace
    return withoutTags.trim();
  }

  static String _formatDate(DateTime date) {
    const List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  static String _getCategoryName(int categoryId) {
    // Map common WordPress category IDs to names
    switch (categoryId) {
      case 1:
        return 'Uncategorized';
      case 2:
        return 'News';
      case 3:
        return 'Products';
      case 4:
        return 'Technology';
      case 5:
        return 'Maintenance';
      case 6:
        return 'Industry';
      default:
        return 'General';
    }
  }

  String get shortExcerpt {
    if (excerpt.length <= 120) return excerpt;
    return '${excerpt.substring(0, 120)}...';
  }
}
