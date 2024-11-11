import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String profileImageUrl;
  final String username;
  final String description;
  final List<Map<String, String>> liveStreams; // Each live stream has a title and URL
  final List<Map<String, String>> recordedStreams;

  const ProfilePage({
    Key? key,
    required this.profileImageUrl,
    required this.username,
    required this.description,
    required this.liveStreams,
    required this.recordedStreams,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(
              profileImageUrl: profileImageUrl,
              username: username,
              description: description,
            ),
            if (liveStreams.isNotEmpty) ...[
              const SizedBox(height: 20),
              LiveStreamsSection(liveStreams: liveStreams),
            ],
            const SizedBox(height: 20),
            PreviousStreamsSection(recordedStreams: recordedStreams),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String profileImageUrl;
  final String username;
  final String description;

  const ProfileHeader({
    Key? key,
    required this.profileImageUrl,
    required this.username,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LiveStreamsSection extends StatelessWidget {
  final List<Map<String, String>> liveStreams;

  const LiveStreamsSection({Key? key, required this.liveStreams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Live Streams',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: liveStreams.map((stream) {
              final title = stream['title'] ?? 'Untitled Stream';
              final url = stream['streamUrl'] ?? '';
              return LiveStreamCard(title: title, streamUrl: url);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class LiveStreamCard extends StatelessWidget {
  final String title;
  final String streamUrl;

  const LiveStreamCard({Key? key, required this.title, required this.streamUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: const Text('Tap to watch live'),
        onTap: streamUrl.isNotEmpty
            ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamPage(streamUrl: streamUrl),
            ),
          );
        }
            : null,
      ),
    );
  }
}

class PreviousStreamsSection extends StatelessWidget {
  final List<Map<String, String>> recordedStreams;

  const PreviousStreamsSection({Key? key, required this.recordedStreams})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Previous Streams',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: recordedStreams.map((stream) {
              return RecordedStreamCard(
                title: stream['title'] ?? 'Untitled',
                thumbnailUrl: stream['thumbnailUrl'] ?? '',
                streamUrl: stream['streamUrl'] ?? '',
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class RecordedStreamCard extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final String streamUrl;

  const RecordedStreamCard({
    Key? key,
    required this.title,
    required this.thumbnailUrl,
    required this.streamUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(
          thumbnailUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        title: Text(title),
        onTap: streamUrl.isNotEmpty
            ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamPage(streamUrl: streamUrl),
            ),
          );
        }
            : null,
      ),
    );
  }
}