import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';

class GlobalImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final bool showLoading;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlobalImage(
    this.imagePath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.none,
    this.color,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.showLoading = true,
    this.backgroundColor,
    this.padding,
    this.margin,
  });

  // Automatically detect image type based on path
  bool get _isNetworkImage {
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  bool get _isSvgImage {
    return imagePath.toLowerCase().endsWith('.svg');
  }

  // ignore: unused_element
  bool get _isAssetImage {
    return !_isNetworkImage;
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImageWidget();

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    if (backgroundColor != null) {
      imageWidget = Container(
        width: width,
        height: height,
        color: backgroundColor,
        child: imageWidget,
      );
    }

    if (padding != null) {
      imageWidget = Padding(padding: padding!, child: imageWidget);
    }

    if (margin != null) {
      imageWidget = Container(margin: margin, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildImageWidget() {
    if (_isNetworkImage) {
      return _buildNetworkImage();
    } else if (_isSvgImage) {
      return _buildSvgImage();
    } else {
      return _buildAssetImage();
    }
  }

  Widget _buildNetworkImage() {
    return Image.network(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? _buildDefaultPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildDefaultErrorWidget();
      },
    );
  }

  Widget _buildSvgImage() {
    try {
      if (_isNetworkImage) {
        return SvgPicture.network(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          placeholderBuilder: (context) =>
              placeholder ?? _buildDefaultPlaceholder(),
        );
      } else {
        return SvgPicture.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          placeholderBuilder: (context) =>
              placeholder ?? _buildDefaultPlaceholder(),
        );
      }
    } catch (e) {
      return errorWidget ?? _buildDefaultErrorWidget();
    }
  }

  Widget _buildAssetImage() {
    try {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildDefaultErrorWidget();
        },
      );
    } catch (e) {
      return errorWidget ?? _buildDefaultErrorWidget();
    }
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? AppColors.grey500,
      child: showLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
                strokeWidth: 2,
              ),
            )
          : const Center(
              child: Icon(Icons.image, color: AppColors.grey300, size: 24),
            ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? AppColors.grey500,
      child: const Center(
        child: Icon(Icons.broken_image, color: AppColors.grey300, size: 24),
      ),
    );
  }
}
