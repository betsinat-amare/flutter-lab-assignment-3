import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<dynamic>> fetchAlbums() async {
    final response = await http.get(Uri.parse('$_baseUrl/albums'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load albums');
    }
  }

  Future<List<dynamic>> fetchPhotos(int albumId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/photos?albumId=$albumId'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(
        'Raw photo data from API: ${data.map((photo) => photo['url']).toList()}',
      );
      return data;
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
