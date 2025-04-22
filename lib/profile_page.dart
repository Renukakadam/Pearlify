import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> moodData = [];
  int necklaceCount = 0;

  @override
  void initState() {
    super.initState();
    fetchMoodStats();
    fetchNecklaceAchievements();
  }

  Future<void> fetchMoodStats() async {
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('moods')
          .orderBy('date')
          .get();

      setState(() {
        moodData = snapshot.docs.map((doc) => doc.data()).toList();
      });
    }
  }

  Future<void> fetchNecklaceAchievements() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (doc.exists) {
        int necklace = doc.data()?['necklaceCount'] ?? 0;
        print("📿 Fetched necklace count: $necklace");

        setState(() {
          necklaceCount = necklace;
        });
      } else {
        print("⚠️ User document not found.");
      }
    } else {
      print("⚠️ User not logged in.");
    }
  }




  int calculateStreak() {
    int streak = 0;
    DateTime today = DateTime.now();

    for (int i = moodData.length - 1; i >= 0; i--) {
      DateTime date = DateFormat('yyyy-MM-dd').parse(moodData[i]['date']);
      if (today.difference(date).inDays == streak) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  Widget moodChart() {
    if (moodData.isEmpty) return Text("No mood data yet!", style: GoogleFonts.poppins(color: Colors.white));

    List<FlSpot> spots = [];
    for (int i = 0; i < moodData.length; i++) {
      String mood = moodData[i]['mood'];
      double moodValue = moodToValue(mood);
      spots.add(FlSpot(i.toDouble(), moodValue));
    }

    return LineChart(LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.cyan,
          barWidth: 4,
          dotData: FlDotData(show: true),
        )
      ],
    ));
  }

  double moodToValue(String mood) {
    switch (mood) {
      case 'Happy':
        return 5;
      case 'Excited':
        return 4.5;
      case 'Calm':
        return 4;
      case 'Tired':
        return 3;
      case 'Stressed':
        return 2;
      case 'Sad':
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final streak = calculateStreak();

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Your Profile",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Avatar + Name
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue.shade900, size: 40),
            ),
            SizedBox(height: 10),
            Text(user?.email ?? 'No Name',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),

            SizedBox(height: 30),

            // Streak Card


            SizedBox(height: 30),

            // Achievements Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🏅 Achievements",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  necklaceCount > 0
                      ? Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(necklaceCount, (index) {
                      int imageNumber = 11 + index; // pearl_11.png to pearl_20.png
                      return Column(
                        children: [
                          Image.asset(
                            'assets/necklace/pearl_$imageNumber.png',
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, color: Colors.white),
                          ),
                          SizedBox(height: 4),
                          Text("Necklace ${index + 1}",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                              )),
                        ],
                      );
                    }),
                  )
                      : Text("No necklaces earned yet!",
                      style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.7))),

                ],
              ),
            ),

            SizedBox(height: 30),

            // Mood Graph
            Text("Mood Trend",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: moodChart()),

            Spacer(),

            // Optional button to go to full stats page
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to full stats page
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: Text("View Detailed Stats",
                  style: GoogleFonts.poppins(color: Colors.blue.shade900)),
            )
          ],
        ),
      ),
    );
  }
}
