enum SortMethod { releaseDate, popularity }

class ListPreferences {
  ListPreferences({
    this.filteredOrderIds,
    this.sortMethod,
  });
  List<int>? filteredOrderIds;
  SortMethod? sortMethod;
}
