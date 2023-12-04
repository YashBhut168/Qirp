class ReelsDataModel {
  bool? status;
  String? message;
  List<Data>? data;

  ReelsDataModel({this.status, this.message, this.data});

  ReelsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? title;
  String? description;
  String? postPic;
  String? thumbnail;
  String? songName;
  String? userName;
  String? profilePic;
  int? totalLikes;
  String? totalComments;
  String? createdAt;
  int? totalViewCount;
  bool? isReelLike;

  Data(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.postPic,
      this.thumbnail,
      this.songName,
      this.userName,
      this.profilePic,
      this.totalLikes,
      this.totalComments,
      this.createdAt,
      this.totalViewCount,
      this.isReelLike});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    postPic = json['post_pic'];
    thumbnail = json['thumbnail'];
    songName = json['song_name'];
    userName = json['user_name'];
    profilePic = json['profile_pic'];
    totalLikes = json['total_likes'];
    totalComments = json['total_comments'];
    createdAt = json['created_at'];
    totalViewCount = json['totalViewCount'];
    isReelLike = json['is_reel_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['post_pic'] = postPic;
    data['thumbnail'] = thumbnail;
    data['song_name'] = songName;
    data['user_name'] = userName;
    data['profile_pic'] = profilePic;
    data['total_likes'] = totalLikes;
    data['total_comments'] = totalComments;
    data['created_at'] = createdAt;
    data['totalViewCount'] = totalViewCount;
    data['is_reel_like'] = isReelLike;
    return data;
  }
}
