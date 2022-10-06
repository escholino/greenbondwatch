import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

Future<dynamic> getData(bondName) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child(bondName).get();
  return snapshot.value;
}

class Bond extends StatefulWidget {
  final String bondName;
  const Bond({Key? key, required this.bondName}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Bond();
  }
}

class _Bond extends State<Bond> {
  late Future data;
  dynamic bondName;

  void updateProject(projects, index) async {
    Navigator.pushNamed(context, '/Project',
        arguments: {'bond': bondName, 'project': projects[index]});
  }

  @override
  void initState() {
    super.initState();
    bondName = widget.bondName;
    data = getData(bondName);
  }

  @override
  Widget build(BuildContext context) {
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
            initialData: '$bondName',
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
                  // put in here what needs to be shown when there is data
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
                            '$bondName',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 340,
                        height: 10,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 240, 240, 240),
                        ),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(5.0),
                        width: 340,
                        child: Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Color.fromARGB(255, 153, 224, 118),
                              ),
                              width: (snapshot.data['total_status']
                                      ['complete']) *
                                  340 /
                                  snapshot.data['total_status']['total'],
                              height: 50,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Color.fromARGB(255, 228, 78, 93),
                              ),
                              // make here the 1 to canceld when in database
                              width: (snapshot.data['total_status']
                                      ['canceled']) *
                                  340 /
                                  snapshot.data['total_status']['total'],
                              height: 50,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 340,
                        height: 20,
                      ),
                      FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '''
Issuer: ${(snapshot.data)['general_information']['issuer']} 
Bank: ${(snapshot.data)['general_information']['bank']}
Start of Bond: ${(snapshot.data)['general_information']['start_of_bond']}
Tenor: ${(snapshot.data)['general_information']['tenor']}
Volume: ${(snapshot.data)['general_information']['volume']}
                            ''',
                              maxLines: 14,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          )),
                      const SizedBox(
                        width: 340,
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 177, 173, 173),
                        ),
                        width: 340,
                        height: 50,
                        child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Projetcs',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            )),
                      ),

                      Container(
                        width: 340,
                        height: 10,
                        alignment: Alignment.center,
                      ),
                      // make here scrollable list of the news titles
                      Container(
                        alignment: Alignment.center,
                        height: 300,
                        width: 340,
                        child: ListView.builder(
                          itemCount:
                              (snapshot.data)['projects']['Projects'].length,
                          prototypeItem: ListTile(
                            title: Text(
                              (snapshot.data)['projects']['Projects'].first,
                              overflow: TextOverflow.ellipsis,
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
                                  title: Text(
                                    (snapshot.data)['projects']['Projects']
                                        [index],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    updateProject(
                                        (snapshot.data)['projects']['Projects'],
                                        index);
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
      ),
    );
  }
}
