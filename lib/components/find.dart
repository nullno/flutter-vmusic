/*
推荐模块
 */
import 'package:flutter/material.dart';

class Find extends StatefulWidget{

  @override

  State createState() => new _Find();

}

class _Find extends State<Find> with SingleTickerProviderStateMixin{

  TabController controller;//tab控制器
  int _currentIndex = 0; //选中下标

  List<Map> adList = [{'title':'标题1','imgpath':'http://p1.music.126.net/h_G8a9xxeXTmwjcB8mR0pQ==/109951164372410150.jpg','link':''},
                       {'title':'标题1','imgpath':'http://p1.music.126.net/ifxuv3opkDlaljb2BDfT0Q==/109951164372452784.jpg','link':''},
                       {'title':'标题1','imgpath':'http://p1.music.126.net/5l0td3TZQg4pyX8oNdeaqA==/109951164372575001.jpg','link':''},];//tab集合

  @override
  void initState() {
    super.initState();
    //初始化controller并添加监听
    controller = TabController(initialIndex:0,length: adList.length, vsync: this);
    controller.addListener((){
      if (controller.index.toDouble() == controller.animation.value) {
        //赋值 并更新数据
        this.setState(() {
          _currentIndex = controller.index;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    //slide banner图
    Widget  slideBanner= TabBarView(
      controller: controller,
      children:  adList.map((item){
        return  Container(
          padding:EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
          child:ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(item['imgpath'],fit: BoxFit.cover,),),
         );

      }).toList()
    );
    return  Material(

      child: ListView(
          children: <Widget>[
            Container(
              height: 166.0,
              margin: EdgeInsets.fromLTRB(0.0, 10.0, 0, 10.0),
              color: Colors.white,
              child: slideBanner,
            ),
            Text('DFBDFBF'),


          ],
      ),

    );
  }
}