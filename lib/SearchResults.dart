import 'package:flutter/material.dart';
import 'StreamScreenPage.dart';

class SearchResultsPage extends StatefulWidget {
  final String initialSearchTerm;

  const SearchResultsPage({super.key, required this.initialSearchTerm});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late String searchTerm;

  @override
  void initState() {
    super.initState();
    searchTerm = widget.initialSearchTerm;
  }

  void performSearch(String newSearchTerm) {
    setState(() {
      searchTerm = newSearchTerm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) {
                performSearch(value);
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    performSearch(searchTerm);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Users section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Users for "$searchTerm"',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  UserSearchResultList(searchTerm: searchTerm),

                  // Live streams section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Live Streams for "$searchTerm"',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  LiveStreamSearchResultList(searchTerm: searchTerm),

                  // Recorded streams section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Recorded Streams for "$searchTerm"',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  RecordedStreamSearchResultList(searchTerm: searchTerm),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for displaying a list of user search results based on the search term
class UserSearchResultList extends StatelessWidget {
  final String searchTerm;
  UserSearchResultList({required this.searchTerm});

  final List<Map<String, String>> allUsers = List.generate(5, (index) => {
    'username': 'User$index',
    'profileImageUrl': 'https://via.placeholder.com/80',
  });

  @override
  Widget build(BuildContext context) {
    final filteredUsers = allUsers
        .where((user) => user['username']!.contains(searchTerm))
        .toList();
    return Column(
      children: filteredUsers
          .map((user) => UserSearchResult(
        username: user['username']!,
        profileImageUrl: user['profileImageUrl']!,
      ))
          .toList(),
    );
  }
}

class UserSearchResult extends StatelessWidget {
  final String username;
  final String profileImageUrl;

  const UserSearchResult({
    required this.username,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profileImageUrl),
      ),
      title: Text(username),
      onTap: () {
        // Navigate to user profile page if desired
      },
    );
  }
}

class LiveStreamSearchResultList extends StatelessWidget {
  final String searchTerm;
  LiveStreamSearchResultList({required this.searchTerm});

  final List<Map<String, String>> allLiveStreams = List.generate(5, (index) => {
    'streamTitle': 'Live Stream $index',
    'streamerName': 'Streamer $index',
    'thumbnailUrl': 'https://via.placeholder.com/150',
    'streamUrl': 'https://player.twitch.tv/?channel=streamername&parent=localhost',
  });

  @override
  Widget build(BuildContext context) {
    final filteredLiveStreams = allLiveStreams
        .where((stream) => stream['streamTitle']!.contains(searchTerm))
        .toList();
    return Column(
      children: filteredLiveStreams
          .map((stream) => LiveStreamSearchResult(
        streamTitle: stream['streamTitle']!,
        streamerName: stream['streamerName']!,
        thumbnailUrl: stream['thumbnailUrl']!,
        streamUrl: stream['streamUrl']!,
        streamId: stream['streamId']!
      ))
          .toList(),
    );
  }
}

class LiveStreamSearchResult extends StatelessWidget {
  final String streamTitle;
  final String streamerName;
  final String thumbnailUrl;
  final String streamUrl;
  final String streamId;

  const LiveStreamSearchResult({
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
              builder: (context) => StreamPage(
                streamId: streamId,
                title: streamTitle,
                streamUrl: streamUrl,
                isLive: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

class RecordedStreamSearchResultList extends StatelessWidget {
  final String searchTerm;
  RecordedStreamSearchResultList({required this.searchTerm});

  final List<Map<String, String>> allRecordedStreams = List.generate(5, (index) => {
    'streamTitle': 'Recorded Stream $index',
    'streamerName': 'Streamer $index',
    'thumbnailUrl': 'https://via.placeholder.com/150',
    'streamUrl': 'https://player.twitch.tv/?channel=streamername&parent=localhost',
  });

  @override
  Widget build(BuildContext context) {
    final filteredRecordedStreams = allRecordedStreams
        .where((stream) => stream['streamTitle']!.contains(searchTerm))
        .toList();
    return Column(
      children: filteredRecordedStreams
          .map((stream) => RecordedStreamSearchResult(
        streamTitle: stream['streamTitle']!,
        streamerName: stream['streamerName']!,
        thumbnailUrl: stream['thumbnailUrl']!,
        streamUrl: stream['streamUrl']!,
        streamId: stream['streamId']!
      ))
          .toList(),
    );
  }
}

class RecordedStreamSearchResult extends StatelessWidget {
  final String streamTitle;
  final String streamerName;
  final String thumbnailUrl;
  final String streamUrl;
  final String streamId;

  const RecordedStreamSearchResult({
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
              builder: (context) => StreamPage(
                streamId: streamId,
                title: streamTitle,
                streamUrl: streamUrl,
                isLive: false,
              ),
            ),
          );
        },
      ),
    );
  }
}