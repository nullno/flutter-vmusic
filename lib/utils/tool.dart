//工具方法
import 'package:flutter/material.dart';
import 'dart:ui';

/*
数字转换
 int num
*/

 tranNumber(int num){
   String result ="0";
    if(num<10000){
      result = num.toDouble().toStringAsFixed(0);
    }
    if( num>=10000){
      result = (num/10000).toStringAsFixed(0) +'万';
    }
    if( num>=100000000){
      result = (num/100000000).toStringAsFixed(0) +'亿';
    }
    return   result;
}

/*
视频链接https 分辨率url
*/
videoUrl(dynamic url){
  String newUrl="https://source.nullno.com/blog/220050677efa8a64c018ef48289ea236a0c11531882000114a12be221fc.mp4";
  if(url.containsKey("1080")){
    newUrl = url['1080'];
  }else if(url.containsKey("720")){
    newUrl = url['720'];

  }else if(url.containsKey("480")){
    newUrl = url['480'];

  }else if(url.containsKey("240")){
    newUrl =  url['240'];
  }
  return newUrl.replaceAll('http:', 'https:');

}

/*
视频毫秒数
* */
formatDuration(int t) {
  if (t < 60000) {
    return ((t % 60000) / 1000).toStringAsFixed(0) + "s";
  } else if ((t >= 60000) && (t < 3600000)) {
    String s=((t % 3600000) / 60000)>=10?((t % 3600000) / 60000).toStringAsFixed(0):"0"+((t % 3600000) / 60000).toStringAsFixed(0);
    String m=((t % 60000) / 1000)>=10?((t % 60000) / 1000).toStringAsFixed(0):"0"+((t % 3600000) / 60000).toStringAsFixed(0);
    return s+":" +m;
  } else {
    //小时用不上
    return(t / 3600000).toStringAsFixed(0) + ":" + ((t % 3600000) / 60000).toStringAsFixed(0) +
        ":" + ((t % 60000) / 1000).toStringAsFixed(0);
  }
}

/*
* 时间戳转字符串
* */

tranTimestr(int timestamp){

  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp); //时间戳为10位需*1000，时间戳为13位的话不需乘1000
  var Y = date.year.toString() + '-';
  var M = (date.month < 10 ? '0' + (date.month).toString() : (date.month).toString()) + '-';
  var D = date.day.toString() + ' ';
  var h = date.hour.toString() + ':';
  var m = date.minute < 10 ?'0' +date.minute.toString()+ '':date.minute.toString()+ '';
  var s = date.second  < 10 ? '0' + date.second.toString() : date.second.toString();

  return Y + M + D;
}
/*

*音乐播放时间进度处理
return string
 */

 tranDuration(Duration d){

   if(d==null){
     return "00:00";
   }
   String t='';
   if(d.inHours>0){
     t = d.toString().split('.')[0];
   }else{
     t = d.toString().split('.')[0].substring(2,7);
   }
   return t;
 }

 /*
*搜索文字高亮
 */

keywordsHighlight(String keywords,String str){

  List<dynamic>   fg = str.split('/<br>/');

  List<TextSpan>  newArr=[];
   int index=0;
   fg.forEach((itemA){
     String nitem = itemA.replaceAll(keywords,'<b>'+keywords+'<b>');
     List<dynamic>  sword =   nitem.split('<b>');
     index++;
       sword.forEach((itemB) {
         if(itemB!=''){
           if(index==1){
               if (itemB == keywords && fg[0].contains(keywords)) {
                 newArr.add(TextSpan(text: keywords, style: TextStyle(color: Colors.blueAccent, fontSize: 13.0)),);
               } else if (fg[0].contains(itemB)) {
                 newArr.add(TextSpan(text: itemB, style: TextStyle(color: Colors.black, fontSize: 13.0)));
               }
           }
           if(index==2) {
             if (itemB == keywords && fg[1].contains(keywords)) {
               newArr.add(TextSpan(text: keywords,
                   style: TextStyle(
                       color: Colors.blueAccent, fontSize: 10.0, height: 1.5)));
             } else if (fg[1].contains(itemB)) {
               newArr.add(TextSpan(text: itemB,
                   style: TextStyle(
                       color: Colors.grey, fontSize: 10.0, height: 1.5)));
             }
           }
         }
       });
   });


 return RichText(
     text: TextSpan(style: TextStyle(fontSize: 13.0),
    children:newArr,
  )
 );

}

/*

屏幕相关
 */
class Adapt {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;
  static double _topbarH = mediaQuery.padding.top;
  static double _botbarH = mediaQuery.padding.bottom;
  static double _pixelRatio = mediaQuery.devicePixelRatio;
  static var _ratio;
  static init(int number){
    int uiwidth = number is int ? number : 750;
    _ratio = _width / uiwidth;
  }
  static px(number){
    if(!(_ratio is double || _ratio is int)){Adapt.init(750);}
    return number * _ratio;
  }
  static onepx(){
    return 1/_pixelRatio;
  }
  static screenW(){
    return _width;
  }
  static screenH(){
    return _height;
  }
  static padTopH(){
    return _topbarH;
  }
  static padBotH(){
    return _botbarH;
  }
}