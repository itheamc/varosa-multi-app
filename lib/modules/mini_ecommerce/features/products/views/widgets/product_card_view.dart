import 'package:flutter/material.dart';
import 'package:varosa_multi_app/modules/common/widgets/common_image.dart';
import 'package:varosa_multi_app/modules/mini_ecommerce/features/products/views/widgets/product_rating_view.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../models/product.dart';
import 'product_discount_percentage_view.dart';

class ProductCardView extends StatelessWidget {
  const ProductCardView({
    super.key,
    required this.product,
    this.onClick,
    this.onFavoriteToggle,
  });

  final Product product;
  final VoidCallback? onClick;
  final void Function (Product)? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Container(
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: product.thumbnail != null
                          ? CommonImage(
                        assetsOrUrlOrPath: product.thumbnail!,
                        fit: BoxFit.fitHeight,
                      )
                          : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  // Favorite Toggle Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => onFavoriteToggle?.call(product),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: product.isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title ?? 'No Title',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Category
                  if (product.category != null)
                    Text(
                      product.category!,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 24.0),

                  // Price and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      if (product.price != null)
                        Text(
                          '\$${product.price?.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),

                      // Rating
                      if (product.rating != null)
                        ProductRatingView(rating: product.rating!),
                    ],
                  ),
                  // Discount Badge
                  if (product.discountPercentage != null &&
                      product.discountPercentage! > 0)
                    ProductDiscountPercentageView(
                      discountPercentage: product.discountPercentage!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}