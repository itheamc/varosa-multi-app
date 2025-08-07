import 'dart:isolate';

import 'package:fpdart/fpdart.dart';
import '../../../../../core/config/api_endpoints.dart';
import '../../../../../core/services/network/http_exception.dart';
import '../../../../../core/services/network/http_response_validator.dart';
import '../../../../../core/services/network/http_service.dart';
import '../../../../../core/services/network/typedefs/response_or_exception.dart';
import '../../../../../utils/logger.dart';
import '../models/product.dart';
import '../models/products_response.dart';
import 'products_repository.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  /// Http Service Instance
  final HttpService httpService;

  /// Constructor
  ProductsRepositoryImpl(this.httpService);

  ///  Base endpoint path for products
  ///
  @override
  String get path4Products => ApiEndpoints.products;

  @override
  Future<EitherResponseOrException<ProductsResponse>> fetchProducts({
    int? limit,
    int? skip,
    List<String> selections = const [],
    String? sortBy,
    String? sortOrder,
    bool forceRefresh = false,
  }) async {
    try {
      final response = await httpService.get(
        path4Products,
        isAuthenticated: false,
        forceRefresh: forceRefresh,
        queryParameters: {
          if (limit != null) "limit": limit,
          if (skip != null) "skip": skip,
          if (selections.isNotEmpty) "selections": selections.join(","),
          if (sortBy != null) "sortBy": sortBy,
          if (sortOrder != null) "order": sortOrder,
        },
      );

      if (ResponseValidator.isValidResponse(response)) {
        final listResponse = await Isolate.run(() {
          return ProductsResponse.fromJson(response.data);
        });
        return Right(listResponse);
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      Logger.logError(e);
      return Left(e);
    } catch (e) {
      Logger.logError(e);
      return Left(HttpException.fromException(e));
    }
  }

  @override
  Future<EitherResponseOrException<ProductsResponse>> queryProducts({
    required String query,
    bool forceRefresh = false,
  }) async {
    try {
      final response = await httpService.get(
        "${path4Products}search",
        isAuthenticated: false,
        forceRefresh: forceRefresh,
        queryParameters: {"q": query},
      );

      if (ResponseValidator.isValidResponse(response)) {
        final listResponse = await Isolate.run(() {
          return ProductsResponse.fromJson(response.data);
        });
        return Right(listResponse);
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      Logger.logError(e);
      return Left(e);
    } catch (e) {
      Logger.logError(e);
      return Left(HttpException.fromException(e));
    }
  }

  @override
  Future<EitherResponseOrException<Product>> fetchProduct({
    required int id,
    bool forceRefresh = false,
  }) async {
    try {
      final response = await httpService.get(
        "$path4Products$id",
        isAuthenticated: false,
        forceRefresh: forceRefresh,
      );

      if (ResponseValidator.isValidResponse(response)) {
        final detailsResponse = await Isolate.run(() {
          return Product.fromJson(response.data);
        });
        return Right(detailsResponse);
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      Logger.logError(e);
      return Left(e);
    } catch (e) {
      Logger.logError(e);
      return Left(HttpException.fromException(e));
    }
  }
}
