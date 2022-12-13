// GENERATED CODE - DO NOT MODIFY BY HAND

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
        );
        return val;
      },
      fieldKeyMap: const {'displayName': 'display_name'},
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
    };
