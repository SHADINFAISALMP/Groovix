// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovix/Screenss/music_play_screen.dart';
import 'package:groovix/bottom_sheets/home_song_list_settings.dart';
import 'package:groovix/db_funtion/functions.dart';
import 'package:groovix/db_model/db_model.dart';
import 'package:groovix/providerr/song_model_provider.dart';
import 'package:groovix/reuseable_widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LikedScreen extends StatefulWidget {
  bool backbutton;
  LikedScreen({Key? key, required this.backbutton}) : super(key: key);

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  bool hasFavorites = false;
  bool isselected = false;
  final _audioPlayer = AudioPlayer();
  TextEditingController searchController = TextEditingController();
  List<MusicSong> allSongs = [];
  List<MusicSong> filteredSongs = [];

  @override
  void initState() {
    super.initState();
    checkFavorites();
    loadAllSongs();
  }

  Future<void> checkFavorites() async {
    final favoriteSongs = await favList();
    setState(() {
      hasFavorites = favoriteSongs.isNotEmpty;
    });
  }

  void loadAllSongs() async {
    final allSongs = await favList();
    setState(() {
      this.allSongs = allSongs;
      filteredSongs = allSongs;
    });
  }

  void _searchSongs(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredSongs = allSongs;
      });
    } else {
      setState(() {
        filteredSongs = allSongs
            .where(
                (song) => song.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _audioPlayer.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: bgTheme(),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  widget.backbutton
                      ? IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_outlined,
                            color: color1white,
                            size: MediaQuery.of(context).size.width * 0.075,
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.030),
                  mytext(
                    'FAVORITE SONGS',
                    19 * MediaQuery.of(context).size.width / 375.0,
                    color1white,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.28),
                  Visibility(
                    visible: hasFavorites, // Show only when there are favorites
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isselected = true;
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: color1white,
                        size: MediaQuery.of(context).size.width * 0.070,
                      ),
                    ),
                  ),
                ],
              ),
              if (isselected)
                Container(
                  height: MediaQuery.of(context).size.height * 0.0625,
                  width: MediaQuery.of(context).size.width * 0.900,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 5, 4, 84),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4.0,
                            offset: Offset(-1, -1),
                            color: Colors.white10),
                        BoxShadow(
                            blurRadius: 6.0,
                            offset: Offset(5, 5),
                            color: Colors.black),
                      ]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.0533),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: color1white,
                          size: MediaQuery.of(context).size.width * 0.070,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.025),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchSongs(value);
                              });
                            },
                            style: TextStyle(color: color1white),
                            decoration: InputDecoration(
                                hintText: 'Search....',
                                hintStyle: GoogleFonts.aboreto(
                                  color: color1white,
                                  fontSize: 19 *
                                      MediaQuery.of(context).size.width /
                                      375.0,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.025),
                        IconButton(
                            onPressed: () {
                              searchController.clear();
                              _searchSongs('');
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: color1white,
                              size: MediaQuery.of(context).size.width * 0.070,
                            ))
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: FutureBuilder(
                  future: favList(),
                  builder: (context, item) {
                    if (item.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (item.data!.isEmpty) {
                      return Center(
                        child: mytext('NO FAVORITE SONGS', 20, colorwhite2),
                      );
                    } else if (item.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (item.hasError) {
                      return const Center(
                        child: Text('Error No Songs'),
                      );
                    } else {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredSongs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.025),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: bgTheme(),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.width * 0.04)),
                                boxShadow: [
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
                                      MediaQuery.of(context).size.width *
                                          0.027),
                                ),
                                leading: QueryArtworkWidget(
                                  id: filteredSongs[index].Songid,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    child: Icon(
                                      Icons.music_note,
                                      color: color1white,
                                      size: MediaQuery.of(context).size.width *
                                          0.070,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  context
                                      .read<SongModelProvider>()
                                      .setId(filteredSongs[index].Songid);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MusicPlayScreen(
                                        songModel: filteredSongs,
                                        audioplayer: _audioPlayer,
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      filteredSongs[index].name,
                                      style: GoogleFonts.aboreto(
                                        color: color1white,
                                        fontSize: 17 *
                                            MediaQuery.of(context).size.width /
                                            375.0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.00625),
                                    Text(
                                      '  ${filteredSongs[index].artist}',
                                      style: GoogleFonts.aboreto(
                                        fontSize: 12.0 *
                                            MediaQuery.of(context).size.width /
                                            375.0,
                                        color: color1white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          likeDbFuction(allSongs[index]);
                                          loadAllSongs();
                                        });

                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.favorite,
                                        color: color1white,
                                        size: 26 *
                                            MediaQuery.of(context).size.width /
                                            375.0,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.0175),
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<SongModelProvider>()
                                            .setId(item.data![index].Songid);

                                        showBottomSheetSongSettings(
                                            context,
                                            filteredSongs,
                                            _audioPlayer,
                                            index,
                                            item.data![index].Songid);
                                      },
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: color1white,
                                        size: 26 *
                                            MediaQuery.of(context).size.width /
                                            375.0,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
