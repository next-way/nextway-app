import 'package:nextway_api/nextway_api.dart';

class OrderRepository {
  OrderRepository({NextwayApiClient? nextwayApiClient})
      : _nextwayApiClient = nextwayApiClient ?? NextwayApiClient();

  final NextwayApiClient _nextwayApiClient;

  Stream<List<Order>> orderSearch(String query) =>
      _nextwayApiClient.orderSearch(query);
}
