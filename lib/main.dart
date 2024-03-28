import 'package:flutter/material.dart';
import 'package:song/component/chanson_edit.dart';
import 'package:song/component/chanson_list.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white30))
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          // useMaterial3: true,
          ),
      home: ChansonListScreen(),
    );
  }
}
