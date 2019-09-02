import 'package:flutter/material.dart';


//路由渐变
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page}) : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}

//入出路由动画
class EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  EnterExitRoute({this.exitPage, this.enterPage})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    enterPage,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Stack(
          children: <Widget>[
            FadeTransition(
              opacity: new Tween(
                begin:1.0,
                end: 0.0,
              ).animate(animation),
              child: exitPage,
            ),
            SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: enterPage,
            )
          ],
        ),
  );
}

//自定义路由动画
class CustomRoute extends PageRouteBuilder {
  final Widget widget;
  CustomRoute(this.widget) : super(
      transitionDuration: const Duration(seconds: 1),
      pageBuilder: (BuildContext context, Animation<double> animation1,
          Animation<double> animation2) {
        return widget;
      },
      transitionsBuilder: (BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
          Widget child) {
        //缩放
//        return ScaleTransition(
//            scale:Tween(begin:0.0,end:1.0).animate(CurvedAnimation(
//                parent:animation1,
//                curve: Curves.fastOutSlowIn
//            )),
//            child:child
//        );
        //旋转+缩放路由动画
//        return RotationTransition(
//            turns:Tween(begin:0.0,end:1.0)
//                .animate(CurvedAnimation(
//                parent: animation1,
//                curve: Curves.fastOutSlowIn
//            )),
//            child:ScaleTransition(
//              scale:Tween(begin: 0.0,end:1.0)
//                  .animate(CurvedAnimation(
//                  parent: animation1,
//                  curve:Curves.fastOutSlowIn
//              )),
//              child: child,
//            )
//        );
        //左右滑动路由动画
//              return SlideTransition(
//                position: Tween<Offset>(
//                        begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
//                    .animate(CurvedAnimation(
//                        parent: animation1, curve: Curves.fastOutSlowIn)),
//                child: child,
//              );

        return FadeTransition(
          opacity: Tween(begin:0.0,end :1.0).animate(CurvedAnimation(
              parent:animation1,
              curve:Curves.fastOutSlowIn
          )),
          child: child,
        );
      });
}

