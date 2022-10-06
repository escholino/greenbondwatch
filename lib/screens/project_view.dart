// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

Future<dynamic> getData(bondName, project) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final snapshot =
      await ref.child(bondName).child('projects').child(project).get();
  return snapshot.value;
}

class Project extends StatefulWidget {
  const Project({super.key, required this.bond, required this.project});
  final bond;
  final project;
  @override
  State<StatefulWidget> createState() {
    return _Project();
  }
}

class _Project extends State<Project> {
  late Future data;
  dynamic info;

  @override
  void initState() {
    super.initState();
  }

  void goToNews(bond, project, newsDateIdx) async {
    Navigator.pushNamed(context, '/News', arguments: {
      'bond': bond,
      'project': project,
      'newsDateIdx': newsDateIdx
    });
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
                          height: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '${info['project']}',
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                  fontSize: 25,
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 340,
                          height: 10,
                        ),
                        Container(
                          width: 340,
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            'The ${snapshot.data['Type']} project ${snapshot.data['Name']}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                        Container(
                          width: 340,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'is ${snapshot.data['Status']}',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0)),
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
                          width: 340,
                          height: 50,
                          child: const Text(
                            'Interesting News',
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                        const SizedBox(
                          width: 340,
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 400,
                          width: 340,
                          child: ListView.builder(
                            itemCount:
                                (snapshot.data['news']['news_title']).length,
                            prototypeItem: ListTile(
                              title: Text(
                                (snapshot.data['news']['news_title']).first,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color.fromARGB(255, 240, 240, 240),
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      height: 80,
                                      width: 90,
                                      alignment: Alignment.topCenter,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                            '${(snapshot.data['news']['news_date'])[index]}'),
                                      ),
                                    ),
                                    dense: true,
                                    title: Text(
                                      '${(snapshot.data['news']['news_title'])[index]}',
                                      overflow: TextOverflow.fade,
                                    ),
                                    // click to news summary page
                                    onTap: () {
                                      goToNews(
                                          info['bond'], info['project'], index);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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
