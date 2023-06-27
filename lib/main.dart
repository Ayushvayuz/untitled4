import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:untitled4/Dio+Hive_Database/Provider/ApiCall.dart';
import 'Dio+Hive_Database/Screens/view_screen.dart';
import 'Dio+Hive_Database/model_class.dart';
import 'hive/view_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ApiCall())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ViewPage(),
    );
  }
}
