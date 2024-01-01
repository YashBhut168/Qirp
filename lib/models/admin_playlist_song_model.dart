class AdminPlaylistSongModel {
  bool? status;
  String? message;
  List<Data>? data;

  AdminPlaylistSongModel({this.status, this.message, this.data});

  AdminPlaylistSongModel.fromJson(Map<String, dynamic> json) {
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
  String? albumId;
  String? title;
  String? description;
  String? duration;
  String? audio;
  String? image;
  bool? isLiked;
  // ignore: non_constant_identifier_names
  bool? is_queue;
  // ignore: non_constant_identifier_names
  bool? is_loadning;

  Data(
      {this.id,
      this.albumId,
      this.title,
      this.description,
      this.duration,
      this.audio,
      this.image,
      this.isLiked,
      // ignore: non_constant_identifier_names
      this.is_queue,
      // ignore: non_constant_identifier_names
      this.is_loadning,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumId = json['album_id'];
    title = json['title'];
    description = json['description'];
    duration = json['duration'];
    audio = json['audio'];
    image = json['image'];
    isLiked = json['is_likes'];
    is_queue = json['is_queue'];
    is_loadning = json['is_loadning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['album_id'] = albumId;
    data['title'] = title;
    data['description'] = description;
    data['duration'] = duration;
    data['audio'] = audio;
    data['image'] = image;
    data['is_likes'] = isLiked;
    data['is_queue'] = is_queue;
    data['is_loadning'] = is_loadning;
    return data;
  }
}
