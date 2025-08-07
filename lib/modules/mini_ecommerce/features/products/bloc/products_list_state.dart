import 'package:equatable/equatable.dart';
import 'package:varosa_multi_app/modules/mini_ecommerce/features/products/models/products_response.dart';

import '../models/product.dart';

class ProductsListState extends Equatable {
  final bool fetching;
  final String? error;
  final List<Product> products;
  final ProductsResponse? lastResponse;
  final int? total;

  bool get hasMore => total == null || products.length < total!;

  const ProductsListState({
    this.fetching = false,
    this.error,
    this.products = const [],
    this.lastResponse,
    this.total,
  });

  /// Method to copy
  ProductsListState copy({
    bool? fetching,
    String? error,
    List<Product>? products,
    ProductsResponse? lastResponse,
    int? total,
  }) {
    return ProductsListState(
      fetching: fetching ?? this.fetching,
      error: error != null
          ? error.isEmpty
                ? null
                : error
          : this.error,
      products: products ?? this.products,
      lastResponse: lastResponse ?? this.lastResponse,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [fetching, error, products, lastResponse, total];
}
