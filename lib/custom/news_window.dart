import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/news_provider.dart';

class NewsWindow extends StatefulWidget {
  const NewsWindow({super.key});

  @override
  State<NewsWindow> createState() => _NewsWindowState();
}

class _NewsWindowState extends State<NewsWindow>
    with AutomaticKeepAliveClientMixin {
  //List<Widget> news = [];
  int last_id = 104;
  late Future<List<News>> futureNews;
  List<News> news = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    futureNews = NewsProvider.getNews(last_id);
    // TODO: update last id
  }

  swipeDownRefresh() {
    //news.insert(0, buildNews(index));
    //index++;
    futureNews = NewsProvider.getNews(last_id);
  }

  Card buildNews(News news) {
    return Card(
      child: ListTile(
        title: Text(
          news.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        onTap: () async {
          var uri = Uri.parse(news.link);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
      ),
    );
  }

  Widget buildNewsList() {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        return buildNews(news.elementAt(index));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      child: FutureBuilder<List<News>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            news.insertAll(0, snapshot.data!);
            snapshot.data!.clear();
            // TODO: update last id
            //return buildNewsList();
          } /*else if (snapshot.hasError) {
            return buildNewsList(); // Text('${snapshot.error}');
          }*/
          return buildNewsList(); // const CircularProgressIndicator();
        },
      ),
      onRefresh: () async {
        await Future<void>(swipeDownRefresh);
        setState(() {});
      },
    );
  }
}
