// ignore_for_file: non_constant_identifier_names

import 'package:thr_client/utils/config.dart';

class Post {
  int? ID;
  int? threadID;
  int? categoryID;
  int? replyingToPostID;
  String? author;
  String? content;
  String? attachmentURL;
  String? fileType;
  String? creationDate;
  bool hasAudio = false;
  bool deleted = false;

  Post(this.ID, this.threadID, this.categoryID, this.replyingToPostID,
    this.author, this.content,
    this.attachmentURL, this.fileType,
    this.creationDate, this.deleted);
  Post.empty();

  factory Post.fromMap(Map<String, dynamic> map) {
    String? filetype = Config.getFiletype(map["attachment_url"]);
    if (filetype == null) {
      map["attachment_url"] = null;
    }
    
    return Post(
      map["id"],
      map["thread_id"],
      map["cat_id"],
      map["replying_to"],
      map["author"],
      map["content"],
      map["attachment_url"],
      filetype,
      map["creation_date"].replaceAll("T", " "),
      map["deleted"]
    );
  }

  void delete() {
    deleted = true;
    // invoke api call to delete in server
  }
}

class Thread {
  int? ID;
  int? categoryID;
  String? title;
  String? content;
  String? author;
  String? creationDate;
  int views = 0;
  bool deleted = false;
  String? attachmentURL;  
  String? fileType;
  List<int> postIDs = [];

  Thread(this.ID, this.categoryID, this.title,
    this.content, this.author, this.creationDate,
    this.views, this.deleted,
    this.attachmentURL, this.fileType,
    this.postIDs);

  Thread.empty();

  factory Thread.fromMap(Map<String, dynamic> map) {
    String? filetype = Config.getFiletype(map["attachment_url"]);
    if (filetype == null) {
      map["attachment_url"] = null;
    }

    return Thread(
      map["id"],
      map["cat_id"],
      map["title"],
      map["content"],
      map["creator"],
      map["creation_date"].replaceAll("T", " "),
      map["views"],
      map["deleted"],
      map["attachment_url"],
      filetype,
      map["posts"].cast<int>()
    );
  }

  void delete() {
    deleted = true;
    // request a delete through api
  }
}

class Category {
  int? ID;
  String? title;
  String? description;
  bool deleted = false;
  List<int> threadIDs = [];

  Category(this.ID, this.title, this.description, this.deleted, this.threadIDs);
  
  Category.empty();

  factory Category.fromMap(Map<String, dynamic> map) =>
    Category(map["id"], map["title"], map["description"],
      map["deleted"], map["threads"].cast<int>());

  void delete() {
    deleted = true;
    // request a delete through api
  }
}