import 'dart:convert';
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

// Create an instance of OnAudioQuery for querying audio information
OnAudioQuery onAudioQuery = OnAudioQuery();

// Function to check an request storage permission
Future<void> accessStorage() async => await Permission.storage.status.isGranted.then(
  (granted) async{
    if(granted == false){
      // request starage permission and open app settings if denied permanently
      PermissionStatus permissionStatus = await Permission.storage.request();
      if(permissionStatus == PermissionStatus.permanentlyDenied){
        await openAppSettings();
      }
    }
  }
);


// Function to retrieve artwork for a given song ID
Future<Uint8List?>  art({required int id}) async {
  return await onAudioQuery.queryArtwork(id, ArtworkType.AUDIO,quality: 100);
}


// Function to convert a Uri to an imge (Uint8List)
Future<Uint8List?> toImage({required Uri uri})async{
  return base64Decode(uri.data!.toString().split(',').last);
}


// Class to fetch songs and convet them to MediaItem format
class FetchSongs {
  // static methode to execute fetching songs asynchronously
  static Future<List<MediaItem>> execute() async {
    List<MediaItem> items = []; // initialize emty list to store MediaItems

    // Ensure storage permission granted before proceeding
    await accessStorage();
      
    // Query songs using OnAudioQuery
    List<SongModel> songs = await onAudioQuery.querySongs();

    // convert the songs to MediaItem 
    for(SongModel song in songs){
      if(song.isMusic == true){

        // retrieve artwork for the song
        Uint8List? uint8list = await art(id: song.id);
        List<int> bytes = [];
        if(uint8list != null){
          bytes = uint8list.toList();
        }

        // add the converted song to the list of MediaItems
        items.add(
          MediaItem(
            id: song.uri!, 
            title: song.title,
            artist: song.artist,
            duration: Duration(microseconds: song.duration!),
            artUri: uint8list == null ? null : Uri.dataFromBytes(bytes),
          )
        );

      }
    }
    return items;
  }

}

