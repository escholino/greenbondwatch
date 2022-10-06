// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

Future<dynamic> getData(bondName, project) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref
      .child(bondName)
      .child('projects')
      .child(project)
      .child('news')
      .get();
  return snapshot.value;
}

// ignore: duplicate_ignore
class News extends StatefulWidget {
  const News(
      {super.key,
      required this.bond,
      required this.project,
      required this.newsDateIdx});
  final bond;
  final project;
  final newsDateIdx;
  @override
  State<StatefulWidget> createState() {
    return _News();
  }
}

class _News extends State<News> {
  late Future data;
  dynamic info;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final info = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    dynamic data = getData(info['bond'], info['project']);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Green Bond Tracker'),
          backgroundColor: const Color.fromARGB(255, 153, 224, 118),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(children: [
            FutureBuilder<dynamic>(
              future: data,
              initialData: '${info['project']}',
              builder: (
                BuildContext context,
                AsyncSnapshot<dynamic> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      Visibility(
                        visible: snapshot.hasData,
                        child: const Text('Result: waiting'),
                      )
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 340,
                          height: 20,
                        ),
                        Container(
                          // ignore: prefer_const_constructors
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: const Color.fromARGB(255, 153, 224, 118),
                          ),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(5.0),
                          width: 340,
                          height: 60,
                          child: Text(
                            '${info['project']}',
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                                fontSize: 25,
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                        const SizedBox(
                          width: 340,
                          height: 10,
                        ),
                        Container(
                          // ignore: prefer_const_constructors
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: const Color.fromARGB(255, 177, 173, 173),
                          ),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(5.0),
                          width: 200,
                          height: 40,
                          child: Text(
                            '${snapshot.data['news_date'][info['newsDateIdx']]}',
                            style: const TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                        const SizedBox(
                          width: 340,
                          height: 50,
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color.fromARGB(255, 219, 213, 213),
                          ),
                          width: 340,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data['news_title'][info['newsDateIdx']],
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              height: 60,
                              child: ElevatedButton(
                                // ignore: deprecated_member_use
                                onPressed: (() => launch(
                                    snapshot.data['news_article_link']
                                        [info['newsDateIdx']])),
                                child: const Text('Open News Article'),
                              ),
                            ))
                        // add here the buttons to change the status
                      ],
                    );
                  } else {
                    return const Text('Empty data');
                  }
                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              },
            ),
          ]),
        ));
  }
}
