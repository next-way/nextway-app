import 'package:order_repository/order_repository.dart';

String getAddress(Order order) {
  List<String?> addressDetails = [
    order.deliveryAddress.street,
    order.deliveryAddress.street2,
    order.deliveryAddress.city,
    order.deliveryAddress.state,
    order.deliveryAddress.country,
  ];
  return addressDetails
      .where((element) => (element ?? '').isNotEmpty)
      .toList()
      .join(', ');
}
