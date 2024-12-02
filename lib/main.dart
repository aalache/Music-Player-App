import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

// import your custom pages and services
import 'package:musicplayer/pages/home_page.dart';
import 'package:musicplayer/services/my_audio_handler.dart';

// create an instance of MyAudioHandler
MyAudioHandler _audioHandler = MyAudioHandler();

// main function , the entry pont of the app
Future<void> main()async{
  // Ensure flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AudioService with MyAudioHandler as the audio handler
  _audioHandler = await AudioService.init(
    builder:() => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.musicplayer.example',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );

  // Run the application and set the preferred orientation to portrait
  runApp(const MainApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


}

// MainApp class , a stateless widget representing the main application

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // set the theme to dark
      theme: ThemeData.dark(),
      // set the home page to HomePage with the initialized audio handler
      home: HomePage(audioHandler:  _audioHandler),
    );
  }
}
