import 'package:flutter/material.dart';
import 'custom/news_window.dart';
import 'custom/tutorials_window.dart';
import 'custom/humanitarian_window.dart';
import 'providers/cities_provider.dart';
import 'utils/palette.dart';

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
        primarySwatch: Palette.primaryWhite,
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
          title: Text('Довідник'),
          bottom: TabBar(
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(
                13.0,
              ),
              color: Colors.black,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            controller: tabController,
            tabs: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Center(
                  child: Text('Новини'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Center(
                  child: Text('Довідка'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Center(
                  child: Text('Гумдопомога'),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            const NewsWindow(),
            const TutorialsWindow(),
            HumanitarianWindow(
              defaultCity: HumCity(code: 'Kyiv', name: 'Київ'),
            ),
          ],
        ),
      ),
    );
  }
}
