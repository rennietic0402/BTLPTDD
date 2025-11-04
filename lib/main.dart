// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'app.dart';
// import 'core/config/firebase_env.dart'; // Giữ lại nếu cần các config khác ngoài Options
import 'core/providers/favorite_provider.dart';
import 'firebase_options.dart'; // File options tự động sinh

// ✅ Cần import các lớp Data và Repository để khởi tạo Provider
import 'package:btludptdd/features/favourites/data/datasources/favorites_remote_data_source.dart';
import 'package:btludptdd/features/favourites/data/repositories/favorites_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 1. Khởi tạo Dependencies (Data Source & Repository)
  final favoritesRemoteDataSource = FavoritesRemoteDataSourceImpl();
  final favoritesRepository = FavoritesRepositoryImpl(favoritesRemoteDataSource);

  runApp(
    MultiProvider(
      providers: [
        // 2. ✅ Khởi tạo Provider và truyền Repository vào
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(repository: favoritesRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}