import 'package:flutter/material.dart';
import 'package:flutter_vmusic/conf/router.dart';
import 'package:flutter_vmusic/pages/landing_page.dart';



void main(){
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            debugShowCheckedModeBanner: false,
            title:'vmusic',
            theme: new ThemeData(
              primaryColor: Colors.white,
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