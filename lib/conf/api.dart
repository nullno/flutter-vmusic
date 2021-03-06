/*数据接口*/
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';



// Set default configs
// or new Dio with a BaseOptions instance.
BaseOptions options = new BaseOptions(
  baseUrl: "https://musicapi.nullno.com",
  connectTimeout: 5000,
  receiveTimeout: 3000,
);

Dio dio = new Dio(options); // with default Options




//搜索
void search(parameters,resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/search",queryParameters:{"keywords":parameters['keywords'],"limit": 20,"offset":parameters['offset'],"type":parameters["type"]});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}
//搜索建议
void searchSuggest(parameters,resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/search/suggest",queryParameters:{"keywords":parameters['keywords'],"type":"mobile"});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}

//热搜榜
void searchHot(resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/search/hot/detail",);
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}


//歌曲排行榜
void getRank(resolve,[reject]) async {
  try {
    List<Response> response = await Future.wait([
        dio.get("/playlist/detail",queryParameters:{"id":"4395559"}),
        dio.get("/playlist/detail",queryParameters:{"id":"2617766278"}),
        dio.get("/playlist/detail",queryParameters:{"id":"3779629"}),
        dio.get("/playlist/detail",queryParameters:{"id":"3778678"}),
//        dio.get("/playlist/detail",queryParameters:{"id":"1978921795"}),
//        dio.get("/playlist/detail",queryParameters:{"id":"19723756"}),
        dio.get("/playlist/detail",queryParameters:{"id":"2884035"}),
        dio.get("/playlist/detail",queryParameters:{"id":"2250011882"})
    ]);
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}


//banner
void getBanner(resolve,reject) async {
  try {
    Response<dynamic> response = await dio.get("/banner",queryParameters:{"types": "1",});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}

//获取推荐歌单
void getPersonalizedSongList(resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/personalized",queryParameters:{"limit": 20});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}
void homeGet(resolve,[reject]) async{
  try{
    List<Response> response = await Future.wait([
      dio.get("/banner",queryParameters:{"types": "1",}),
      dio.get("/personalized",queryParameters:{"limit": 20})
    ]);
    resolve(jsonDecode(response.toString()));
  }catch(e){

  }

}


//精品歌单（歌单广场）
void getHighqualitySongList(parameters,resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/top/playlist/highquality",queryParameters:{"limit": 8,"before":parameters['before'],"cat":parameters["cat"]});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}

//获取歌单详情
void getSongMenuDetail(parameters,resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/playlist/detail",queryParameters:{"id":parameters["id"]});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}

//获取推荐mv
void getPersonalizedMV(resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/personalized/mv");
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}
//获取全部mv
void getAllMV(parameters,resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/mv/all",queryParameters:{"area":parameters['area'],"limit": 8,"offset":parameters['offset']});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}


//获取mv视频播放数据
void getMVDetail(mvId,resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/mv/detail",queryParameters:{"mvid":mvId});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}

//获取视频详情
void getVideoDetail(vid,resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/video/detail",queryParameters:{"id":vid});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}

//获取视频播放数据

void getVideoUrl(vid,resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/video/url",queryParameters:{"id":vid});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}

//获取mv评论
void getMvComment(vid,resolve,[reject]) async {

  try {
    Response<dynamic> response = await dio.get("/comment/mv",queryParameters:{"id":vid});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}

//获取视频评论
void getVideoComment(parameters,resolve,[reject]) async {

  try {
    var path  = parameters['type']==0?"/comment/mv":"/comment/video";
    Response<dynamic> response = await dio.get(path,queryParameters:{"id":parameters['vid'],"limit":20,"offset":parameters['offset'],"before":parameters['before']});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}

//获取歌曲详情
void getSongDetail(ids,resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/song/detail",queryParameters:{"ids":ids});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}

//获取歌曲播放链接
void getSongUrl(id,resolve,[reject]) async {
  try {
    Response<dynamic> response = await dio.get("/song/url",queryParameters:{"id":id});
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}