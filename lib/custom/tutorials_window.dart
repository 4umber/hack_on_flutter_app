import 'package:flutter/material.dart';
import '../providers/tutorials_provider.dart';

class TutorialsWindow extends StatefulWidget {
  const TutorialsWindow({super.key});

  @override
  State<TutorialsWindow> createState() => _TutorialsWindowState();
}

class _TutorialsWindowState extends State<TutorialsWindow>
    with AutomaticKeepAliveClientMixin {
  int last_id = 0;
  late Future<List<Tutorial>> futureTutors;
  List<Tutorial> tutors = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    futureTutors = TutorialsProvider.getTutorials(last_id);
    // TODO: update last id
  }

  Card buildTutorial(Tutorial tutor) {
    return Card(
      child: ExpansionTile(
        title: Text(
          tutor.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        expandedAlignment: Alignment.centerLeft,
        children: <Widget>[
          Text(
            tutor.description,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget buildTutorsList() {
    return ListView.builder(
      itemCount: tutors.length,
      itemBuilder: (context, index) {
        return buildTutorial(tutors.elementAt(index));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Tutorial>>(
      future: futureTutors,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          tutors.insertAll(0, snapshot.data!);
          snapshot.data!.clear();
          //return buildNewsList();
        } /*else if (snapshot.hasError) {
            return buildNewsList(); // Text('${snapshot.error}');
          }*/
        return buildTutorsList(); // const CircularProgressIndicator();
      },
    );
  }
}
