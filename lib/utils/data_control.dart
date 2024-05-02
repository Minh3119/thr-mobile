import 'package:http/http.dart' as http;
import 'package:thr_client/models/models.dart';
import 'dart:convert';

import 'package:thr_client/utils/config.dart';

class DataController {
  
  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    http.Response response = await http.get(Uri.parse("${Config.apiURL}/categories/"));
    return jsonDecode(response.body)["result"];
  }

  static Future<List<Category>> getCategories() async {
    http.Response response = await http.get(Uri.parse("${Config.apiURL}/categories/"));
    Map<String, dynamic> body = jsonDecode(response.body);
    var maps = body["result"];

    if (maps == null) {
      print('maps equals to null!!!!!');
      return getCategories();
    }

    List<Category> result = [];

    for (int i=0; i<maps.length; i++) {
      result.add(Category.fromMap(maps[i]));
    }

    if (body["error"] == null) {
      return result;
    }
    else {
      throw 'Error in getCategories: ${body["error"]}';
    }
    
  }

  static Future<List<Thread>> getThreads(int categoryID, {List<int>? threadIDs}) async {
    if (threadIDs == null) {
      threadIDs = [];
      http.Response response = await http.get(Uri.parse("${Config.apiURL}/categories/"));
      List<Map<String, dynamic>> responseResult = jsonDecode(response.body)["result"];
      for (int i=0; i<responseResult.length; i++) {
        if (responseResult[i]["id"] == categoryID) {
          threadIDs.add(responseResult[i]["thread"]);
        }
      }
    }

    List<Thread> result = [];
    for (int i=0; i<threadIDs.length; i++) {
      http.Response response = await http.get(Uri.parse("${Config.apiURL}/threads/${threadIDs[i]}/"));
      var body = jsonDecode(response.body);
      if (body["error"] == null) {
        result.add(Thread.fromMap(body["result"]));
      }
      else {
        throw 'Error in getCategories: ${body["error"]}';
      }
    }

    return result;
  }

  static Future<List<Post>> getPosts(int threadID, {List<int>? postIDs}) async {
    if (postIDs == null) {
      postIDs = [];
      http.Response response = await http.get(Uri.parse("${Config.apiURL}/threads/$threadID/"));
      postIDs = jsonDecode(response.body)["result"]["posts"];      
    }

    List<Post> result = [];
    for (int i=0; i<postIDs!.length; i++) {
      http.Response response = await http.get(Uri.parse("${Config.apiURL}/posts/${postIDs[i]}/"));
      var body = jsonDecode(response.body);
      if (body["error"] == null) {
        result.add(Post.fromMap(body["result"]));
      }
      else {
        throw 'Error in getCategories: ${body["error"]}';
      }
    }

    return result;
  }

  // request a delete thru api

}