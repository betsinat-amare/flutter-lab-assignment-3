import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../business_logic/cubits/album_cubit.dart';
import '../../business_logic/cubits/album_state.dart';
import '../../data/models/album_model.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;
  final void Function(bool) onThemeChanged;
  final bool isDarkMode;

  const AlbumDetailScreen({
    super.key,
    required this.album,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/albums');
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(album.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/albums');
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => onThemeChanged(!isDarkMode),
              tooltip:
                  isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            ),
          ],
        ),
        body: BlocBuilder<AlbumCubit, AlbumState>(
          builder: (context, state) {
            if (state is AlbumLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AlbumLoaded && state.photos != null) {
              final photos = state.photos!;
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: photo.url,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        print('Error loading image: $error');
                        return const Center(
                          child: Icon(Icons.error_outline, color: Colors.red),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is AlbumError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed:
                          () => context.read<AlbumCubit>().fetchAlbumDetails(
                            album.id,
                          ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
