// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_object_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseObjectResponse<T> _$BaseObjectResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    BaseObjectResponse<T>(
      message: json['message'] as String? ?? "",
      success: json['success'] as bool,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
    );

Map<String, dynamic> _$BaseObjectResponseToJson<T>(
  BaseObjectResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
