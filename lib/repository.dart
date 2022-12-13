import 'package:nextway/list_page.dart';
import 'package:order_repository/order_repository.dart';

class Repository {
  final OrderRepository _apiRepository = OrderRepository();

  Future<ListPage<Order>> getOrders({
    int number = 0,
    int size = 10,
  }) async {
    final results = _apiRepository.orderSearch("");
    final List<Order> orderList = [];
    results.listen((streamOrdersList) {
      for (Order order in streamOrdersList as Iterable<Order>) {
        orderList.add(order);
      }
    });
    return ListPage<Order>(
      itemList: orderList,
      grandTotalCount: 1, // TODO Retrieve from API result
    );
  }
}
