// lib/presentation/widgets/album_tile.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/album_model.dart';

class AlbumTile extends StatelessWidget {
  final Album album;
  final int index; // Add index parameter

  const AlbumTile({super.key, required this.album, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '$index',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      title: Text(album.title),
      onTap: () {
        context.go('/album_detail', extra: album);
      },
    );
  }
}
