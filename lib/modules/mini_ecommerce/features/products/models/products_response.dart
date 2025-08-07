import 'product.dart';

class ProductsResponse {
  ProductsResponse({
    this.products = const [],
    this.total,
    this.skip,
    this.limit,
  });

  final List<Product> products;
  final int? total;
  final int? skip;
  final int? limit;

  ProductsResponse copy({
    List<Product>? products,
    int? total,
    int? skip,
    int? limit,
  }) {
    return ProductsResponse(
      products: products ?? this.products,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      products: json["products"] == null || json["products"] is! List
          ? []
          : List<Product>.from(
              json["products"]!.map((x) => Product.fromJson(x)),
            ),
      total: json["total"],
      skip: json["skip"],
      limit: json["limit"],
    );
  }

  Map<String, dynamic> toJson() => {
    "products": products.map((x) => x.toJson()).toList(),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}
