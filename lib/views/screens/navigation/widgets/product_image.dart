import 'package:flutter/material.dart';

/// Default placeholder URL when product has no image or image fails to load.
const String _kDefaultPlaceholderUrl =
    'https://placehold.co/170x170/png?text=No+Image&font=roboto';

/// Default background color for fallback when image cannot be loaded.
const Color _kDefaultPlaceholderColor = Color(0xffF2F2F2);

/// Resolves the first valid image URL from [images] (e.g. [Product.images]).
/// Returns null if list is empty or first element is not a non-empty string.
String? resolveProductImageUrl(List<dynamic>? images) {
  return resolveProductImageUrlAt(images, 0);
}

/// Resolves the image URL at [index] from [images].
/// Returns null if index is out of range or element is not a non-empty string.
String? resolveProductImageUrlAt(List<dynamic>? images, int index) {
  if (images == null || index < 0 || index >= images.length) return null;
  if (images[index] is! String) return null;
  final candidate = images[index] as String;
  return candidate.isEmpty ? _kDefaultPlaceholderUrl : candidate;
}

/// Widget that loads a product image from [imageUrl].
/// If [imageUrl] is null or empty, or the network image fails,
/// shows a default placeholder (placeholder image or icon).
class ProductImageWidget extends StatelessWidget {
  /// The image URL to load. If null or empty, default placeholder is shown.
  final String? imageUrl;

  final double width;
  final double height;
  final BoxFit fit;

  const ProductImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  });

  Widget _buildPlaceholder() {
    return Image.network(
      _kDefaultPlaceholderUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildErrorFallback(),
    );
  }

  Widget _buildErrorFallback() {
    return Container(
      width: width,
      height: height,
      color: _kDefaultPlaceholderColor,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return _buildPlaceholder();
    }
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildErrorFallback(),
    );
  }
}
