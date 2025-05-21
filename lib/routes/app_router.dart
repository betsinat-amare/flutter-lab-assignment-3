import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/album_model.dart';
import '../presentation/screens/album_list_screen.dart';
import '../presentation/screens/album_detail_screen.dart';

class AppRouter {
  static GoRouter createRouter({
    required void Function(bool) onThemeChanged,
    required bool isDarkMode,
  }) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder:
              (context, state) => AlbumListScreen(
                onThemeChanged: onThemeChanged,
                isDarkMode: isDarkMode,
              ),
        ),
        GoRoute(
          path: '/detail',
          builder: (context, state) {
            final album = state.extra as Album?;
            if (album == null) {
              return const Scaffold(
                body: Center(child: Text('No album selected')),
              );
            }
            return AlbumDetailScreen(
              album: album,
              onThemeChanged: onThemeChanged,
              isDarkMode: isDarkMode,
            );
          },
        ),
      ],
    );
  }
}
