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

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'OrderResponse',
      json,
      ($checkedConvert) {
        final val = OrderResponse(
          items: $checkedConvert(
              'items',
              (v) => (v as List<dynamic>)
                  .map((e) => Order.fromJson(e as Map<String, dynamic>))
                  .toList()),
          total: $checkedConvert('total', (v) => v as int),
          page: $checkedConvert('page', (v) => v as int),
          size: $checkedConvert('size', (v) => v as int),
        );
        return val;
      },
    );
