import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class NecklaceOfPearlScreen extends StatefulWidget {
  @override
  _NecklaceOfPearlScreenState createState() => _NecklaceOfPearlScreenState();
}

class _NecklaceOfPearlScreenState extends State<NecklaceOfPearlScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isSubmitting = false;

  final ConfettiController _confettiController =
  ConfettiController(duration: const Duration(seconds: 3));

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> submitGratitude() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _controller.text.trim().isEmpty) return;

    setState(() => isSubmitting = true);

    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Save the gratitude entry
      await userDoc.collection('gratitude_entries').add({
        'text': _controller.text.trim(),
        'timestamp': Timestamp.now(),
      });

      // Get current pearl and necklace count
      final snapshot = await userDoc.get();
      int currentPearlCount = snapshot.data()?['pearlCount'] ?? 0;
      int currentNecklaceCount = snapshot.data()?['necklaceCount'] ?? 0;

      int newPearlCount = currentPearlCount + 1;
      int newNecklaceCount = currentNecklaceCount;

      bool completedNecklace = false;

      if (newPearlCount % 10 == 0) {
        newNecklaceCount += 1;
        completedNecklace = true;
      }

      await userDoc.set({
        'pearlCount': newPearlCount,
        'necklaceCount': newNecklaceCount,
      }, SetOptions(merge: true));

      _controller.clear();

      // Get image and celebration data
      final pearlImagePath = completedNecklace
          ? 'assets/necklace/pearl_11.png'
          : 'assets/necklace/pearl_${(newPearlCount % 10 == 0 ? 10 : newPearlCount % 10)}.png';

      if (completedNecklace) {
        _confettiController.play();
      }

      showDialog(
        context: context,
        builder: (context) => Stack(
          children: [
            Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff142b47),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    )
                  ],
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      completedNecklace
                          ? "🌟 You completed your necklace!"
                          : "✨ You earned a pearl!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFAF0),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        pearlImagePath,
                        width: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      completedNecklace
                          ? "Your necklace is complete! Let this string of gratitude remind you of your beautiful journey 💖"
                          : "Your pearl necklace just got a little shinier 🐚\nKeep going, beautiful soul!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFFFAF0),
                      ),
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff1c4686),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Continue"),
                    ),
                  ],
                ),
              ),
            ),
            if (completedNecklace)
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  emissionFrequency: 0.05,
                  numberOfParticles: 30,
                  maxBlastForce: 25,
                  minBlastForce: 10,
                  gravity: 0.2,
                  shouldLoop: false,
                  colors: const [
                    Colors.pinkAccent,
                    Colors.lightBlue,
                    Colors.yellow,
                    Colors.white
                  ],
                ),
              ),
          ],
        ),
      );
    } catch (e) {
      print("Error submitting gratitude: $e");
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeaf6ff),
      appBar: AppBar(
        backgroundColor: Color(0xff1c4686),
        title: Text("Necklace of Pearl"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What are you grateful for today?",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Write here...",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1c4686),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: isSubmitting ? null : submitGratitude,
                child: isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "Submit & Earn Pearl",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFFFAF0), // Light creamy white
                    fontWeight: FontWeight.w600, // Optional: makes it a bit bolder
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
