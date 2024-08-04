import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'geographic_entity.freezed.dart';
part 'geographic_entity.g.dart';

@freezed
class GeographicEntity with _$GeographicEntity {
  const factory GeographicEntity({
    required int id,
    required String name,
  }) = _GeographicEntity;

  factory GeographicEntity.fromJson(Map<String, dynamic> json) =>
      _$GeographicEntityFromJson(json);
}
