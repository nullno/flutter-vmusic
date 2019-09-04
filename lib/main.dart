import 'package:flutter/material.dart';
import 'package:flutter_vmusic/conf/router.dart';
import 'package:flutter_vmusic/conf/platform.dart';
import 'package:flutter_vmusic/pages/landing_page.dart';



class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends  State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'vmusic',
      theme: new ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.black45,
        accentColorBrightness: Brightness.light,
      ),
      home: LandingPage(),
      color:Colors.white,
      routes: Router.routes,
      initialRoute: Router.initialRoute,
    );
  }
}

void main(){

  runApp(MyApp());
  SYS.systemUI(Colors.transparent,Colors.black);
}
