// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';
part 'db_model.g.dart';

@HiveType(typeId: 1)
class MusicSong extends HiveObject {
  @HiveField(0)
  int Songid;
  @HiveField(1)
  String uri;
  @HiveField(2)
  String name;
  @HiveField(3)
  String artist;
  @HiveField(4)
  String album;
  @HiveField(5)
  bool islike;
  @HiveField(6)
  String path;

  MusicSong(
      {required this.Songid,
      required this.uri,
      required this.name,
      required this.artist,
      required this.album,
      required this.islike,
      required this.path});
}
