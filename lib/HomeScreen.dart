import 'package:flutter/material.dart';
import 'StreamScreenPage.dart';

class HomeScreen extends StatelessWidget {
  final String title;

  const HomeScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Twitch Viewer"),
      ),
      body: StreamListWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          // add code to handle tab switch to navigate to different screens
        },
      ),
    );
  }
}

class StreamListWidget extends StatelessWidget {
  //keep for now
  final List<Map<String, String>> streams = List.generate(10, (index) => {
    'streamTitle': 'Stream $index Title',
    'streamerName': 'Streamer $index',
    'thumbnailUrl': 'https://via.placeholder.com/150',  // Replace with actual image URLs if available
    'streamUrl': 'https://player.twitch.tv/?channel=streamername&parent=localhost',  // Replace with real Twitch URLs
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: streams.length,
      itemBuilder: (context, index) {
        return StreamCard(
          streamTitle: streams[index]['streamTitle']!,
          streamerName: streams[index]['streamerName']!,
          thumbnailUrl: streams[index]['thumbnailUrl']!,
          streamUrl: streams[index]['streamUrl']!,
          streamId: streams[index]['streamId']!
        );
      },
    );
  }
}

class StreamCard extends StatelessWidget {
  final String streamTitle;
  final String streamerName;
  final String thumbnailUrl;
  final String streamUrl;
  final String streamId;

  const StreamCard({
    required this.streamTitle,
    required this.streamerName,
    required this.thumbnailUrl,
    required this.streamUrl,
    required this.streamId
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Image.network(thumbnailUrl, width: 80, height: 80, fit: BoxFit.cover),
        title: Text(streamTitle),
        subtitle: Text(streamerName),
        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamPage(streamId: streamId, streamUrl: streamUrl, title: streamTitle, isLive: true),
            ),
          );
        },
      ),
    );
  }
}
