import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'data/repositories/album_repository.dart';
import 'data/services/api_service.dart';
import 'business_logic/cubits/album_cubit.dart';
import 'presentation/screens/album_list_screen.dart';
import 'presentation/screens/album_detail_screen.dart';
import 'presentation/screens/welcome_screen.dart';
import 'data/models/album_model.dart';

void main() {
  final albumRepository = AlbumRepository(ApiService());
  runApp(MyApp(albumRepository: albumRepository));
}

class MyApp extends StatefulWidget {
  final AlbumRepository albumRepository;

  const MyApp({super.key, required this.albumRepository});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  late final GoRouter _router;

  _MyAppState();

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder:
              (context, state) => WelcomeScreen(
                onThemeChanged: _handleThemeChange,
                isDarkMode: _isDarkMode,
              ),
        ),
        GoRoute(
          path: '/albums',
          builder:
              (context, state) => AlbumListScreen(
                onThemeChanged: _handleThemeChange,
                isDarkMode: _isDarkMode,
              ),
        ),
        GoRoute(
          path: '/album_detail',
          builder: (context, state) {
            final album = state.extra as Album;
            return AlbumDetailScreen(
              album: album,
              onThemeChanged: _handleThemeChange,
              isDarkMode: _isDarkMode,
            );
          },
        ),
      ],
      // Removed refreshListenable: GoRouterRefreshStream(Stream.value(_isDarkMode)),
    );
  }

  void _handleThemeChange(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumCubit(widget.albumRepository)..fetchAlbums(),
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Album App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
    );
  }
}
