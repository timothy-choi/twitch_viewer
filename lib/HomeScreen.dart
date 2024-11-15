import 'package:flutter/material.dart';
import 'ApiService.dart';
import 'StreamScreenPage.dart';

class HomeScreen extends StatelessWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Twitch Viewer"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search live streams...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) {

              },
            ),
          ),
        ),
      ),
      body: StreamListWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {

        },
      ),
    );
  }
}

class StreamListWidget extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: apiService.getLiveStreams(10),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No live streams found"));
        } else {
          final liveStreams = snapshot.data!;
          return ListView.builder(
            itemCount: liveStreams.length,
            itemBuilder: (context, index) {
              final stream = liveStreams[index];
              return StreamCard(
                streamTitle: stream['title'] ?? 'No Title',
                streamerName: stream['user_name'] ?? 'Unknown Streamer',
                thumbnailUrl: stream['thumbnail_url']?.replaceAll('{width}', '150').replaceAll('{height}', '150') ?? '',
                streamUrl: 'https://player.twitch.tv/?channel=${stream['user_name']}&parent=localhost',
                streamId: stream['id'] ?? '',
              );
            },
          );
        }
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
    required this.streamId,
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
              builder: (context) => StreamPage(
                streamId: streamId,
                streamUrl: streamUrl,
                title: streamTitle,
                isLive: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
