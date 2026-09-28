class Book {
  final int? id;
  final String title;
  final String author;
  final double rating;
  final bool isFavorite;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.rating,
    this.isFavorite = false,
  });

  Book copyWith({
    int? id,
    String? title,
    String? author,
    double? rating,
    bool? isFavorite,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'rating': rating,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int?,
      title: map['title'] as String,
      author: map['author'] as String,
      rating: (map['rating'] as num).toDouble(),
      isFavorite: map['is_favorite'] == 1,
    );
  }
}
