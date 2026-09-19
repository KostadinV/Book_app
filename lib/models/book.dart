class Book {
  final int? id;
  final String title;
  final String author;
  final double rating;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'author': author, 'rating': rating};
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int?,
      title: map['title'] as String,
      author: map['author'] as String,
      rating: (map['rating'] as num).toDouble(),
    );
  }
}
