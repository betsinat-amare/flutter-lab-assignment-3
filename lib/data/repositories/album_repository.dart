import '../models/album_model.dart';
import '../models/photo_model.dart';
import '../services/api_service.dart';

class AlbumRepository {
  final ApiService apiService;

  AlbumRepository(this.apiService);

  Future<List<Album>> getAlbums() async {
    final data = await apiService.fetchAlbums();
    return data.map<Album>((json) => Album.fromJson(json)).toList();
  }

  Future<List<Photo>> getPhotosByAlbum(int albumId) async {
    try {
      final data = await apiService.fetchPhotos(albumId);
      final photos = data.map<Photo>((json) {
        // Use a more reliable image service with caching
        final id = json['id'] as int;
        // Use Lorem Picsum with a fixed ID and no random parameter
        final url = 'https://picsum.photos/id/${id + 100}/600/600';
        final thumbnailUrl = 'https://picsum.photos/id/${id + 100}/150/150';
        print('Transformed URL for photo $id: $url');
        return Photo(
          id: id,
          albumId: json['albumId'],
          title: json['title'],
          url: url,
          thumbnailUrl: thumbnailUrl,
        );
      }).toList();
      print('Final photo URLs: ${photos.map((p) => p.url).toList()}');
      return photos;
    } catch (e) {
      print('Error fetching photos: $e');
      rethrow;
    }
  }
}
