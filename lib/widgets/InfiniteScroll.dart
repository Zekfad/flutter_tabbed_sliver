import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/AppColors.dart';


/// Infinity scroll widget abstraction
/// Extend it to build infinitely scrollable surfaces
abstract class InfiniteScrollWidget<T> extends StatefulWidget {
  const InfiniteScrollWidget({
    super.key,
    this.allowRefresh = false,
    this.scrollController,
    this.scrollPhysics,
  }) : super();

  /// Whether or not to allow pull to refresh
  final bool allowRefresh;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;

  /// Whether or not to keep widget in memory even if it's unmounted (not disposed)
  bool get keepAlive => false;

  int get pageSize;
  Future<List<T>?> fetchPage(int page);
  Widget itemBuilder(BuildContext context, T item, int index);

  @override
  InfiniteScrollState<T> createState() => InfiniteScrollState<T>();
}

typedef InfiniteScrollFetchPageFunction<T> = Future<List<T>?> Function(int page);
typedef InfiniteScrollItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

/// Infinity scroll state
class InfiniteScrollState<T> extends State<InfiniteScrollWidget<T>> with AutomaticKeepAliveClientMixin  {
  InfiniteScrollFetchPageFunction<T> get fetchPageFn => widget.fetchPage;
  InfiniteScrollItemBuilder<T> get itemBuilder => widget.itemBuilder;
  ScrollController? get scrollController => widget.scrollController;
  ScrollPhysics? get scrollPhysics => widget.scrollPhysics;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  final PagingController<int, T> pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    pagingController.addPageRequestListener(fetchPage);
    super.initState();
  }

  Future<void> fetchPage(int page) async {
    final List<T>? newPage = await fetchPageFn(page);
    if (newPage == null) {
      pagingController.error = Exception('Unable to load page.');
      return;
    }
    if (newPage.length < widget.pageSize)
      pagingController.appendLastPage(newPage);
    else
      pagingController.appendPage(newPage, page + 1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Widget list = PagedListView<int, T>(
      scrollController: scrollController,
      physics: scrollPhysics,
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: itemBuilder,
        firstPageProgressIndicatorBuilder: (BuildContext context) => Center(
          child: CircularProgressIndicator(
            color: colors.gold,
          ),
        ),
        newPageProgressIndicatorBuilder: (BuildContext context) => Center(
          child: CircularProgressIndicator(
            color: colors.gold,
          ),
        ),
      ),
    ); 
    return widget.allowRefresh 
      ? RefreshIndicator(
          color: colors.gold,
          onRefresh: () => Future.sync(
            pagingController.refresh,
          ),
          child: list,
        )
      : list;
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
