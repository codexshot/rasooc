class CategoryModel {
  final int? id;
  final String? name;
  bool isSelected;

  CategoryModel({
    this.id,
    this.name,
    this.isSelected = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class GenderModel {
  final int? id;
  final String? gender;
  bool isSelected;

  GenderModel({
    this.id,
    this.gender,
    this.isSelected = false,
  });
}
