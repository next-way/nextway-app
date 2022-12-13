// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Order',
      json,
      ($checkedConvert) {
        final val = Order(
          id: $checkedConvert('id', (v) => v as int),
          displayName: $checkedConvert('display_name', (v) => v as String),
          state: $checkedConvert('state', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'displayName': 'display_name'},
    );
