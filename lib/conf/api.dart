/*数据接口*/
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';



// Set default configs
// or new Dio with a BaseOptions instance.
BaseOptions options = new BaseOptions(
  baseUrl: "https://source.nullno.com/music/",
  connectTimeout: 5000,
  receiveTimeout: 3000,
);

Dio dio = new Dio(options); // with default Options


void getRank(resolve,reject) async {
  try {

    List<Response> response = await Future.wait([
        dio.get("api.php",queryParameters:{"types":"playlist","id":"4395559"}),
        dio.get("api.php",queryParameters:{"types":"playlist","id":"2617766278"}),
        dio.get("api.php",queryParameters:{"types":"playlist","id":"3779629"}),
        dio.get("api.php",queryParameters:{"types":"playlist","id":"3778678"}),
        dio.get("api.php",queryParameters:{"types":"playlist","id":"1978921795"}),
        dio.get("api.php",queryParameters:{"types":"playlist","id":"19723756"}),
        dio.get("api.php",queryParameters:{"types":"playlist","id":"2884035"}),
        dio.get("api.php",queryParameters:{"types":"playlist","id":"2250011882"})
    ]);
    resolve(jsonDecode(response.toString()));
  } catch (e) {
    reject(e);
  }
}