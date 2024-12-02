import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/services/my_audio_handler.dart';

class PlayerPage extends StatefulWidget {
  final MyAudioHandler audioHandler;
  const PlayerPage({super.key, required this.audioHandler});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: StreamBuilder<MediaItem?>(
          stream: widget.audioHandler.mediaItem, 
          builder: (context,mediaSnapshot){
            if(mediaSnapshot.data! != null){
              MediaItem item = mediaSnapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // CoverWidget to display the cover image
                  
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}