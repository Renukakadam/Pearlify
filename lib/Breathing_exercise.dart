import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(BreathingExerciseScreen());
}

class BreathingExerciseScreen extends StatefulWidget {
  @override
  _BreathingExerciseScreenState createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int totalTime = 60;
  int secondsLeft = 60;
  Timer? _timer;
  String breathingText = "Inhale...";
  bool isRunning = true;
  bool isPaused = false;
  int breathingPhase = 0; // 0: Inhale, 1: Hold, 2: Exhale

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 120, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (secondsLeft > 0 && isRunning) {
        setState(() {
          secondsLeft -= 2;
          breathingPhase = (breathingPhase + 1) % 3;

          if (breathingPhase == 0) {
            breathingText = "Inhale...";
          } else if (breathingPhase == 1) {
            breathingText = "Hold...";
          } else {
            breathingText = "Exhale...";
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void pauseOrResume() {
    setState(() {
      isPaused = !isPaused;
      if (isPaused) {
        _timer?.cancel();
        _controller.stop();
      } else {
        startTimer();
        _controller.repeat(reverse: true);
      }
    });
  }

  void restartExercise() {
    setState(() {
      isRunning = true;
      isPaused = false;
      secondsLeft = totalTime;
      breathingPhase = 0;
      breathingText = "Inhale...";
      _controller.repeat(reverse: true);
      startTimer();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.shade900,
                    Colors.blue.shade600,
                    Colors.cyan.shade300
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
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

            // Title (Fixed)
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "1-Minute Breathing Exercise",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // UI Elements
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),

                  // Circular Progress with Pause/Resume button inside
                  GestureDetector(
                    onTap: pauseOrResume,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: (totalTime - secondsLeft) / totalTime,
                            strokeWidth: 8,
                            backgroundColor: Colors.white24,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Container(
                              width: _animation.value,
                              height: _animation.value,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  isPaused ? Icons.play_arrow : Icons.pause,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Breathing Instructions
                  Text(
                    breathingText,
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),

                  SizedBox(height: 20),

                  // Timer Display
                  Text(
                    "$secondsLeft sec",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),

                  SizedBox(height: 30),

                  // Restart Button
                  ElevatedButton(
                    onPressed: restartExercise,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text("Restart",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
