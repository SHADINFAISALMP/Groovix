// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovix/Screenss/audio_query.dart';
import 'package:groovix/Screenss/music_play_screen.dart';
import 'package:groovix/Screenss/songs_lists_content.dart';
import 'package:groovix/bottom_sheets/bottom_sheet_menu.dart';
import 'package:groovix/bottom_sheets/home_song_list_settings.dart';
import 'package:groovix/db_funtion/functions.dart';
import 'package:groovix/providerr/song_model_provider.dart';
import 'package:groovix/reuseable_widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({Key? key}) : super(key: key);

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: bgTheme(),
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0567),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: color1white,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.0533),
                    mytext(
                      'RECENTLY PLAYED',
                      18 * MediaQuery.of(context).size.width / 375.0,
                      color1white,
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder(
                    future: recentlyPlayedSongs(),
                    builder: (context, item) {
                      if (item.data == null) {
                        GetAudio();
                        return const Center(child: CircularProgressIndicator());
                      } else if (item.data!.isEmpty) {
                        return Center(
                          child: mytext('no songs', 20, color1white),
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
                          itemCount:
                              item.data!.length < 10 ? item.data!.length : 10,
                          itemBuilder: (context, index) {
                            // final isLiked = likedSongs.contains(index);

                            return Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.0267),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: bgTheme(),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        MediaQuery.of(context).size.width *
                                            0.04),
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
                                        MediaQuery.of(context).size.width *
                                            0.0267),
                                  ),
                                  leading: QueryArtworkWidget(
                                    id: item.data![index].Songid,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: Icon(
                                        Icons.music_note,
                                        color: color1white,
                                        size: 42 *
                                            MediaQuery.of(context).size.width /
                                            375.0,
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
                                          audioplayer: audioplayer,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.00625),
                                      Text(
                                        item.data![index].name,
                                        style: GoogleFonts.aboreto(
                                          color: color1white,
                                          fontSize: 16 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              375.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.00625),
                                      Text(
                                        '  ${item.data![index].artist}',
                                        style: GoogleFonts.aboreto(
                                          fontSize: 12 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              375.0,
                                          color: color1white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            favList();
                                            bool isLiked =
                                                item.data![index].islike;
                                            likeDbFuction(item.data![index]);
                                            (isLiked);
                                          });
                                        },
                                        icon: Icon(
                                          item.data![index].islike
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: color1white,
                                          size: 27 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              375.0,
                                        ),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01),
                                      IconButton(
                                        onPressed: () {
                                          showBottomSheetSongSettings(
                                              context,
                                              item.data!,
                                              audioplayer,
                                              index,
                                              item.data![index].Songid);
                                        },
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: color1white,
                                          size: 28 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
