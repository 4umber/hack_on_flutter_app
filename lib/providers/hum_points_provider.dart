import 'dart:convert';
import 'package:http/http.dart' as http;

class HumPoint {
  final String title;
  final String description;

  const HumPoint({required this.title, required this.description});
}

// http://127.0.0.1:8000/api/GetGum/kyiv
class HumPointsProvider {
  static Future<List<HumPoint>> getHumPoints(String city_code) async {
    final city = city_code.toLowerCase();
    final serverAddr = '10.0.2.2'; // 127.0.0.1
    final response = await http
        .get(Uri.parse('http://$serverAddr:8000/api/GetGum/$city'));
    List<HumPoint> points = [];

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      //print([0]['address']);
      for (var point in jsonData['content']) {
        points.add(HumPoint(title: point['address'], description: point['description']));
      }
      return points;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load humanitarian points');
    }
  }
}
