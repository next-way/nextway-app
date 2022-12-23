// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderLine _$OrderLineFromJson(Map<String, dynamic> json) => $checkedCreate(
      'OrderLine',
      json,
      ($checkedConvert) {
        final val = OrderLine(
          id: $checkedConvert('order_id', (v) => v as int),
          name: $checkedConvert('name', (v) => v as String),
          quantity:
              $checkedConvert('product_uom_qty', (v) => (v as num).toDouble()),
          unitOfMeasure:
              $checkedConvert('product_uom_name', (v) => v as String),
          priceSubtotal:
              $checkedConvert('price_subtotal', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'order_id',
        'quantity': 'product_uom_qty',
        'unitOfMeasure': 'product_uom_name',
        'priceSubtotal': 'price_subtotal'
      },
    );

DeliveryAddress _$DeliveryAddressFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DeliveryAddress',
      json,
      ($checkedConvert) {
        final val = DeliveryAddress(
          name: $checkedConvert('name', (v) => v as String?),
          displayName: $checkedConvert('display_name', (v) => v as String),
          phone: $checkedConvert('phone', (v) => v as String?),
          mobile: $checkedConvert('mobile', (v) => v as String?),
          companyName: $checkedConvert('company_name', (v) => v as String?),
          street: $checkedConvert('street', (v) => v as String?),
          street2: $checkedConvert('street2', (v) => v as String?),
          city: $checkedConvert('city', (v) => v as String?),
          country: $checkedConvert('country', (v) => v as String?),
          state: $checkedConvert('state', (v) => v as String?),
          partnerLatitude: $checkedConvert(
              'partner_latitude', (v) => (v as num?)?.toDouble()),
          partnerLongitude: $checkedConvert(
              'partner_longitude', (v) => (v as num?)?.toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'displayName': 'display_name',
        'companyName': 'company_name',
        'partnerLatitude': 'partner_latitude',
        'partnerLongitude': 'partner_longitude'
      },
    );

Order _$OrderFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Order',
      json,
      ($checkedConvert) {
        final val = Order(
          id: $checkedConvert('id', (v) => v as int),
          displayName: $checkedConvert('display_name', (v) => v as String),
          dateOrder: $checkedConvert('date_order',
              (v) => const CustomDateTimeConverter().fromJson(v as String)),
          state: $checkedConvert('state', (v) => v as String),
          deliveryAddress: $checkedConvert('delivery_address',
              (v) => DeliveryAddress.fromJson(v as Map<String, dynamic>)),
          amountTotal:
              $checkedConvert('amount_total', (v) => (v as num).toDouble()),
          scheduledDate: $checkedConvert(
              'scheduled_date',
              (v) => _$JsonConverterFromJson<String, DateTime>(
                  v, const CustomDateTimeConverter().fromJson)),
          deadlineDate: $checkedConvert(
              'date_deadline',
              (v) => _$JsonConverterFromJson<String, DateTime>(
                  v, const CustomDateTimeConverter().fromJson)),
          expectedDate: $checkedConvert(
              'expected_date',
              (v) => _$JsonConverterFromJson<String, DateTime>(
                  v, const CustomDateTimeConverter().fromJson)),
          orderLines: $checkedConvert(
              'order_lines',
              (v) => (v as List<dynamic>)
                  .map((e) => OrderLine.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'displayName': 'display_name',
        'dateOrder': 'date_order',
        'deliveryAddress': 'delivery_address',
        'amountTotal': 'amount_total',
        'scheduledDate': 'scheduled_date',
        'deadlineDate': 'date_deadline',
        'expectedDate': 'expected_date',
        'orderLines': 'order_lines'
      },
    );

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

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
