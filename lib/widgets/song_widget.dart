import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:musicplayer/pages/player_page.dart';
import 'package:musicplayer/services/fetch_songs.dart';
import 'package:musicplayer/services/my_audio_handler.dart';
import 'package:transparent_image/transparent_image.dart';
import "package:get/get.dart";

class SongWidget extends StatelessWidget {

  // MyAudioHandler to manage audio playback
  final MyAudioHandler audioHandler;

  // MediaItem representing the current song
  final MediaItem item;

  // index of the song in the list
  final int index;

  const SongWidget({
    super.key,
    required this.audioHandler, 
    required this.item, 
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem, 
      builder: (context,itemSnapshot){
        if(itemSnapshot.data != null){
          return DecoratedBox(
            decoration: BoxDecoration(
            color: itemSnapshot.data! == item 
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          ),
          child: ListTile(
            onTap: (){
              if( itemSnapshot.data! != item){
                audioHandler.skipToQueueItem(index);
              }
              Get.to(
                () => PlayerPage(audioHandler: audioHandler),
                transition: Transition.rightToLeft,
                duration: const Duration(microseconds: 700),
              );
            },
            leading: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:Theme.of(context).colorScheme.primaryContainer,
              ),
              child: itemSnapshot.data!.artUri == null 
              ? const Icon(Icons.music_note)
              : FutureBuilder<Uint8List?>(
                future: toImage(uri: item.artUri!), 
                builder: (context,snapShot){
                  if(snapShot.data != null){
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: MemoryImage(snapShot.data!),
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                ),
            ),
            title: Text(item.title,maxLines: 1,overflow: TextOverflow.ellipsis,),
            subtitle: Text(item.artist.toString()),
          ),
        );
        }
        return const SizedBox.shrink();
      },
    );
  }
}