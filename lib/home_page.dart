import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'message_in_bottle.dart';
import 'necklace_of_pearl.dart';
import 'Tranquil_Tunes.dart';
import 'Breathing_exercise.dart';
import 'dear_self.dart';
import 'profile_page.dart'; // Make sure the file name matches!


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1c4686),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                // Floating Icons at the top-right corner
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.settings,
                              color: Colors.white, size: 30),
                          onPressed: () {},
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.account_circle, color: Colors.white, size: 30),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Top Quote
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    "“The best way to predict the future is to create it.”",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Ocean Animation (GIF)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/ocean_animation.gif"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Explore Pearlify Title
                Text(
                  "Explore Pearlify",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),

                // Horizontal Scroll Activity List
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ActivityCard(
                            title: "Message in a Bottle",
                            assetImagePath: "assets/Message_in_bottle.png",
                            bgColor: Colors.pink.shade100,
                            onTap: () =>
                                _navigateTo(context, MessageInBottleScreen())),
                        ActivityCard(
                            title: "Necklace of Pearl",
                            assetImagePath: "assets/necklace_of_pearls.png",
                            bgColor: Colors.blue.shade100,
                            onTap: () =>
                                _navigateTo(context, NecklaceOfPearlScreen())),
                        ActivityCard(
                            title: "Dear Self",
                            assetImagePath: "assets/Dear_Self.png",
                            bgColor: Colors.green.shade100,
                            onTap: () => _navigateTo(context, JournalPage())),
                        ActivityCard(
                            title: "Breathing Exercise",
                            assetImagePath: "assets/Breathing_exercise.png",
                            bgColor: Colors.purple.shade100,
                            onTap: () => _navigateTo(
                                context, BreathingExerciseScreen())),
                        ActivityCard(
                            title: "Tranquil Tunes",
                            assetImagePath: "assets/Tranquil_Tunes.png",
                            bgColor: Colors.orange.shade100,
                            onTap: () =>
                                _navigateTo(context, TranquilTunesScreen())),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}

// Activity Cards with Images and Light Background Colors
class ActivityCard extends StatelessWidget {
  final String title;
  final String assetImagePath;
  final Color bgColor;
  final VoidCallback onTap;

  const ActivityCard({
    required this.title,
    required this.assetImagePath,
    required this.bgColor,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20), // Adds space below the container
        child: Container(
          width: 150,
          height: 150,
          margin: EdgeInsets.only(right: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(assetImagePath, height: 90, width: 90),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 15), // Additional space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
