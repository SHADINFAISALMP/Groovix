import 'dart:io';

import 'package:flutter/material.dart';

import 'package:groovix/Screenss/music_play_screen.dart';
import 'package:groovix/bottom_sheets/add_to_playlist.dart';
import 'package:groovix/db_model/db_model.dart';
import 'package:groovix/providerr/song_model_provider.dart';
import 'package:groovix/reuseable_widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'package:share_plus/share_plus.dart';

void showBottomSheetSongSettings(BuildContext context, List<MusicSong> sm,
    AudioPlayer audio, int ind, int songid) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (builder) {
      return Container(
        decoration: BoxDecoration(
            gradient: bgTheme(),
            borderRadius: BorderRadius.all(
              Radius.circular(
                MediaQuery.of(context).size.width > 600 ? 40.0 : 40.0,
              ),
            ),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 5.0,
                  offset: Offset(-3, -3),
                  color: Colors.white10),
              BoxShadow(
                  blurRadius: 6.0, offset: Offset(8, 8), color: Colors.black),
            ]),
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width > 600 ? 32.0 : 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            InkWell(
              onTap: () {
                context.read<SongModelProvider>().setId(sm[ind].Songid);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicPlayScreen(
                            songModel: sm, audioplayer: audio, index: ind)));
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.03),
                        color: color1white),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.06,
                  ),
                  mytext(
                    'Play',
                    MediaQuery.of(context).size.width * 0.045,
                    color1white,
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                showbottomsheetaddtoplaylist(
                    context: context, sm: sm, ind: ind, songid: songid);
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.03),
                      color: color1white,
                    ),
                    child: const Icon(
                      Icons.playlist_add,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.06,
                  ),
                  mytext(
                    'Add To Playlist',
                    MediaQuery.of(context).size.width * 0.045,
                    color1white,
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.03),
                    color: color1white,
                  ),
                  child: const Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                    try {
                    await  shareSong(sm[ind]);
                    } finally {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  child: mytext(
                    'Share',
                    MediaQuery.of(context).size.width * 0.045,
                    color1white,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
Future<void> shareSong(MusicSong sn) async {
  final song =sn;

  if (song.path.isNotEmpty) {
    final file = File(song.path);

    if (await file.exists()) {
      await Share.shareFiles([song.path]
         );
    } else {
      debugPrint('File not found: ${song.uri}');
    }
  } else {
    debugPrint('File path is empty');
  }
}
