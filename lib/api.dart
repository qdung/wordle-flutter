import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model.dart';

class ApiNetwork {
  final baseUrl = "https://wordle.votee.dev:8000";

  Future<List<APIResponse>>? guessRandomWord(String word, String seed) async {
    try {
      final uri = Uri.parse('$baseUrl/random?guess=$word&seed=$seed');
      print(uri);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        print(response.body);
        final jsonDecoded = jsonDecode(response.body);
        final data = List<APIResponse>.from(
            jsonDecoded.map((item) => APIResponse.fromJson(item)));
        print(data);
        return data;
      }
      return [];
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
