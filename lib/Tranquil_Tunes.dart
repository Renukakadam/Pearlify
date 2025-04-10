import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(TranquilTunesScreen());
}

class TranquilTunesScreen extends StatefulWidget {
  @override
  _TranquilTunesScreenState createState() => _TranquilTunesScreenState();
}

class _TranquilTunesScreenState extends State<TranquilTunesScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int currentTrackIndex = 0;

  List<String> tracks = [
    'assets/sounds/record1.mp3',
    'assets/sounds/record2.mp3',
    'assets/sounds/record3.mp3'
  ];

  List<String> gifs = [
    'assets/record1.gif',
    'assets/record2.gif',
    'assets/record3.gif'
  ];

  void playMusic() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(tracks[currentTrackIndex]));
  }

  void nextTrack() {
    setState(() {
      currentTrackIndex = (currentTrackIndex + 1) % tracks.length;
    });
    playMusic();
  }

  void prevTrack() {
    setState(() {
      currentTrackIndex =
          (currentTrackIndex - 1 + tracks.length) % tracks.length;
    });
    playMusic();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/Tranquil_Tunes_bg.png',
                fit: BoxFit.cover,
              ),
            ),

            // Back Button
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // Main Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "TRANQUIL TUNES",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Image.asset(
                  gifs[currentTrackIndex],
                  width: 350, // Slightly smaller for better layout
                  height: 350,
                ),
                SizedBox(height: 5), // Reduced space to move buttons up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous,
                          size: 60, color: Colors.white), // Bigger buttons
                      onPressed: prevTrack,
                    ),
                    SizedBox(width: 40), // Increased spacing
                    IconButton(
                      icon: Icon(Icons.skip_next,
                          size: 60, color: Colors.white), // Bigger buttons
                      onPressed: nextTrack,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
