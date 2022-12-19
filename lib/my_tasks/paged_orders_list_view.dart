import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nextway/my_tasks/order_list_item.dart';
import 'package:nextway/preferences/list_preferences.dart';
import 'package:nextway/repository.dart';
import 'package:order_repository/order_repository.dart';

class PagedOrdersListView extends StatefulWidget {
  const PagedOrdersListView({
    required this.repository,
    required this.listPreferences,
    Key? key,
  })  : assert(repository != null),
        super(key: key);

  final Repository repository;
  final ListPreferences listPreferences;

  @override
  _PagedOrdersListViewState createState() => _PagedOrdersListViewState();
}

class _PagedOrdersListViewState extends State<PagedOrdersListView> {
  ListPreferences get _listPreferences => widget.listPreferences;

  final _pagingController = PagingController<int, Order>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await widget.repository.getOrders(
          number: pageKey,
          size: 10,
          filteredState: _listPreferences.filteredState
          // 1
          // filteredPlatformIds: _listPreferences?.filteredPlatformIds,
          // filteredDifficulties: _listPreferences?.filteredDifficulties,
          // filteredCategoryIds: _listPreferences?.filteredCategoryIds,
          // sortMethod: _listPreferences?.sortMethod,
          );

      final previouslyFetchedItemsCount =
          // 2
          _pagingController.itemList?.length ?? 0;

      final isLastPage = newPage.isLastPage(previouslyFetchedItemsCount);
      final newItems = newPage.itemList;

      if (isLastPage) {
        // 3
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      // 4
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PagedOrdersListView oldWidget) {
    /// @TODO As parent widget gets rebuilt, this statement is always true
    /// There is no diff between oldWidget and widget, and is not recycled either.
    // if (oldWidget.listPreferences != widget.listPreferences) {
    // }
    _pagingController.refresh();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView.separated(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Order>(
            itemBuilder: (context, order, index) => OrderListItem(
              order: order,
            ),
            // firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
            //   error: _pagingController.error,
            //   onTryAgain: () => _pagingController.refresh(),
            // ),
            // noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(),
          ),
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
        ),
      );
}
