
import 'package:audioplayers/audioplayers.dart';
/// 应用程序状态

class AppState{

  //音乐控制
   static Map player ={
              "id":0,
             "url":'未知',
             "face":'https://p1.music.126.net/N2whh2Prf0l8QHmCpShrcQ==/19140298416347251.jpg',
             "name":'未知',
             "singer":'未知',
             "duration":null,
             "position":null,
             "loop":true,
             "playStatus":false,
             "audioPlayer":new AudioPlayer(),
             "play":(url,[callback]) async{
                 int result = await AppState.player['audioPlayer'].play(url.replaceAll('http:', 'https:'));
                 if(result==1) {
                     if(callback)callback();
                 }
               },
              "pause":([callback]) async{
                int result = await AppState.player['audioPlayer'].pause();
                if(result==1) {
                    if(callback)callback();
                }
              }
        };


}


