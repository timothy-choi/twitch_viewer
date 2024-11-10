import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String title;

  const HomeScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Twitch Viewer"),
      ),
      body: StreamListWidget(),  // Custom widget to show a list of streams
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          // Handle tab switch to navigate to different screens
        },
      ),
    );
  }
}

class StreamListWidget extends StatelessWidget {
  // Sample data for streams
  final List<Map<String, String>> streams = List.generate(10, (index) => {
    'streamTitle': 'Stream $index Title',
    'streamerName': 'Streamer $index',
    'thumbnailUrl': 'https://via.placeholder.com/150',  // Replace with actual image URLs if available
    'streamUrl': 'https://player.twitch.tv/?channel=streamername&parent=localhost',  // Replace with real Twitch URLs
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: streams.length,  // Use the length of streams list
      itemBuilder: (context, index) {
        // Pass each stream's data to the StreamCard
        return StreamCard(
          streamTitle: streams[index]['streamTitle']!,
          streamerName: streams[index]['streamerName']!,
          thumbnailUrl: streams[index]['thumbnailUrl']!,
          streamUrl: streams[index]['streamUrl']!,
        );
      },
    );
  }
}

// StreamCard widget to display each stream preview
class StreamCard extends StatelessWidget {
  final String streamTitle;
  final String streamerName;
  final String thumbnailUrl;
  final String streamUrl;

  const StreamCard({
    required this.streamTitle,
    required this.streamerName,
    required this.thumbnailUrl,
    required this.streamUrl,
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
          // Navigate to the live stream page on tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamPage(streamUrl: streamUrl),
            ),
          );
        },
      ),
    );
  }
}
