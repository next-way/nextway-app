/// Represents each page returned by a paginated endpoint.
class ListPage<ItemType> {
  ListPage({
    required this.grandTotalCount,
    required this.itemList,
  })  : assert(grandTotalCount != null),
        assert(itemList != null);

  final int grandTotalCount;
  final List<ItemType> itemList;

  bool isLastPage(int previouslyFetchedItemsCount) {
    final newItemsCount = itemList.length;
    final totalFetchedItemsCount = previouslyFetchedItemsCount + newItemsCount;
    return totalFetchedItemsCount == grandTotalCount;
  }
}
