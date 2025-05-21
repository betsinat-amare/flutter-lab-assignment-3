// lib/data/models/photo_model.dart

class Photo {
  final int id;
  final int albumId;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    // Use Picsum Photos instead of the non-working placeholder service
    final id = json['id'] as int;
    final url = 'https://picsum.photos/id/${id + 10}/600/600';
    final thumbnailUrl = 'https://picsum.photos/id/${id + 10}/150/150';

    return Photo(
      id: id,
      albumId: json['albumId'],
      title: json['title'],
      url: url,
      thumbnailUrl: thumbnailUrl,
    );
  }
}
