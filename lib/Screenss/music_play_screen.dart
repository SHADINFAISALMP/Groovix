// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:async';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovix/bottom_sheets/add_to_playlist.dart';
import 'package:groovix/bottom_sheets/get_lyrics_bottom.dart';
import 'package:groovix/db_funtion/functions.dart';
import 'package:groovix/db_model/db_model.dart';

import 'package:groovix/providerr/song_model_provider.dart';
import 'package:groovix/reuseable_widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

bool isShuffleActive = false;
Random r = Random();

// ignore: must_be_immutable
class MusicPlayScreen extends StatefulWidget {
  MusicPlayScreen({
    Key? key,
    required this.songModel,
    required this.audioplayer,
    required this.index,
    this.slidervalue,
  }) : super(key: key);

  final List<MusicSong> songModel;
  final AudioPlayer audioplayer;
  int index;
  final double? slidervalue;
  @override
  State<MusicPlayScreen> createState() => _MusicPlayScreenState();
}

class _MusicPlayScreenState extends State<MusicPlayScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isplaying = false;
  double _speed = 1.0;

  Set<int> likedSongs = {};

  final StreamController<Duration> _positionController =
      StreamController<Duration>();

  @override
  void initState() {
    super.initState();
    playsong();
    if (widget.slidervalue != null) {
      _speed = widget.slidervalue!;
      widget.audioplayer.setSpeed(_speed);
    }
    widget.audioplayer.positionStream.listen((p) {
      setState(() {
        _position = p;
        _positionController.add(p);
      });
    });
  }

  void playsong() {
    addSongToRecentlyPlayed(widget.songModel[widget.index].Songid);
    try {
      widget.audioplayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.songModel[widget.index].uri),
          tag: MediaItem(
            id: '${widget.songModel[widget.index].Songid}',
            album: widget.songModel[widget.index].album,
            title: widget.songModel[widget.index].name,
            artUri: Uri.parse(widget.songModel[widget.index].uri),
          ),
        ),
      );
      widget.audioplayer.play();
      _isplaying = true;
    } on Exception {
      debugPrint("cannot not parse");
    }
    widget.audioplayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioplayer.processingStateStream.listen((event) {
      if (event == ProcessingState.completed) {
        _playNext();
        playsong();
        context
            .read<SongModelProvider>()
            .setId(widget.songModel[widget.index].Songid);
      }
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   widget.audioplayer.dispose();
  //   _positionController.close();
  // }

  void _showFavoriteSnackbar(bool isLiked) {
    final snackBar = SnackBar(
      content: Text(
        isLiked ? 'Song Removed From Favorites' : 'Song Added To Favorites',
        style: GoogleFonts.aboreto(color: color1white, fontSize: 16),
      ),
      backgroundColor: Color.fromARGB(255, 2, 5, 50),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: color1white,
                        size: 39 * MediaQuery.of(context).size.width / 375.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        favList();
                        bool isLiked = widget.songModel[widget.index].islike;
                        likeDbFuction(widget.songModel[widget.index]);
                        setState(() {});
                        _showFavoriteSnackbar(isLiked);
                      },
                      icon: Icon(
                        //  likedSongs.contains(widget.index)w
                        widget.songModel[widget.index].islike
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: color2red,
                        size: 29 * MediaQuery.of(context).size.width / 375.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  height: MediaQuery.of(context).size.height * 0.340,
                  width: MediaQuery.of(context).size.width * 0.72,
                  decoration: BoxDecoration(
                    gradient: bgTheme(),
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.12),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5.0,
                        offset: Offset(-0, -0),
                        color: Colors.white10,
                      ),
                      BoxShadow(
                        blurRadius: 6.0,
                        offset: Offset(6, 6),
                        color: Colors.black,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const ArtWorkWidget(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.080),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: bgTheme(),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.0700),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5.0,
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
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.030),
                        Expanded(
                          child: Marquee(
                            text: widget.songModel[widget.index].name,
                            style: GoogleFonts.aboreto(
                              color: color1white,
                              fontSize: 19 *
                                  MediaQuery.of(context).size.width /
                                  375.0,
                            ),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 10.0 *
                                MediaQuery.of(context).size.width /
                                375.0,
                            velocity: 40.0 *
                                MediaQuery.of(context).size.width /
                                375.0,
                          ),
                        ),
                        // SizedBox(height: 10),
                        Text(
                          widget.songModel[widget.index].artist.toString() ==
                                  "<unknown"
                              ? " Unknown Artist"
                              : widget.songModel[widget.index].artist
                                  .toString(),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.aboreto(
                            color: color1white,
                            fontSize:
                                15 * MediaQuery.of(context).size.width / 375.0,
                          ),
                        ),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.0550),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.06),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _showSpeedDialog(context, _speed),
                                    icon: Icon(
                                      Icons.speed,
                                      color: color1white,
                                      size: 28 *
                                          MediaQuery.of(context).size.width /
                                          375.0,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colorwhite2,
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.0213),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.032,
                                      vertical:
                                          MediaQuery.of(context).size.width *
                                              0.0213,
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            });
                                        await getLyricsBottomSheet(
                                            context,
                                            widget
                                                .songModel[widget.index].artist,
                                            widget
                                                .songModel[widget.index].name);
                                      },
                                      child: Text(
                                        'Get Lyrics',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              375.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showbottomsheetaddtoplaylist(
                                          context: context,
                                          ind: widget.index,
                                          sm: widget.songModel,
                                          songid: widget
                                              .songModel[widget.index].Songid);
                                    },
                                    icon: Icon(
                                      Icons.playlist_add_rounded,
                                      color: color1white,
                                      size: 29 *
                                          MediaQuery.of(context).size.width /
                                          375.0,
                                    ),
                                  ),
                                ],
                              ),
                              StreamBuilder(
                                stream: _positionController.stream,
                                builder: (context, item) {
                                  if (item.hasData) {
                                    _position = item.data as Duration;
                                    // Update the slider value
                                    return Slider(
                                      min: 0,
                                      max: _duration.inSeconds.toDouble(),
                                      value: _position.inSeconds.toDouble(),
                                      onChanged: (value) {
                                        setState(() {
                                          changeToSeconds(value.toInt());
                                          value = value;
                                        });
                                      },
                                    );
                                  } else {
                                    return SizedBox(); // Placeholder widget
                                  }
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _position.toString().split(".")[0],
                                    style: TextStyle(color: color1white),
                                  ),
                                  Text(
                                    _duration.toString().split(".")[0],
                                    style: TextStyle(color: color1white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.0200),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      isShuffleActive = !isShuffleActive;
                                      setState(() {
                                        _showShuffleSnackBar(isShuffleActive);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.shuffle,
                                      color: isShuffleActive
                                          ? Colors.blue
                                          : color1white,
                                      size: 29 *
                                          MediaQuery.of(context).size.width /
                                          375.0,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05),
                                  IconButton(
                                    onPressed: () {
                                      _playPrevious();
                                      playsong();
                                      context.read<SongModelProvider>().setId(
                                          widget
                                              .songModel[widget.index].Songid);
                                    },
                                    icon: Icon(
                                      Icons.skip_previous,
                                      color: color1white,
                                      size: 29 *
                                          MediaQuery.of(context).size.width /
                                          375.0,
                                    ),
                                  ),
                                  // SizedBox(
                                  //     width: MediaQuery.of(context).size.width *
                                  //         0.05),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white24,
                                    child: Transform.scale(
                                      scale: 2,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_isplaying) {
                                              widget.audioplayer.pause();
                                            } else {
                                              widget.audioplayer.play();
                                            }
                                            _isplaying = !_isplaying;
                                          });
                                        },
                                        icon: Icon(
                                          _isplaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: color1white,
                                          size: 29 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              375.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //     width: MediaQuery.of(context).size.width *
                                  //         0.05),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isShuffleActive) {
                                          _shuffle();
                                          playsong();
                                          context
                                              .read<SongModelProvider>()
                                              .setId(widget
                                                  .songModel[widget.index]
                                                  .Songid);
                                        }
                                        _playNext();
                                        playsong();
                                        context.read<SongModelProvider>().setId(
                                            widget.songModel[widget.index]
                                                .Songid);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.skip_next,
                                      color: color1white,
                                      size: 29 *
                                          MediaQuery.of(context).size.width /
                                          375.0,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05),
                                  IconButton(
                                    onPressed: () {
                                      toggleRepeat();
                                      showRepeatSnackbar(
                                          widget.audioplayer.loopMode);
                                    },
                                    icon: Icon(
                                      Icons.repeat,
                                      color: widget.audioplayer.loopMode ==
                                              LoopMode.one
                                          ? Colors.blue
                                          : color1white,
                                      size: 29 *
                                          MediaQuery.of(context).size.width /
                                          375.0,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: color1white,
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.0400),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleLiked() {
    setState(() {
      if (likedSongs.contains(widget.index)) {
        likedSongs.remove(widget.index);
      } else {
        likedSongs.add(widget.index);
      }
    });
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioplayer.seek(duration);
  }

  void _playPrevious() {
    if (widget.index > 0) {
      widget.index--;
    } else {
      widget.index = widget.songModel.length - 1;
    }
  }

  void toggleRepeat() {
    setState(() {
      if (widget.audioplayer.loopMode == LoopMode.off) {
        widget.audioplayer.setLoopMode(LoopMode.one);
      } else {
        widget.audioplayer.setLoopMode(LoopMode.off);
      }
    });
  }

  void showRepeatSnackbar(LoopMode loopMode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            loopMode == LoopMode.off ? 'Repeat is OFF' : 'Repeat is ON',
            style: GoogleFonts.aboreto(color: color1white, fontSize: 16),
          ),
          backgroundColor: Color.fromARGB(255, 2, 5, 50)),
    );
  }

  void _shuffle() {
    setState(() {
      int n = r.nextInt(widget.songModel.length);
      widget.songModel[widget.index];
      widget.index = n;

      // widget.index = 0;
      playsong();
      context
          .read<SongModelProvider>()
          .setId(widget.songModel[widget.index].Songid);
    });
  }

  void _showShuffleSnackBar(bool isShuffleActive) {
    final snackBar = SnackBar(
      content: Text(
        isShuffleActive ? 'SHUFFLE IS ON' : 'SHUFFLE IS OFF',
        style: GoogleFonts.aboreto(color: color1white, fontSize: 16),
      ),
      backgroundColor: Color.fromARGB(255, 2, 5, 50),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _playNext() {
    if (widget.index < widget.songModel.length - 1) {
      widget.index++;
    } else {
      widget.index = 0;
    }
  }

  void _showSpeedDialog(BuildContext context, double num) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.transparent,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.02),
            ),
            content: StatefulBuilder(builder: (BuildContext context, setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.2725,
                width: MediaQuery.of(context).size.width * 0.900,
                decoration: BoxDecoration(
                  gradient: bgTheme(),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.03),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4.0,
                      offset: Offset(-3, -3),
                      color: Colors.white10,
                    ),
                    BoxShadow(
                      blurRadius: 6.0,
                      offset: Offset(5, 5),
                      color: Colors.black,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      child: Text(
                        'Adjust Playback Speed',
                        style: GoogleFonts.aboreto(
                            color: color1white,
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0100,
                    ),
                    Text(
                      'Current Speed: ${_speed.toStringAsFixed(1)}x',
                      style:
                          GoogleFonts.aboreto(color: color1white, fontSize: 16),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01875,
                    ),
                    Slider(
                      min: 0.5,
                      max: 2.5,
                      value: _speed,
                      onChanged: (value) {
                        setState(() {
                          _speed = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        mytext(
                          '0.5x',
                          MediaQuery.of(context).size.width * 0.04,
                          color1white,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.075,
                        ),
                        mytext(
                          '2.5x',
                          MediaQuery.of(context).size.width * 0.04,
                          color1white,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01075,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: mytext(
                            'Cancel',
                            MediaQuery.of(context).size.width * 0.04,
                            color3blueaccent,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.audioplayer.setSpeed(_speed);
                            Navigator.of(context).pop();
                          },
                          child: mytext(
                              'Apply',
                              MediaQuery.of(context).size.width * 0.04,
                              color3blueaccent),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkHeight: double.infinity,
      artworkWidth: double.infinity,
      artworkFit: BoxFit.cover,
      nullArtworkWidget: Icon(
        Icons.music_note,
        color: color1white,
        size: 150 * MediaQuery.of(context).size.width / 375.0,
      ),
    );
  }
}
