import 'package:nextway_api/nextway_api.dart';

class OrderRepository {
  OrderRepository(this.apiConfig, {NextwayApiClient? nextwayApiClient})
      : _nextwayApiClient = nextwayApiClient ?? NextwayApiClient(apiConfig);

  Map apiConfig;
  final NextwayApiClient _nextwayApiClient;

  get cancelJobOrder => _nextwayApiClient.cancelJobOrder;

  get acceptJobOrder => _nextwayApiClient.acceptJobOrder;

  get dropOffOrder => _nextwayApiClient.dropOffOrder;

  get getProfile => _nextwayApiClient.getProfile;

  get getStatistics => _nextwayApiClient.getStatistics;

  Stream<OrderResponse> orderSearch(String query,
          {int size = 10, int page = 1}) =>
      _nextwayApiClient.orderSearch(query, size: size, page: page);
}
