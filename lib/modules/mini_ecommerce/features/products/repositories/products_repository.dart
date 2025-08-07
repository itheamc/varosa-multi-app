import '../../../../../core/services/network/typedefs/response_or_exception.dart';
import '../models/product.dart';
import '../models/products_response.dart';

abstract class ProductsRepository {
  ///  Base endpoint path for products
  ///
  String get path4Products;

  /// Method to check products
  /// [limit] - Limit of products to be fetched
  /// [skip] - The number of rows you want to skip from the products table
  /// [selections] - Columns to be fetched from the products table
  /// [sortBy] - Column to be used for sorting
  /// [sortOrder] - Order to be used for sorting: asc or desc
  /// [forceRefresh] - Weather to force refresh of the products or get from cache
  ///
  Future<EitherResponseOrException<ProductsResponse>> fetchProducts({
    int? limit,
    int? skip,
    List<String> selections = const [],
    String? sortBy,
    String? sortOrder,
    bool forceRefresh = false,
  });

  /// Method to query products by query
  /// [query] - Query to be used for filtering
  /// [forceRefresh] - Weather to force refresh of the products or get from cache
  ///
  Future<EitherResponseOrException<ProductsResponse>> queryProducts({
    required String query,
    bool forceRefresh = true,
  });

  /// Method to fetch product by id
  /// [id] - Id of the product to be fetched
  ///
  Future<EitherResponseOrException<Product>> fetchProduct({
    required int id,
    bool forceRefresh = false,
  });
}
