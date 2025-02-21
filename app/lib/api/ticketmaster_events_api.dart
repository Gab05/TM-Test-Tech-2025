import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/model/simple_event.dart';

class TicketmasterEventsApi {
  const TicketmasterEventsApi({
    required this.client
  });

  final http.Client client;
  final String baseUrl = "https://app.ticketmaster.com/discovery/v2/events";

  Future<String> _buildEventUrl(String? eventID, BuildContext? context) async {
    final String secret = await DefaultAssetBundle.of(context!).loadString('auth/secret.json');
    String apiKey = (await json.decode(secret))["api_key"];

    return "$baseUrl/$eventID.json?apikey=$apiKey";
  }

  Future<SimpleEvent?> fetchEvent(String? eventID, BuildContext? context) async {
    String url = await _buildEventUrl(eventID, context);

    final eventResponse = await client.get(Uri.parse(url));
    final jsonPayload = jsonDecode(eventResponse.body) as Map<String, dynamic>;

    if (eventResponse.statusCode == 200) {
      return SimpleEvent(
        name: jsonPayload['name'],
        date: jsonPayload['dates']['start']['dateTime']
      );
    } else {
      throw Exception('Failed to fetch event');
    }
  }

}