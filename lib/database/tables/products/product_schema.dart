import '../../../modules/mini_ecommerce/features/products/models/product.dart';
import '../../core/base_schema.dart';
import 'products_table.dart';

class ProductSchema extends BaseSchema<Product> {
  ProductSchema({
    super.id,
    this.title,
    this.description,
    this.category,
    this.price,
    this.discountPercentage,
    this.rating,
    this.thumbnail,
    this.isFavorite = false,
    this.createdAt,
    this.updatedAt,
  });

  final String? title;
  final String? description;
  final String? category;
  final double? price;
  final double? discountPercentage;
  final double? rating;
  final String? thumbnail;
  final bool isFavorite;
  final String? createdAt;
  final String? updatedAt;

  @override
  ProductSchema copy({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    double? discountPercentage,
    double? rating,
    String? thumbnail,
    bool? isFavorite,
    String? createdAt,
    String? updatedAt,
  }) {
    return ProductSchema(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      thumbnail: thumbnail ?? this.thumbnail,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ProductSchema.fromJson(dynamic json) {
    if (json == null) return ProductSchema();
    return ProductSchema(
      id: json[ProductsTable.columnId],
      title: json[ProductsTable.columnTitle],
      description: json[ProductsTable.columnDescription],
      category: json[ProductsTable.columnCategory],
      price: json[ProductsTable.columnPrice],
      discountPercentage: json[ProductsTable.columnDiscountPercentage],
      rating: json[ProductsTable.columnRating],
      thumbnail: json[ProductsTable.columnThumbnail],
      isFavorite: json[ProductsTable.columnIsFavorite] == 1,
      createdAt: json[ProductsTable.columnCreatedAt],
      updatedAt: json[ProductsTable.columnUpdatedAt],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) ProductsTable.columnId: id,
      if (title != null) ProductsTable.columnTitle: title,
      if (description != null) ProductsTable.columnDescription: description,
      if (category != null) ProductsTable.columnCategory: category,
      if (price != null) ProductsTable.columnPrice: price,
      if (discountPercentage != null)
        ProductsTable.columnDiscountPercentage: discountPercentage,
      if (rating != null) ProductsTable.columnRating: rating,
      if (thumbnail != null) ProductsTable.columnThumbnail: thumbnail,
      ProductsTable.columnIsFavorite: isFavorite ? 1 : 0,
      if (createdAt != null) ProductsTable.columnCreatedAt: createdAt,
      if (updatedAt != null) ProductsTable.columnUpdatedAt: updatedAt,
    };
  }

  @override
  Product get toModel => Product(
    title: title,
    description: description,
    category: category,
    price: price,
    discountPercentage: discountPercentage,
    rating: rating,
    thumbnail: thumbnail,
    isFavorite: isFavorite,
  );
}
