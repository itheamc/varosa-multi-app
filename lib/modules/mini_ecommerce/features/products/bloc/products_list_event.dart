import 'package:equatable/equatable.dart';

import '../models/product.dart';

abstract class ProductsListEvent extends Equatable {
  const ProductsListEvent();
}

/// Event to fetch products
/// [limit] - Limit of products to be fetched
/// [skip] - The number of rows you want to skip from the products table
/// [selections] - Columns to be fetched from the products table
/// [sortBy] - Column to be used for sorting
/// [sortOrder] - Order to be used for sorting: asc or desc
/// [forceRefresh] - Force refresh of the products
/// [onCompleted] - Callback to be called when the products are fetched
/// [onSessionExpired] - Callback to be called when the session is expired
class FetchProductsEvent extends ProductsListEvent {
  final int? limit;
  final int? skip;
  final List<String> selections;
  final String? sortBy;
  final String? sortOrder;
  final bool forceRefresh;
  final void Function(int page, List<Product>? list)? onCompleted;
  final void Function()? onSessionExpired;

  const FetchProductsEvent({
    this.limit,
    this.skip,
    this.selections = const [],
    this.sortBy,
    this.sortOrder,
    this.forceRefresh = true,
    this.onCompleted,
    this.onSessionExpired,
  });

  @override
  List<Object?> get props => [
    limit,
    skip,
    selections,
    sortBy,
    sortOrder,
    forceRefresh,
  ];
}

class FavoriteProductEvent extends ProductsListEvent {
  final Product product;

  const FavoriteProductEvent({required this.product});

  @override
  List<Object?> get props => [product];
}

/// Event to query product
/// [query] - Query to be used for filtering
/// [forceRefresh] - Force refresh of the products
/// [onCompleted] - Callback to be called when the products are fetched
/// [onSessionExpired] - Callback to be called when the session is expired
///
class QueryProductsEvent extends ProductsListEvent {
  final String query;
  final bool forceRefresh;
  final void Function(List<Product>? list)? onCompleted;
  final void Function()? onSessionExpired;

  const QueryProductsEvent({
    required this.query,
    this.forceRefresh = true,
    this.onCompleted,
    this.onSessionExpired,
  });

  @override
  List<Object?> get props => [query, forceRefresh];
}
