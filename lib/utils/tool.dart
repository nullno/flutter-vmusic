//工具方法


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