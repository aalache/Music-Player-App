import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/services/my_audio_handler.dart';
import 'package:musicplayer/services/fetch_songs.dart';
import 'package:musicplayer/widgets/song_widget.dart';

class HomePage extends StatefulWidget {

  // Instance of my audio handler to manage audio playback
  final MyAudioHandler audioHandler;

  const HomePage({super.key,required this.audioHandler});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // List to store MediaItem representing songs
  List<MediaItem> songs = [];

  @override
  void initState() {
    // Execute FetchSongs to retrieve and set the list of songs
    FetchSongs.execute().then((value) {
      setState(() {
        songs = value;
      });

      // initialize songs in the audio handler

     widget.audioHandler.initSongs(songs: value);

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music App"),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: songs.length,
        itemBuilder: (context,index){
          MediaItem item = songs[index];
          return SongWidget(audioHandler: widget.audioHandler, item: item, index: index);
        },
        ),
    );
  }
}