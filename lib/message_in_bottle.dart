import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MessageInBottleScreen extends StatefulWidget {
  @override
  _MessageInBottleScreenState createState() => _MessageInBottleScreenState();
}

class _MessageInBottleScreenState extends State<MessageInBottleScreen> {
  late VideoPlayerController _controller;
  TextEditingController _messageController = TextEditingController();
  bool _showMessage = true;
  bool _showVideo = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/floating_bottle.mp4")
      ..initialize().then((_) {
        setState(() {});
      });

    // Listen for video completion to navigate to home page
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        _redirectToHomePage();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _letItGo() {
    setState(() {
      _showMessage = false;
      _showVideo = true; // Show the video
    });

    _controller.play(); // Start video
  }

  void _redirectToHomePage() {
    Navigator.pop(context); // Redirect to home page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/bg.png",
              fit: BoxFit.cover,
            ),
          ),

          // Title at the Top
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Text(
              "Message in Bottle",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'DancingScript',
              ),
            ),
          ),

          // Old Paper with Text Box (Center)
          if (_showMessage)
            Center(
              child: Container(
                width: 320,
                height: 420,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/old_paper_texture.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _messageController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Write your worries here...",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[900],
                        fontFamily: 'DancingScript',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _letItGo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Let It Go",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Video Player when activated
          if (_showVideo)
            Positioned.fill(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),

          // Back Button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
