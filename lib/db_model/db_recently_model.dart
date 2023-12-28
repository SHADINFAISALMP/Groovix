import 'package:hive_flutter/hive_flutter.dart';
part 'db_recently_model.g.dart';
@HiveType(typeId: 3)
class Recentlymodel extends HiveObject {
  @HiveField(0)
  int songID;
  Recentlymodel({required this.songID});
}
