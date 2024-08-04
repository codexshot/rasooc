// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'geographic_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GeographicEntity _$GeographicEntityFromJson(Map<String, dynamic> json) {
  return _GeographicEntity.fromJson(json);
}

/// @nodoc
class _$GeographicEntityTearOff {
  const _$GeographicEntityTearOff();

  _GeographicEntity call({required int id, required String name}) {
    return _GeographicEntity(
      id: id,
      name: name,
    );
  }

  GeographicEntity fromJson(Map<String, Object> json) {
    return GeographicEntity.fromJson(json);
  }
}

/// @nodoc
const $GeographicEntity = _$GeographicEntityTearOff();

/// @nodoc
mixin _$GeographicEntity {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GeographicEntityCopyWith<GeographicEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeographicEntityCopyWith<$Res> {
  factory $GeographicEntityCopyWith(
          GeographicEntity value, $Res Function(GeographicEntity) then) =
      _$GeographicEntityCopyWithImpl<$Res>;
  $Res call({int id, String name});
}

/// @nodoc
class _$GeographicEntityCopyWithImpl<$Res>
    implements $GeographicEntityCopyWith<$Res> {
  _$GeographicEntityCopyWithImpl(this._value, this._then);

  final GeographicEntity _value;
  // ignore: unused_field
  final $Res Function(GeographicEntity) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$GeographicEntityCopyWith<$Res>
    implements $GeographicEntityCopyWith<$Res> {
  factory _$GeographicEntityCopyWith(
          _GeographicEntity value, $Res Function(_GeographicEntity) then) =
      __$GeographicEntityCopyWithImpl<$Res>;
  @override
  $Res call({int id, String name});
}

/// @nodoc
class __$GeographicEntityCopyWithImpl<$Res>
    extends _$GeographicEntityCopyWithImpl<$Res>
    implements _$GeographicEntityCopyWith<$Res> {
  __$GeographicEntityCopyWithImpl(
      _GeographicEntity _value, $Res Function(_GeographicEntity) _then)
      : super(_value, (v) => _then(v as _GeographicEntity));

  @override
  _GeographicEntity get _value => super._value as _GeographicEntity;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
  }) {
    return _then(_GeographicEntity(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GeographicEntity implements _GeographicEntity {
  const _$_GeographicEntity({required this.id, required this.name});

  factory _$_GeographicEntity.fromJson(Map<String, dynamic> json) =>
      _$_$_GeographicEntityFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'GeographicEntity(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GeographicEntity &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name);

  @JsonKey(ignore: true)
  @override
  _$GeographicEntityCopyWith<_GeographicEntity> get copyWith =>
      __$GeographicEntityCopyWithImpl<_GeographicEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GeographicEntityToJson(this);
  }
}

abstract class _GeographicEntity implements GeographicEntity {
  const factory _GeographicEntity({required int id, required String name}) =
      _$_GeographicEntity;

  factory _GeographicEntity.fromJson(Map<String, dynamic> json) =
      _$_GeographicEntity.fromJson;

  @override
  int get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$GeographicEntityCopyWith<_GeographicEntity> get copyWith =>
      throw _privateConstructorUsedError;
}
