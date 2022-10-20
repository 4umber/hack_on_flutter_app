import 'package:flutter/material.dart';
import '../providers/tutorials_provider.dart';
import '../utils/error_toast.dart';

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
  late ErrorToast errToast;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    futureTutors = TutorialsProvider.getTutorials(last_id);
    errToast = ErrorToast(context);
  }

  Card buildTutorial(Tutorial tutor) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        textColor: Colors.black,
        collapsedTextColor: Colors.black,
        title: Text(
          tutor.title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        expandedAlignment: Alignment.centerLeft,
        children: <Widget>[
          Text(
            tutor.description,
            style: TextStyle(
            fontSize: 14,
          ),
          ),
        ],
      ),
    );
  }

  Widget buildTutorsList() {
    Widget w;

    if (tutors.isNotEmpty) {
      w = ListView.builder(
        itemCount: tutors.length,
        itemBuilder: (context, index) {
          return buildTutorial(tutors.elementAt(index));
        },
      );
    } else {
      w = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('Тут пусто :('),
        ],
      );
    }
    return w;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Tutorial>>(
      future: futureTutors,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
              tutors.insertAll(0, snapshot.data!);
              final max = snapshot.data!.reduce((curr, next) => curr.id > next.id? curr: next);
              snapshot.data!.clear();
              last_id = max.id;
            }
        } else if (snapshot.hasError) {
          Future.delayed(Duration.zero, () {
            errToast.showErrorToast('Помилка з\'єднання', 1);
          });
        }
        return buildTutorsList();
      },
    );
  }
}
