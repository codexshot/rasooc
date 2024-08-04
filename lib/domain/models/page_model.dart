import 'dart:convert';

PageModel pageModelFromJson(String str) => PageModel.fromJson(json.decode(str));

String pageModelToJson(PageModel data) => json.encode(data.toJson());

class PageModel {
  PageModel({
    this.accessToken,
    this.category,
    this.categoryList,
    this.name,
    this.id,
    this.tasks,
  });

  final String? accessToken;
  final String? category;
  final List<CategoryList>? categoryList;
  final String? name;
  final String? id;
  final List<String>? tasks;

  factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
        accessToken: json["access_token"],
        category: json["category"],
        categoryList: List<CategoryList>.from(
            json["category_list"].map((x) => CategoryList.fromJson(x))),
        name: json["name"],
        id: json["id"],
        tasks: List<String>.from(json["tasks"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "category": category,
        "category_list":
            List<dynamic>.from(categoryList!.map((x) => x.toJson())),
        "name": name,
        "id": id,
        "tasks": List<dynamic>.from(tasks!.map((x) => x)),
      };
}

class CategoryList {
  CategoryList({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
