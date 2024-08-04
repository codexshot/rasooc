import 'package:intl/intl.dart';
import 'package:rasooc/domain/models/geographic_entity.dart';
import 'package:rasooc/domain/models/location_response_model.dart';
import 'package:rasooc/domain/models/user_dependant_models.dart';

class ProfileModel {
  ProfileModel({
    this.userId,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.fbUserId,
    this.age,
    this.profilePic,
    this.gender,
    this.hometown,
    this.city,
    this.state,
    this.country,
    this.categoriesId,
    this.birthday,
    this.contactNumber = "",
    this.residentialArea = "",
    this.postalCode = "",
    this.street = "",
    this.categories,
    this.updatedAt,
    this.createdAt,
    this.fbAccessToken,
    this.provider = "facebook",
    this.userAccessToken,
  });

  int? userId;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  int? fbUserId;
  String? age;
  String? profilePic;
  String? gender;
  String? hometown;
  GeographicEntity? country;
  GeographicEntity? city;
  GeographicEntity? state;
  List<int>? categoriesId;
  String? birthday;
  String? contactNumber;
  String? residentialArea;
  String? postalCode;
  String? street;
  String provider;
  List<CategoryModel>? categories;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? fbAccessToken;
  String? userAccessToken;

  factory ProfileModel.fromFacebook(Map<String, dynamic> json) => ProfileModel(
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        fbUserId: int.tryParse(json["id"]),
        age: json["age"],
        profilePic: json["picture"]["data"]["url"],
        hometown: json["hometown"] != null ? json["hometown"]["name"] : null,
        city: json["hometown"] != null
            ? GeographicEntity(
                name: json["hometown"]["name"]?.split(",")[0], id: -1)
            : null,
        gender: json["gender"],
        birthday: json["birthday"] != null && json["birthday"].isNotEmpty
            ? dateConvertFromFacebook(json["birthday"])
            : null,
        contactNumber: json["contactNumber"],
      );

  factory ProfileModel.fromBackendJson(Map<String, dynamic> json) =>
      ProfileModel(
        userId: json["user_id"],
        fbUserId: json["fbUserId"],
        fbAccessToken: json["fbAccessToken"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        // stateId: json["state_id"],
        // cityId: json["city_id"],
        country: GeographicEntity.fromJson(json["country"]),
        state: GeographicEntity.fromJson(json["state"]),
        city: GeographicEntity.fromJson(json["city"]),
        categories: json["category"] != null
            ? List<CategoryModel>.from(
                json["category"].map((x) => CategoryModel.fromJson(x)))
            : [],
        age: json["age"],
        gender: json["gender"],
        // categoriesId: List<int>.from(json["category_id"].map((x) => x)),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        profilePic: json["profilePic"],
        birthday: json["birthday"],
        contactNumber: json["contactNumber"],
        hometown: json["hometown"],
        name: json["name"],
        postalCode: json["postalCode"],
        residentialArea: json["residential_area"],
        street: json["street"],
      );

  Map<String, dynamic> toBackendJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "fbUserId": fbUserId,
      "age": age,
      "profilePic": profilePic,
      "provider": provider,
      "fbAccessToken": fbAccessToken,
      "gender": gender,
      "hometown": hometown,
      "country": country?.id,
      "state": state?.id,
      "city": city?.id,
      "categories": categories != null
          ? List<dynamic>.from(categories!.map((x) => x.toJson()))
          : [],
      'birthday': birthday,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "fbUserId": fbUserId,
      "age": age,
      "profilePic": profilePic,
      "provider": provider,
      "fbAccessToken": fbAccessToken,
      "gender": gender,
      "hometown": hometown,
      "contactNumber": contactNumber,
      'user_id': userId,
      "country": country?.toJson(),
      "state": state?.toJson(),
      "city": city?.toJson(),
      "categories": categories != null
          ? List<dynamic>.from(categories!.map((x) => x.toJson()))
          : [],
      'category_id': categoriesId,
      'birthday': birthday,
      'residential_address': residentialArea,
      'postalCode': postalCode,
      'street': street,
      'updated_at': updatedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'userAccessToken': userAccessToken,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "gender": gender,
      "contactNumber": contactNumber,
      "country": country?.id,
      "state": state?.id,
      "city": city?.id,
      'birthday': birthday,
      'residential_address': residentialArea,
      'postalCode': postalCode,
      'street': street,
    };
  }

  ProfileModel copyFrom(ProfileModel model) {
    return ProfileModel(
      userId: model.userId,
      name: model.name,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      fbUserId: model.fbUserId,
      age: model.age,
      profilePic: model.profilePic,
      gender: model.gender,
      hometown: model.hometown,
      country: model.country,
      city: model.city,
      state: model.state,
      categoriesId: model.categoriesId,
      birthday: model.birthday,
      contactNumber: model.contactNumber,
      residentialArea: model.residentialArea,
      postalCode: model.postalCode,
      street: model.street,
      categories: model.categories,
      updatedAt: model.updatedAt,
      createdAt: model.createdAt,
      fbAccessToken: model.fbAccessToken,
      userAccessToken: model.userAccessToken,
    );
  }

  ProfileModel copyWith({
    int? userId,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    int? fbUserId,
    String? age,
    String? profilePic,
    String? gender,
    String? hometown,
    GeographicEntity? country,
    GeographicEntity? city,
    GeographicEntity? state,
    List<int>? categoriesId,
    String? birthday,
    String? contactNumber,
    String? fbUserToken,
    String? residentialArea,
    String? postalCode,
    String? street,
    List<CategoryModel>? categories,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? fbAccessToken,
    String? userAccessToken,
  }) {
    return ProfileModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      fbUserId: fbUserId ?? this.fbUserId,
      age: age ?? this.age,
      profilePic: profilePic ?? this.profilePic,
      gender: gender ?? this.gender,
      hometown: hometown ?? this.hometown,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      categoriesId: categoriesId ?? this.categoriesId,
      birthday: birthday ?? this.birthday,
      contactNumber: contactNumber ?? this.contactNumber,
      residentialArea: residentialArea ?? this.residentialArea,
      postalCode: postalCode ?? this.postalCode,
      street: street ?? this.street,
      categories: categories ?? this.categories,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      fbAccessToken: fbAccessToken ?? this.fbAccessToken,
      userAccessToken: userAccessToken ?? this.userAccessToken,
    );
  }
}

String dateConvertFromFacebook(String date) {
  final date1 = DateFormat("MM/dd/yyyy").parse(date);
  final finalDate = DateFormat("dd-MM-yyyy").format(date1);
  return finalDate;
}
