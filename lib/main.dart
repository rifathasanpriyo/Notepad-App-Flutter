import 'package:flutter/material.dart';
import 'package:flutter_application_1/note_pad.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Box box= await Hive.openBox('notepad');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotePad(),
      theme: ThemeData( 
        textTheme: GoogleFonts.openSansTextTheme( 
          Theme.of(context).textTheme.apply(),
        )
      ),
    );
  }
}
