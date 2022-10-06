import 'package:flutter/material.dart';
import 'package:greenbondwatch/screens/bond_view.dart';
import 'package:firebase_database/firebase_database.dart';

Future<dynamic> getData() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('Bonds').get();
  return snapshot.value;
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future data;

  void updateBond(data, index) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Bond(bondName: data[index]),
        ));
  }

  @override
  void initState() {
    super.initState();
    data = getData();
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
            initialData: 'Wait',
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
                        child: const Text(
                          'Choose your green bond',
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                              fontSize: 25,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      const SizedBox(
                        width: 340,
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 450,
                        width: 340,
                        child: ListView.builder(
                          itemCount: (snapshot.data).length,
                          prototypeItem: ListTile(
                            title: Text((snapshot.data).first),
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
                                    (snapshot.data)[index],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // click to news summary page
                                  onTap: () {
                                    updateBond((snapshot.data), index);
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
