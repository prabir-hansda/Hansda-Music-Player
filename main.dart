import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hansda Music Player',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  List<SongModel> _songs = [];

  final YoutubePlayerController _youtubePlayerController =
      YoutubePlayerController(
    initialVideoId: 'dQw4w9WgXcQ', // example YouTube ID
    flags: YoutubePlayerFlags(autoPlay: false),
  );

  @override
  void initState() {
    super.initState();
    requestPermission();
    loadSongs();
  }

  void requestPermission() async {
    await Permission.storage.request();
  }

  void loadSongs() async {
    List<SongModel> songs = await _audioQuery.querySongs();
    setState(() {
      _songs = songs;
    });
  }

  void playSong(String uri) async {
    await _audioPlayer.setUrl(uri);
    _audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hansda Music Player')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_songs[index].title),
                  subtitle: Text(_songs[index].artist ?? "Unknown Artist"),
                  onTap: () => playSong(_songs[index].uri!),
                );
              },
            ),
          ),
          YoutubePlayer(
            controller: _youtubePlayerController,
            showVideoProgressIndicator: true,
          ),
        ],
      ),
    );
  }
}