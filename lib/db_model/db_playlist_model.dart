import 'package:hive_flutter/hive_flutter.dart';
part 'db_playlist_model.g.dart';
@HiveType(typeId: 2)
class Listmodel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<int> songid;
  Listmodel({required this.songid, required this.name});
}
