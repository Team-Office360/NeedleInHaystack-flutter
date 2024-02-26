import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseURL = dotenv.env["CLIENT_BASE_URL"].toString();
  final String autoCompletions = "auto-completions";

  Future<List<String>> getAutoCompletions(String userInput) async {
    final url = Uri.parse("$baseURL/$autoCompletions?userInput=$userInput");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<String> searchHistories =
          jsonDecode(response.body)["searchHistories"].cast<String>();

      return searchHistories;
    }
    throw Error();
  }

  Future<Map<String, dynamic>> getVideos(
      String query, bool shouldCheckSpell, int pageParam) async {
    final url = Uri.parse("$baseURL/keywords/");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userInput': query.split("+"),
        'shouldCheckSpell': shouldCheckSpell,
        'pageParam': pageParam,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      return responseData;
    }
    throw Error();
  }
}
