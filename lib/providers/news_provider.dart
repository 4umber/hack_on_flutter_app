import 'dart:convert';
import 'package:http/http.dart' as http;

class News {
  final String title;
  final String link;
  final int id;

  const News({required this.title, required this.link, required this.id});
}

// http://127.0.0.1:8000/api/GetNews/0
class NewsProvider {
  static Future<List<News>> getNews(int last_id) async {
    final serverAddr = '10.0.2.2'; // 127.0.0.1
    final response = await http
        .get(Uri.parse('http://$serverAddr:8000/api/GetNews/$last_id'));
    List<News> news = [];

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      print(jsonData);
      for (var n in jsonData['content']) {
        news.add(News(title: n['title'], link: n['link'], id: n['id']));
      }
      news.sort((a, b) => b.id.compareTo(a.id));
      return news;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
