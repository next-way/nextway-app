import 'dart:async';

import 'package:nextway/list_page.dart';
import 'package:nextway/preferences/list_preferences.dart';
import 'package:order_repository/order_repository.dart';

class Repository {
  Map apiConfig = {};
  late OrderRepository _apiRepository;

  Repository(Map<dynamic, dynamic> apiConfig) {
    this.apiConfig = apiConfig;
    this._apiRepository = OrderRepository(apiConfig);
  }

  Future<ListPage<Order>> getOrders({
    int number = 1,
    int size = 10,
    OrderGroupState? filteredState,
  }) async {
    Map<OrderGroupState, String> stateToString = {
      OrderGroupState.all: 'all',
      OrderGroupState.scheduled: 'scheduled',
      OrderGroupState.unassigned: 'unassigned',
    };
    final results = _apiRepository.orderSearch(stateToString[filteredState]!,
        size: size, page: number);
    List<Order> orderList = [];
    int grandTotalCount = 0;
    final Completer<dynamic> c = new Completer<dynamic>();

    results.listen((event) {
      orderList = event.items;
      grandTotalCount = event.total;
      c.complete(orderList); // Irrelavant what to put now?
    });

    // results.listen((streamOrdersList) {
    //   for (Order order in streamOrdersList as Iterable<Order>) {
    //     orderList.add(order);
    //   }
    //   c.complete(orderList);
    // });
    //
    orderList = await c.future;

    return ListPage<Order>(
      itemList: orderList,
      grandTotalCount: grandTotalCount,
    );
  }

  OrderRepository get orderApiRepository => _apiRepository;
}
