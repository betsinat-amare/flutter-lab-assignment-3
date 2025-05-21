import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../business_logic/cubits/album_cubit.dart';
import '../../business_logic/cubits/album_state.dart';

class AlbumListScreen extends StatefulWidget {
  final void Function(bool) onThemeChanged;
  final bool isDarkMode;

  const AlbumListScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<AlbumListScreen> createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch albums when the screen is mounted
    context.read<AlbumCubit>().fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Albums'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => widget.onThemeChanged(!widget.isDarkMode),
            tooltip:
                widget.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
          ),
        ],
      ),
      body: BlocBuilder<AlbumCubit, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumLoaded) {
            final albums = state.albums;
            return ListView.separated(
              itemCount: albums.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final album = albums[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(album.title),
                  onTap: () {
                    // Navigate to details and fetch photos
                    context.read<AlbumCubit>().fetchAlbumDetails(album.id);
                    context.go('/album_detail', extra: album);
                  },
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
                    onPressed: () => context.read<AlbumCubit>().fetchAlbums(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
