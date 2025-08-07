import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import '../repositories/products_repository.dart';
import 'products_list_event.dart';
import 'products_list_state.dart';

class ProductsListBloc extends Bloc<ProductsListEvent, ProductsListState> {
  ProductsListBloc(this._repository) : super(const ProductsListState()) {
    on<FetchProductsEvent>(_onFetchProducts);
  }

  /// Products Repository
  final ProductsRepository _repository;

  /// Completer for confirming request is not sent multiple times
  Completer<void>? _requestCompleter;

  /// Current skip value (for pagination)
  int _skip = 0;
  final _limit = 20;

  /// Flag to check if page is still remaining
  bool _hasMore = true;

  /// Method to fetch the list of product data
  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductsListState> emit,
  ) async {
    if (_requestCompleter != null && !_requestCompleter!.isCompleted) {
      event.onCompleted?.call(_skip ~/ _limit + 1, null);
      return;
    }

    // If no more and not first page
    if (event.skip != 0 && !_hasMore) {
      event.onCompleted?.call(_skip ~/ _limit + 1, null);
      return;
    }

    // Initialize completer
    _requestCompleter = Completer();

    // If skip is not null, set it
    if (event.skip != null) _skip = event.skip!;

    // Update state - show loading for first page only
    emit(
      _skip == 0
          ? ProductsListState(fetching: true)
          : state.copy(fetching: true),
    );

    final response = await _repository.fetchProducts(
      limit: event.limit ?? _limit,
      skip: _skip,
      selections: event.selections,
      sortBy: event.sortBy,
      sortOrder: event.sortOrder,
      forceRefresh: event.forceRefresh,
    );

    // After getting response
    await response.fold(
      (l) async {
        if (!isClosed) {
          emit(state.copy(fetching: false, error: l.message));
        }

        // Trigger on completed callback
        event.onCompleted?.call(_skip ~/ _limit + 1, null);

        // Trigger on session expired callback
        if (l.statusCode == 401) event.onSessionExpired?.call();

        // Complete the completer
        _requestCompleter?.complete();
      },
      (r) async {
        if (!isClosed) {
          emit(
            state.copy(
              fetching: false,
              error: '',
              products: _skip == 0
                  ? r.products
                  : [...state.products, ...r.products],
              lastResponse: r,
              total: r.total,
            ),
          );
        }

        // Trigger on completed callback
        event.onCompleted?.call(_skip ~/ _limit + 1, r.products);

        // Complete the completer
        _requestCompleter?.complete();

        // Check if has more
        _hasMore =
            r.products.isNotEmpty &&
            r.total != null &&
            state.products.length < r.total!;
      },
    );

    // Updating skip for next request
    _skip = _skip + (event.limit ?? _limit);
  }

  /// Method to refresh products (reset to skip 0)
  /// [limit] - Limit of products to be fetched
  /// [selections] - Columns to be fetched from the products table
  /// [sortBy] - Column to be used for sorting
  /// [sortOrder] - Order to be used for sorting: asc or desc
  /// [forceRefresh] - Weather to force refresh of the products or get from cache
  /// [onCompleted] - Callback to be called when the products are fetched
  /// [onSessionExpired] - Callback to be called when the session is expired
  ///
  void refresh({
    int? limit,
    List<String> selections = const [],
    String? sortBy,
    String? sortOrder,
    bool forceRefresh = true,
    void Function(int page, List<Product>? list)? onCompleted,
    void Function()? onSessionExpired,
  }) {
    _skip = 0;
    _hasMore = true;
    add(
      FetchProductsEvent(
        limit: limit,
        skip: 0,
        selections: selections,
        sortBy: sortBy,
        sortOrder: sortOrder,
        forceRefresh: forceRefresh,
        onCompleted: onCompleted,
        onSessionExpired: onSessionExpired,
      ),
    );
  }

  /// Method to load more products (next batch)
  /// [limit] - Limit of products to be fetched
  /// [selections] - Columns to be fetched from the products table
  /// [sortBy] - Column to be used for sorting
  /// [sortOrder] - Order to be used for sorting: asc or desc
  /// [forceRefresh] - Weather to force refresh of the products or get from cache
  /// [onCompleted] - Callback to be called when the products are fetched
  /// [onSessionExpired] - Callback to be called when the session is expired
  ///
  void loadMore({
    int? limit,
    List<String> selections = const [],
    String? sortBy,
    String? sortOrder,
    bool forceRefresh = false,
    void Function(int page, List<Product>? list)? onCompleted,
    void Function()? onSessionExpired,
  }) {
    if (!_hasMore) return;

    add(
      FetchProductsEvent(
        limit: limit,
        selections: selections,
        sortBy: sortBy,
        sortOrder: sortOrder,
        forceRefresh: forceRefresh,
        onCompleted: onCompleted,
        onSessionExpired: onSessionExpired,
      ),
    );
  }
}
