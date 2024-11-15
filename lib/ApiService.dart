import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl = "https://localhost:9004";
  final String clientId = dotenv.env['TWITCH_CLIENT_ID'] ?? '';
  final String accessToken = dotenv.env['TWITCH_ACCESS_TOKEN'] ?? '';

  Future<List<Map<String, dynamic>>> getLiveStreams(int count) async {
    final usersResponse = await http.get(Uri.parse('$baseUrl/users/'));

    if (usersResponse.statusCode != 200) {
      throw Exception('Failed to load users: ${usersResponse.statusCode}');
    }

    final List<dynamic> users = jsonDecode(usersResponse.body);
    final List<Map<String, dynamic>> liveStreams = [];

    for (var user in users) {
      final String? twitchUsername = user["twitchUsername"] as String?;

      if (twitchUsername != null && twitchUsername.isNotEmpty) {
        final Uri liveStreamUrl = Uri.parse("https://api.twitch.tv/helix/streams?user_login=$twitchUsername");

        final liveStreamResponse = await http.get(
          liveStreamUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Client-ID': clientId,
          },
        );

        if (liveStreamResponse.statusCode != 200) {
          continue;
        }

        final Map<String, dynamic> liveStreamData = jsonDecode(liveStreamResponse.body);

        if (liveStreamData["data"] != null && liveStreamData["data"].isNotEmpty) {
          liveStreams.add(liveStreamData["data"][0] as Map<String, dynamic>);
        }

        if (liveStreams.length >= count) break;
      }
    }

    return liveStreams;
  }
}
