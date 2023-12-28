import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovix/Screenss/audio_query.dart';
import 'package:groovix/Screenss/music_play_screen.dart';
import 'package:groovix/bottom_sheets/bottom_sheet_menu.dart';
import 'package:groovix/bottom_sheets/home_song_list_settings.dart';
import 'package:groovix/db_funtion/functions.dart';
import 'package:groovix/providerr/song_model_provider.dart';
import 'package:groovix/reuseable_widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

final audioplayer = AudioPlayer();

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final GetAudio _getAudio = GetAudio();
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    _getAudio.requestPermision();
  }

  // Track liked songs+
  Set<int> likedSongs = {};

  playsong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log("error parsing song");
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _audioPlayer.dispose();
  // }
  void _showFavoriteSnackbar(bool isLiked) {
    final snackBar = SnackBar(
      content: Text(
        isLiked ? 'Song Removed From Favorites' : 'Song Added To Favorites',
        style: GoogleFonts.aboreto(color: color1white, fontSize: 16),
      ),
      backgroundColor: const Color.fromARGB(255, 2, 5, 50),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: music(),
      builder: (context, item) {
        if (item.data == null) {
          GetAudio();
          return const Center(child: CircularProgressIndicator());
        } else if (item.data!.isEmpty) {
          return const Center(
            child: Text('no songs'),
          );
        } else if (item.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (item.hasError) {
          return const Center(
            child: Text('Error No Songs'),
          );
        } else {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              // final isLiked = likedSongs.contains(index);

              return Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.0267),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: bgTheme(),
                    borderRadius: BorderRadius.all(
                      Radius.circular(MediaQuery.of(context).size.width * 0.04),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        offset: Offset(-1, -1),
                        color: Colors.white10,
                      ),
                      BoxShadow(
                        blurRadius: 6.0,
                        offset: Offset(8, 8),
                        color: Colors.black,
                      ),
                    ],
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.0267),
                    ),
                    leading: QueryArtworkWidget(
                      id: item.data![index].Songid,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Icon(
                          Icons.music_note,
                          color: color1white,
                          size: 42 * MediaQuery.of(context).size.width / 375.0,
                        ),
                      ),
                    ),
                    onTap: () {
                      context
                          .read<SongModelProvider>()
                          .setId(item.data![index].Songid);
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => MusicPlayScreen(
                            songModel: item.data!,
                            audioplayer: _audioPlayer,
                            index: index,
                            slidervalue: speed,
                          ),
                        ),
                      )
                          .then((value) {
                        setState(() {});
                      });
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.00625),
                        Text(
                          item.data![index].name,
                          style: GoogleFonts.aboreto(
                            color: color1white,
                            fontSize:
                                16 * MediaQuery.of(context).size.width / 375.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.00625),
                        Text(
                          '  ${item.data![index].artist}',
                          style: GoogleFonts.aboreto(
                            fontSize:
                                12 * MediaQuery.of(context).size.width / 375.0,
                            color: color1white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              favList();
                              bool isLiked = item.data![index].islike;
                              likeDbFuction(item.data![index]);
                              _showFavoriteSnackbar(isLiked);
                            });
                          },
                          icon: Icon(
                            item.data![index].islike
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: color1white,
                            size:
                                28 * MediaQuery.of(context).size.width / 375.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showBottomSheetSongSettings(context, item.data!,
                                _audioPlayer, index, item.data![index].Songid);
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: color1white,
                            size:
                                29 * MediaQuery.of(context).size.width / 375.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
