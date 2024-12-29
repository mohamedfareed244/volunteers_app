import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/controllers/ChatsController.dart';
import 'package:volunteers_app/screens/AuthWrapper.dart';
import 'package:volunteers_app/views/WelcomeScreen.dart';
import 'package:volunteers_app/views/userchat.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Call loadChats function and return the result
    return FutureBuilder<Widget>(
      future: loadChats(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const Center(child: Text('No data available.'));
        }
      },
    );
  }
}

bool _isFirstLoad = true;

Future<Widget> loadChats(BuildContext context) async {
  String? Currentuid = FirebaseAuth.instance.currentUser?.uid;
  if (Currentuid == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false, //removes all the existing routes from the stack
      );
    });

    return const Center(child: Text('Logging out...'));
  }
  String? userRole = await AuthWrapper.getUserRole(Currentuid);

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.amber,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
      ),
      title: const Text('Chats'),
      centerTitle: true,
    ),
    body: LayoutBuilder(
      builder: (context, constraints) {
        // Check orientation
        bool isPortrait = constraints.maxWidth < 600;

        return Container(
          color: Colors.white,
          child: StreamBuilder<List<Widget>>(
            stream: userRole == 'user'
                ? getUsersOrganizations(Currentuid, context)
                : getOrganizationUsers(Currentuid, context), // Fetching users as a stream
            builder: (context, snapshot) {
              // Play sound only on updates, not initial load
              if (!_isFirstLoad &&
                  snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                _playSound(); // Play sound on updates only
              }

              // Mark as loaded after first load
              if (_isFirstLoad && snapshot.connectionState == ConnectionState.active) {
                _isFirstLoad = false; // Reset flag after initial load
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No users found.'));
              } else {
                // Return the responsive list of widgets
                return isPortrait
                    ? ListView( // Portrait view
                        padding: const EdgeInsets.all(16.0),
                        children: snapshot.data!,
                      )
                    : GridView.count( // Landscape view
                        crossAxisCount: 2, // Two columns in landscape mode
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        padding: const EdgeInsets.all(16.0),
                        children: snapshot.data!,
                      );
              }
            },
          ),
        );
      },
    ),
  );
}

// Play sound alert function
Future<void> _playSound() async {
  AudioPlayer _audioPlayer = AudioPlayer();
  await _audioPlayer.play(AssetSource('sounds/alert.wav')); // Replace with your sound file
}
