import 'package:flutter_bloc/flutter_bloc.dart';

import 'album_state.dart';
import '../../data/repositories/album_repository.dart';

class AlbumCubit extends Cubit<AlbumState> {
  final AlbumRepository albumRepository;

  AlbumCubit(this.albumRepository) : super(AlbumInitial());

  Future<void> fetchAlbums() async {
    if (state is AlbumLoaded) {
      emit(AlbumLoading(albums: (state as AlbumLoaded).albums));
    } else {
      emit(AlbumLoading());
    }
    try {
      final albums = await albumRepository.getAlbums();
      emit(AlbumLoaded(albums));
    } catch (e) {
      emit(AlbumError('Failed to load albums'));
    }
  }

  Future<void> fetchAlbumDetails(int albumId) async {
    if (state is AlbumLoaded) {
      emit(AlbumLoading(albums: (state as AlbumLoaded).albums));
    } else {
      emit(AlbumLoading());
    }
    try {
      final photos = await albumRepository.getPhotosByAlbum(albumId);
      if (state is AlbumLoaded) {
        emit(AlbumLoaded((state as AlbumLoaded).albums, photos: photos));
      } else {
        emit(AlbumLoaded([], photos: photos));
      }
    } catch (e) {
      if (state is AlbumLoaded) {
        emit(
          AlbumError(
            'Failed to load album details',
            albums: (state as AlbumLoaded).albums,
          ),
        );
      } else {
        emit(AlbumError('Failed to load album details'));
      }
    }
  }
}
