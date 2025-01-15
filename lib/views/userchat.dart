import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/controllers/ChatMessages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatelessWidget {
  
  ChatScreen([this.currentid="unkown",this.currenttype="user",this.name="undefined"]);

  String currentid;
  String? currenttype;
  String name;
  bool makesound=false;



  TextEditingController controller=TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
  
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).cardColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(name),
    ),
    body: Column(
      children: [
        Expanded(
       
          child: StreamBuilder<List<Widget>>(
            stream: getChatMessages(context,currentid,currenttype),
            builder: (context, snapshot) {
      
            // Check the connection state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No users found.'));
            } else {
              makesound=true;
              return ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16.0),
                children: snapshot.data!, // Display the widgets
              );
            }
            },
          ),
        ),
        _buildInputArea(context),
      ],
    ),
  );
}




  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
           Expanded(
            child: TextField(
              controller: controller,
              decoration:const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon:  Icon(Icons.send,color: Colors.blue[400],),
            onPressed: () async {
              if(controller.text.trim().isNotEmpty){
                makesound=false;
              await sendMessage(controller.text, currentid,currenttype);
               scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
controller.clear();

              }

            },
          ),
        ],
      ),
    );
  }
}

  // Play sound alert function
  Future<void> _playSound() async {
     AudioPlayer _audioPlayer = AudioPlayer();
    await _audioPlayer.play(AssetSource('sounds/alert.wav')); // Replace with your sound file
  }