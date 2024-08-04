// class LocationResponseModel {
//   LocationResponseModel({
//     this.message,
//     this.data,
//   });

//   String? message;
//   List<StateModel>? data;

//   factory LocationResponseModel.fromJson(Map<String, dynamic> json) =>
//       LocationResponseModel(
//         message: json["message"],
//         data: List<StateModel>.from(
//             json["data"].map((x) => StateModel.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "message": message,
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }

// class StateModel {
//   StateModel({
//     this.id,
//     this.name,
//     this.cities,
//     this.imagePath = "",
//   });

//   int? id;
//   String? name;
//   List<CityModel>? cities;
//   String imagePath;

//   factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
//       id: json["id"],
//       name: json["name"],
//       cities: List<CityModel>.from(
//           json["cities"].map((x) => CityModel.fromJson(x))),
//       imagePath: json["imagePath"]);

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "cities": [],
//         "imagePath": imagePath,
//       };
// }

// class CityModel {
//   CityModel({
//     this.id,
//     this.name,
//   });

//   int? id;
//   String? name;

//   factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
//         id: json["id"],
//         name: json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//       };
// }
