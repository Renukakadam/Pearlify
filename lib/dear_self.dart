import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Optional if you're using user ID

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final List<String> backgroundImages = [
    'assets/20.png',
    'assets/21.png',
    'assets/22.png',
    'assets/23.png'
  ];
  TextEditingController _controller = TextEditingController();
  int currentPage = 0;

  String getCurrentDate() {
    return DateFormat('MMMM dd, yyyy').format(DateTime.now());
  }

  Future<void> saveJournalEntry() async {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    print("Saving journal for user: ${user?.uid ?? 'anonymous'}");
    print("Entry text: $text");

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('dear_self_entries')
          .add({
        'text': text,
        'date': DateTime.now(),
        'formattedDate': getCurrentDate(),
      });

      print("Journal saved!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Journal entry saved!')),
      );

      _controller.clear();
    } catch (e) {
      print("Error saving journal: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool isFirstPage = currentPage == 0;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImages[currentPage]),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground UI
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 Back Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                // 📅 Date & first day message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getCurrentDate(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (isFirstPage)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "It's your first day of journaling!",
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ✍️ Journal field
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: GoogleFonts.merriweather(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Write your journal entry here...",
                        hintStyle: TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),

                // 👉 Save button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: saveJournalEntry,
                      child: Text("Save"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade300,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

