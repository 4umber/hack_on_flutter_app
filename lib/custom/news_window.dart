import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/news_provider.dart';
import '../utils/error_toast.dart';

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
  late ErrorToast errToast;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    futureNews = NewsProvider.getNews(last_id);
    // TODO: update last id
    errToast = ErrorToast(context);
  }

  swipeDownRefresh() {
    //news.insert(0, buildNews(index));
    //index++;
    futureNews = NewsProvider.getNews(last_id);
  }

  Card buildNews(News news) {
    return Card(
      margin: EdgeInsets.all(1),
      child: ListTile(
        title: Text(
          news.title,
          style: TextStyle(
            fontSize: 16,
          ),
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
    Widget w;

    if (news.isNotEmpty) {
      w = ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return buildNews(news.elementAt(index));
        },
      );
    } else {
      w = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ListView(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text('Тут пусто :('),
            ],
          ),
        ],
      );
    }
    return w;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Colors.black,
      child: FutureBuilder<List<News>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            news.insertAll(0, snapshot.data!);
            snapshot.data!.clear();
            // TODO: update last id
          } else if (snapshot.hasError) {
            Future.delayed(Duration.zero, () {
              errToast.showErrorToast('Помилка з\'єднання', 1);
            });
          }
          return buildNewsList();
        },
      ),
      onRefresh: () async {
        await Future<void>(swipeDownRefresh);
        setState(() {});
      },
    );
  }
}
