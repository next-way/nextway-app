enum SortMethod { releaseDate, popularity }

enum OrderGroupState {
  all,
  scheduled,
  unassigned,
}

class ListPreferences {
  ListPreferences({
    this.filteredOrderIds,
    this.filteredState,
    this.sortMethod,
  });
  List<int>? filteredOrderIds;
  OrderGroupState? filteredState;
  SortMethod? sortMethod;
}
