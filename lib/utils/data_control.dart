import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thr_client/models/models.dart';
import 'dart:convert';

import 'package:thr_client/utils/config.dart';
import 'package:video_player/video_player.dart';



class SimpleCache {

  static Map<String, User> users = {};    // username : User
  static Map<int, Post> posts = {};   // postID : Post
  static Map<String, Image> attachments = {};   // attachment_url : Image
  static Map<String, VideoPlayerController> mediaControllers = {};

  static void disposeAllMediaControllers() {
    var list = mediaControllers.values.toList();
    list.map((e) {
      e.dispose();
    },);
  }

}


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
      if (SimpleCache.posts.containsKey(postIDs[i])) {
        result.add(SimpleCache.posts[postIDs[i]]!);
        continue;
      }
      http.Response response = await http.get(Uri.parse("${Config.apiURL}/posts/${postIDs[i]}/"));
      var body = jsonDecode(response.body);
      if (body["error"] == null) {
        Post post = Post.fromMap(body["result"]);
        SimpleCache.posts[postIDs[i]] = post;
        result.add(post);
      }
      else {
        throw 'Error in getCategories: ${body["error"]}';
      }
    }

    return result;
  }

  static Future<Post> getPost(int postID) async {
    http.Response response = await http.get(Uri.parse("${Config.apiURL}/posts/$postID/"));
    var map = jsonDecode(response.body)["result"];
    if (map != null) {
      Post post = Post.fromMap(map);
      SimpleCache.posts[postID] = post;
      return post;
    }
    return Post.empty();
  }

  static Future<User?> getUser(String name) async {
    http.Response response = await http.get(Uri.parse("${Config.apiURL}/users/$name/"));
    var body = jsonDecode(response.body);

    // failed
    if (body["error"] != null) {
      print('Unable to fetch user with username: $name');
      return null;
    }
    
    var map = body["result"];
    if (map != null) {
      // success
      SimpleCache.users[name] = User.fromMap(map);
      return User.fromMap(map);
    }
    return null;
  }

  static Future<String?> whoami(String token) async {
    http.Response response = await http.get(
      Uri.parse("${Config.apiURL}/whoami/"),
      headers: {"Authorization": token}
    );
    var body = jsonDecode(response.body);
    if (body["error"] == null) {
      return body["result"];
    }
    return null;
  }

  static Future<bool> updateSettings({
    String? newBio,
  }) async {
    print("token = ${Config.token!}");
    if (newBio == null) {
      return false;
    }
    Map<String, dynamic> requestBody = {
      "bio": newBio
    };
    http.Response response =  await http.post(
      Uri.parse("${Config.apiURL}/settings/"),
      headers: {
        "Authorization": Config.token!,
      },
      body: requestBody,
    );
    if (response.statusCode != 200) {
      throw "Error in DataController.updateSettings: statusCode=${response.statusCode} headers=${response.headers}";
    }

    // fetch new User data (mostly for new bio)
    Config.loggedinAccount = await getUser(Config.loggedinAccount!.name);
    return true;

  }

  static Future<List<InboxInfo>> getInboxes(String? token) async {
    token ??= Config.token;

    http.Response response = await http.get(
      Uri.parse("${Config.apiURL}/inbox"),
      headers: {
        "Authorization": token!,
      }
    );
    if (response.statusCode != 200) {
      throw "Error in DataController.getInboxes: statusCode=${response.statusCode} headers=${response.headers}";
    }
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body["error"] != null) {
      throw "Error in DataController.getInboxses: error=${body['error']}";
    }

    List<InboxInfo> returnList = [];
    for (int i=0; i<body["result"]!.length; i++) {
      //InboxInfo newInboxInfo = InboxInfo.fromMap(body["result"]![i]);

      InboxInfo newInboxInfo = InboxInfo(
        await getPost(body["result"]![i]["replying_to"]), 
        Post.fromMap(body["result"]![i])
      );
      returnList.add(newInboxInfo);
    }
    return returnList;
  }

  // request a delete thru api

}