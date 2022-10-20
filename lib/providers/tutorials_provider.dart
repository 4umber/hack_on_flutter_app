import 'dart:convert';
import 'package:http/http.dart' as http;

class Tutorial {
  final String title;
  final String description;
  final int id;

  const Tutorial({required this.title, required this.description, required this.id});
}

// http://127.0.0.1:8000/api/GetReferences/0
class TutorialsProvider {
  static Future<List<Tutorial>> getTutorials(int last_id) async {
    final serverAddr = '10.0.2.2'; // 127.0.0.1
    final response = await http
        .get(Uri.parse('http://$serverAddr:8000/api/GetReferences/$last_id'));
    List<Tutorial> tutors = [];

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      print(jsonData);
      for (var n in jsonData['content']) {
        tutors.add(Tutorial(title: n['title'], description: n['descript'], id: n['id']));
      }
      return tutors;
    } else {
      throw Exception('Failed to load tutorials');
    }
  }
}
