library flutter_page_video;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

class SimpleViewPlayer extends StatefulWidget {
  final String source;
  bool isFullScreen;
  final callback;

  SimpleViewPlayer(this.source, {this.isFullScreen: false,this.callback});

  @override
  _SimpleViewPlayerState createState() => _SimpleViewPlayerState();
}

class _SimpleViewPlayerState extends State<SimpleViewPlayer> {
  VideoPlayerController controller;
  VoidCallback listener;
  bool hideBottom = true;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
    controller = VideoPlayerController.network(widget.source);
    controller.initialize();
    controller.setLooping(true);
    controller.addListener(listener);
    controller.play();
    Screen.keepOn(true);
    if (widget.isFullScreen) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    Screen.keepOn(false);
    if (widget.isFullScreen) {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlayView(
        controller,
        allowFullScreen: !widget.isFullScreen,
          callback: widget.callback
      ),
    );
  }
}

class PlayView extends StatefulWidget {
  VideoPlayerController controller;
  bool allowFullScreen;
  final callback;
  PlayView(this.controller, {this.allowFullScreen: true,this.callback});

  @override
  _PlayViewState createState() => _PlayViewState();
}

class _PlayViewState extends State<PlayView> {
  VideoPlayerController get controller => widget.controller;
  bool hideBottom = true;

  void onClickPlay() {
    if (!controller.value.initialized) {
      return;
    }
    setState(() {
      hideBottom = false;
    });
    widget.callback();
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) {
          return;
        }
        if (!controller.value.initialized) {
          return;
        }
        if (controller.value.isPlaying && !hideBottom) {
          setState(() {
            hideBottom = true;
          });
        }
      });
      controller.play();
    }
  }

  void onClickFullScreen() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      // current portrait , enter fullscreen
      SystemChrome.setEnabledSystemUIOverlays([]);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      Navigator.of(context)
          .push(PageRouteBuilder(
        settings: RouteSettings(isInitialRoute: false),
        pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            ) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) {
              return Scaffold(
                resizeToAvoidBottomPadding: false,
                body: PlayView(controller),
              );
            },
          );
        },
      ))
          .then((value) {
        // exit fullscreen
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      });
    }
  }

  void onClickExitFullScreen() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      // current landscape , exit fullscreen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    if (controller.value.initialized) {
      final Size size = controller.value.size;
      return GestureDetector(
        child: Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Center(
                    child: AspectRatio(
                      aspectRatio: size.width / size.height,
                      child: VideoPlayer(controller),
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: hideBottom
                        ? Container()
                        : Opacity(
                      opacity: 1.0,
                      child: Container(
                          height: 25.0,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  child: controller.value.isPlaying
                                      ? Icon(
                                    Icons.pause,
                                    color: primaryColor,
                                  )
                                      : Icon(
                                    Icons.play_arrow,
                                    color: primaryColor,
                                  ),
                                ),
                                onTap: onClickPlay,
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Center(
                                    child: Text(
                                      "${controller.value.position.toString().split(".")[0]}",
                                      style:
                                      TextStyle(color: Colors.white),
                                    ),
                                  )),
                              Expanded(
                                         child:ClipRRect(
                                             borderRadius: BorderRadius.circular(20),
                                             child:VideoProgressIndicator(
                                           controller,
                                           allowScrubbing: true,
                                           padding: EdgeInsets.symmetric(
                                               horizontal: 0.1, vertical: 0.1),
                                           colors: VideoProgressColors(
                                               bufferedColor:Colors.black12,
                                               playedColor: Colors.redAccent),
                                         )) ,


                                  ),

                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Center(
                                    child: Text(
                                      "${controller.value.duration.toString().split(".")[0]}",
                                      style:
                                      TextStyle(color: Colors.white),
                                    ),
                                  )),
                              Container(
                                child: widget.allowFullScreen
                                    ? Container(
                                  child: MediaQuery.of(context)
                                      .orientation ==
                                      Orientation.portrait
                                      ? GestureDetector(
                                    child: Icon(
                                      Icons.fullscreen,
                                      color: primaryColor,
                                    ),
                                    onTap: onClickFullScreen,
                                  )
                                      : GestureDetector(
                                    child: Icon(
                                      Icons.fullscreen_exit,
                                      color: primaryColor,
                                    ),
                                    onTap:
                                    onClickExitFullScreen,
                                  ),
                                )
                                    : Container(),
                              )
                            ],
                          )),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: controller.value.isPlaying
                      ? Container()
                      : Icon(
                    Icons.play_arrow,
                    color: primaryColor,
                    size: 48.0,
                  ),
                )
              ],
            )),
        onTap: onClickPlay,
      );
    } else if (controller.value.hasError && !controller.value.isPlaying) {
      return Container(
        color: Colors.black,
        child: Center(
          child: RaisedButton(
            onPressed: () {
              controller.initialize();
              controller.setLooping(true);
              controller.play();
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: Text("play error, try again!"),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
