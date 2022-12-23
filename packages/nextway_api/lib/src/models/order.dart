import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nextway_api/src/helpers/custom_datetime.dart';

part 'order.g.dart';

@JsonSerializable()
class OrderLine {
  const OrderLine({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitOfMeasure,
    required this.priceSubtotal,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) =>
      _$OrderLineFromJson(json);

  @JsonKey(name: 'order_id')
  final int id;
  final String name;
  @JsonKey(name: 'product_uom_qty')
  final double quantity;
  @JsonKey(name: 'product_uom_name')
  final String unitOfMeasure;
  @JsonKey(name: 'price_subtotal')
  final double priceSubtotal;

  String get quantityVerbose {
    return quantity.truncate().toString();
  }

  String get unitOfMeasureVerbose {
    if (unitOfMeasure.toLowerCase() == 'units') {
      return 'pcs';
    }
    return unitOfMeasure.toLowerCase();
  }

  String get priceSubtotalVerbose {
    var currencyFormat = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '',
      decimalDigits: 2,
    );
    return currencyFormat.format(priceSubtotal);
  }
}

@JsonSerializable()
class DeliveryAddress {
  const DeliveryAddress({
    this.name,
    required this.displayName,
    this.phone,
    this.mobile,
    this.companyName,
    this.street,
    this.street2,
    this.city,
    this.country,
    this.state,
    this.partnerLatitude,
    this.partnerLongitude,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressFromJson(json);

  final String? name;
  @JsonKey(name: 'display_name')
  final String displayName;
  final String? phone;
  final String? mobile;
  @JsonKey(name: 'company_name')
  final String? companyName;
  final String? street;
  final String? street2;
  final String? city;
  final String? country;
  final String? state;
  @JsonKey(name: 'partner_latitude')
  final double? partnerLatitude;
  @JsonKey(name: 'partner_longitude')
  final double? partnerLongitude;
}

@JsonSerializable()
@CustomDateTimeConverter()
class Order {
  const Order({
    required this.id,
    required this.displayName,
    required this.dateOrder,
    required this.state,
    required this.deliveryAddress,
    required this.amountTotal,
    required this.scheduledDate,
    required this.deadlineDate,
    required this.expectedDate,
    required this.orderLines,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  final int id;
  @JsonKey(name: 'display_name')
  final String displayName;
  @JsonKey(name: 'date_order')
  final DateTime dateOrder;
  final String state;
  final DeliveryAddress deliveryAddress;
  @JsonKey(name: 'amount_total')
  final double amountTotal;
  @JsonKey(name: 'scheduled_date')
  final DateTime? scheduledDate;
  @JsonKey(name: 'date_deadline')
  final DateTime? deadlineDate;
  @JsonKey(name: 'expected_date')
  final DateTime? expectedDate;
  @JsonKey(name: 'order_lines')
  final List<OrderLine> orderLines;

  DateTime? get schedule {
    if (expectedDate != null) {
      return expectedDate!;
    } else if (scheduledDate != null) {
      return scheduledDate!;
    }
    return deadlineDate;
  }

  String get scheduleVerbose {
    if (schedule == null) {
      return "Unscheduled";
    }
    String formattedYMD = DateFormat('yMd').format(schedule!);
    if (formattedYMD == DateFormat.yMd().format(DateTime.now())) {
      return "Today";
    }
    return DateFormat.yMMMMd('en_US').format(schedule!);
  }

  String get amountInPesos {
    var currencyFormat = NumberFormat.currency(
      locale: 'en_PH',
      // symbol: '\₱',
      symbol: '\u{20B1}',
      decimalDigits: 2,
    );
    return currencyFormat.format(amountTotal);
  }

  String? get contactNumber {
    if (deliveryAddress.phone != null) {
      return deliveryAddress.phone;
    } else if (deliveryAddress.mobile != null) {
      return deliveryAddress.mobile;
    }
  }
}

@JsonSerializable()
class OrderResponse {
  final List<Order> items;
  final int total;
  final int page;
  final int size;

  const OrderResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}
