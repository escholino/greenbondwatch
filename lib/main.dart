import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:greenbondwatch/screens/home.dart';
import 'package:greenbondwatch/screens/login.dart';
import 'package:greenbondwatch/screens/news_view.dart';
import 'package:greenbondwatch/screens/project_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(initialRoute: '/Login', routes: {
    '/Home': (context) => const Home(),
    '/Login': (context) => const GoogleLoginScreen(),
    '/Project': ((context) => const Project(
          bond: null,
          project: null,
        )),
    '/News': ((context) => const News(
          bond: null,
          project: null,
          newsDateIdx: null,
        )),
  }));
}
