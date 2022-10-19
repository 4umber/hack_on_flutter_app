import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom/news_window.dart';
import 'custom/tutorials_window.dart';
import 'custom/humanitarian_window.dart';
import 'providers/cities_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final _prefs = SharedPreferences.getInstance();
  String city = '';
  List<HumCity> cities = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Довідник $city'),
          bottom: TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                text: 'Новини',
              ),
              Tab(
                text: 'Довідка',
              ),
              Tab(
                text: 'Гумдопомога',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            const NewsWindow(),
            const TutorialsWindow(),
            HumanitarianWindow(defaultCity: HumCity(code: 'Kyiv', name: 'Київ'),),
          ],
        ),
      ),
    );
  }
}
