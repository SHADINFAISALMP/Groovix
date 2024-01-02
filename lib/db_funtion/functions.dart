import 'package:flutter/material.dart';
import 'package:groovix/db_model/db_model.dart';
import 'package:groovix/db_model/db_playlist_model.dart';
import 'package:groovix/db_model/db_recently_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share/share.dart';

Future<void> addSong({required List<SongModel> s}) async {
  debugPrint('hello');
  final songDB = await Hive.openBox<MusicSong>('song_db');
  if (songDB.isEmpty) {
    for (SongModel song in s) {
      songDB.add(MusicSong(
          name: song.title,
          Songid: song.id.toInt(),
          uri: song.uri.toString(),
          artist: song.artist.toString(),
          album: song.album.toString(),
          islike: false,
          path: song.data));
    }
    music();
  } else {
    debugPrint("not empty");
    for (SongModel song in s) {
      if (!songDB.values.any((element) => element.Songid == song.id.toInt())) {
        songDB.add(MusicSong(
            name: song.title,
            Songid: song.id.toInt(),
            uri: song.uri.toString(),
            artist: song.artist.toString(),
            album: song.album.toString(),
            islike: false,
            path: song.data));
      }
    }
    music();
  }
}

Future<List<MusicSong>> music() async {
  final songDB = await Hive.openBox<MusicSong>('song_db');
  List<MusicSong> song = [];

  for (MusicSong s in songDB.values) {
    song.add(s);
    (s);
  }
  debugPrint("song");
  return song;
}

void likeDbFuction(MusicSong a) async {
  final songDb = await Hive.openBox<MusicSong>('song_db');
  MusicSong song = songDb.values.firstWhere((song) => song.Songid == a.Songid);
  song.islike = !song.islike;
  songDb.put(song.key, song);
}

Future<List<MusicSong>> favList() async {
  List<MusicSong> songs = await music();
  List<MusicSong> favSongs = songs.where((song) {
    return song.islike == true;
  }).toList();
  for (int i = 0; i < favSongs.length; i++) {
    debugPrint('hil;j ${favSongs[i].name}');
  }
  return favSongs;
}

//PLAYLIST
addtoplaylist({required String name, required List<int> songid}) async {
  final playlistDB = await Hive.openBox<Listmodel>('list_db');
  playlistDB.add(Listmodel(songid: songid, name: name));
  debugPrint("${playlistDB.length}");
}

Future<List<Listmodel>> getfromplaylist() async {
  List<Listmodel> pldb = [];
  final playlistDB = await Hive.openBox<Listmodel>('list_db');
  pldb = playlistDB.values.toList();
  return pldb;
}

Future<void> deletePlayList(int index) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  if (index >= 0 && index < playListDb.length) {
    playListDb.deleteAt(index);
  } else {
    debugPrint("Invalid index for playlist deletion");
  }
}

renameplaylist({required Listmodel playlist, required String newname}) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  final storedplaylist = playListDb.get(playlist.key);
  if (storedplaylist != null) {
    storedplaylist.name = newname;
    playListDb.put(playlist.key, storedplaylist);
  }
}

addSongsToPlaylist({required int songid, required Listmodel playlist}) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  final pl = playListDb.get(playlist.key);
  if (!pl!.songid.contains(songid)) {
    pl.songid.add(songid);
    playListDb.put(playlist.key, pl);
    debugPrint("$songid added");
  } else {
    debugPrint("song already present in playlist");
  }
}

List<int> songsinPlylist = [];

checkSongOnPlaylist({required Listmodel playlist}) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  final pl = playListDb.get(playlist.key);
  songsinPlylist = pl!.songid;
}

List<String> playlistNames = [];

checkplaylistNames() async {
  playlistNames.clear();
  final playListBox = await Hive.openBox<Listmodel>('list_db');
  for (int i = 0; i < playListBox.length; i++) {
    final playlist = playListBox.getAt(i);
    if (playlist != null) {
      playlistNames.add(playlist.name);
      debugPrint("playlist name $i - ${playlist.name}");
    }
  }
  await playListBox.close();
}

removeSongsFromPlaylist(
    {required int songid, required Listmodel playlist}) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  final pl = playListDb.get(playlist.key);
  pl!.songid.remove(songid);
  playListDb.put(playlist.key, pl);
  debugPrint("$songid removed");
}

Future<List<MusicSong>> playlistSongs({required Listmodel playslist}) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  Listmodel? s = playListDb.get(playslist.key);
  List<int> plSongs = s!.songid;
  List<MusicSong> allSongs = await music();
  List<MusicSong> result = [];
  for (int i = 0; i < allSongs.length; i++) {
    for (int j = 0; j < plSongs.length; j++) {
      if (allSongs[i].Songid == plSongs[j]) {
        result.add(MusicSong(
            Songid: allSongs[i].Songid,
            album: allSongs[i].album,
            artist: allSongs[i].artist,
            name: allSongs[i].name,
            islike: allSongs[i].islike,
            uri: allSongs[i].uri,
            path: allSongs[i].path));
      }
    }
  }
  return result;
}

//RECENTLY PLAYED
void addSongToRecentlyPlayed(int songId) async {
  final recentlyPlayedBox = await Hive.openBox<Recentlymodel>('recents');
  List<Recentlymodel> songs = recentlyPlayedBox.values.toList();
  for (int i = 0; i < songs.length; i++) {
    if (songs[i].songID == songId) {
      recentlyPlayedBox.delete(songs[i].key);
      break;
    }
  }
  recentlyPlayedBox.add(Recentlymodel(songID: songId));
}

Future<List<MusicSong>> recentlyPlayedSongs() async {
  final recentlyPlayedBox = await Hive.openBox<Recentlymodel>('recents');
  List<Recentlymodel> songs = recentlyPlayedBox.values.toList();
  List<MusicSong> allSongs = await music();
  List<MusicSong> recents = [];
  for (int i = 0; i < songs.length; i++) {
    for (int j = 0; j < allSongs.length; j++) {
      if (songs[i].songID == allSongs[j].Songid) {
        recents.add(allSongs[j]);
      }
    }
  }

  return recents.reversed.toList();
}

Future<void> sharemusic(String sh) async {
  await Share.shareFiles([sh]);
}
