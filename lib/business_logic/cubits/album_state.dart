import '../../data/models/album_model.dart';
import '../../data/models/photo_model.dart';

abstract class AlbumState {}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {
  final List<Album>? albums;
  final List<Photo>? photos;

  AlbumLoading({this.albums, this.photos});
}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;
  final List<Photo>? photos;

  AlbumLoaded(this.albums, {this.photos});
}

class AlbumError extends AlbumState {
  final String message;
  final List<Album>? albums;
  final List<Photo>? photos;

  AlbumError(this.message, {this.albums, this.photos});
}
