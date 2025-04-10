import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class WellnessPage extends StatefulWidget {
  @override
  _WellnessPageState createState() => _WellnessPageState();
}

class _WellnessPageState extends State<WellnessPage>
    with SingleTickerProviderStateMixin {
  String selectedFeeling = "Happy";
  List<String> selectedMindset = [];

  final List<Map<String, String>> feelings = [
    {"label": "Happy", "emoji": "😊"},
    {"label": "Excited", "emoji": "🤩"},
    {"label": "Calm", "emoji": "😌"},
    {"label": "Tired", "emoji": "😴"},
    {"label": "Stressed", "emoji": "😣"},
    {"label": "Sad", "emoji": "😢"},
  ];

  final List<String> mindsets = [
    "Gratitude",
    "Positivity",
    "Patience",
    "Focus",
    "Creativity",
    "Kindness"
  ];

  void saveMoodToFirestore(String mood, List<String> mindsets) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final timeNow = DateFormat('hh:mm a').format(DateTime.now());

      final moodEntry = {
        'date': today,
        'mood': mood,
        'mindsets': mindsets,
        'time': timeNow,
      };

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('moods')
            .doc(today)
            .set(moodEntry);

        print("🔥 Mood saved for user $uid: $moodEntry");
      } catch (e) {
        print("❌ Error saving mood: $e");
      }
    } else {
      print("❌ User not signed in");
    }
  }


  void toggleMindsetSelection(String mindset) {
    setState(() {
      if (selectedMindset.contains(mindset)) {
        selectedMindset.remove(mindset);
      } else if (selectedMindset.length < 3) {
        selectedMindset.add(mindset);
      }
    });
  }

  void onContinue() {
    if (selectedMindset.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select at least one mindset!"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // 🔍 ADD THIS LINE:
      print(FirebaseAuth.instance.currentUser?.uid);
      saveMoodToFirestore(selectedFeeling, selectedMindset);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("How are you feeling today?",
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: feelings.map((feeling) {
                final isSelected = selectedFeeling == feeling["label"];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFeeling = feeling["label"]!;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.blue.shade800,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ]
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(feeling["emoji"]!,
                            style: TextStyle(
                              fontSize: 24,
                            )),
                        SizedBox(width: 8),
                        Text(feeling["label"]!,
                            style: GoogleFonts.poppins(
                              color: isSelected
                                  ? Colors.blue.shade900
                                  : Colors.white,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Text("What mindset do you want to bring into today?",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: mindsets.map((mindset) {
                bool isSelected = selectedMindset.contains(mindset);
                return GestureDetector(
                  onTap: () => toggleMindsetSelection(mindset),
                  child: Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(mindset,
                            style: GoogleFonts.poppins(
                              color: isSelected
                                  ? Colors.blue.shade900
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                            )),
                        if (isSelected)
                          Icon(Icons.check,
                              color: Colors.blue.shade900, size: 18),
                      ],
                    ),
                    backgroundColor:
                    isSelected ? Colors.white : Colors.blue.shade800,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: onContinue,
              child: Text("Continue",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900)),
            ),
          ],
        ),
      ),
    );
  }
}
