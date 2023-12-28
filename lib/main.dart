// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:groovix/Screenss/splash_screen.dart';
import 'package:groovix/db_model/db_model.dart';
import 'package:groovix/db_model/db_playlist_model.dart';
import 'package:groovix/db_model/db_recently_model.dart';
import 'package:groovix/providerr/song_model_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive initialization
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicSongAdapter().typeId)) {
    Hive.registerAdapter(MusicSongAdapter());
  }
  if (!Hive.isAdapterRegistered(ListmodelAdapter().typeId)) {
    Hive.registerAdapter(ListmodelAdapter());
  }
   if (!Hive.isAdapterRegistered(RecentlymodelAdapter().typeId)) {
    Hive.registerAdapter(RecentlymodelAdapter());
  }

  // JustAudioBackground initialization
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  // Run the app with ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      create: (context) => SongModelProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: const SplashScreen(),
    );
  }
}

