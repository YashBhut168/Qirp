class AllCategoryDataModel {
  bool? status;
  String? message;
  List<AllCategory>? allCategory;

  AllCategoryDataModel({this.status, this.message, this.allCategory});

  AllCategoryDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['allCategory'] != null) {
      allCategory = <AllCategory>[];
      json['allCategory'].forEach((v) {
        allCategory!.add(AllCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (allCategory != null) {
      data['allCategory'] = allCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllCategory {
  String? id;
  String? title;
  String? description;
  String? picture;

  AllCategory({this.id, this.title, this.description, this.picture});

  AllCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['picture'] = picture;
    return data;
  }
}
