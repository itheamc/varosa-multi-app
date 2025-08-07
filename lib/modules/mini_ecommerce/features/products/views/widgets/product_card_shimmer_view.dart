import 'package:flutter/material.dart';
import 'package:varosa_multi_app/modules/common/widgets/shimmer.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

class ProductCardShimmerView extends StatelessWidget {
  const ProductCardShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Shimmer(
        loading: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  color: Colors.grey[200],
                ),
                clipBehavior: Clip.antiAlias,
                child: const Icon(
                  Icons.image_not_supported,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Shimmer.loadingContainer(
                    context,
                    width: context.width * 0.8,
                    height: 14.0,
                  ),
                  Shimmer.loadingContainer(
                    context,
                    width: context.width * 0.4,
                    height: 14.0,
                  ),
                  SizedBox(height: 4.0),
                  Shimmer.loadingContainer(
                    context,
                    width: context.width * 0.4,
                    height: 10.0,
                  ),
                  const SizedBox(height: 24.0),

                  // Price and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.loadingContainer(
                        context,
                        width: context.width * 0.20,
                        height: 14.0,
                      ),

                      Shimmer.loadingContainer(
                        context,
                        width: context.width * 0.1,
                        height: 14.0,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Shimmer.loadingContainer(
                    context,
                    width: context.width * 0.15,
                    height: 14.0,
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
