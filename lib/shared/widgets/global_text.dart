import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';

class GlobalText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final String fontFamily;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final bool? softWrap;
  final EdgeInsetsGeometry padding;
  final bool useTranslation;

  const GlobalText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.fontFamily = AppFonts.roboto,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.softWrap,
    this.padding = EdgeInsets.zero,
    this.useTranslation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        useTranslation ? text.tr() : text,
        maxLines: maxLines,
        softWrap: softWrap,
        overflow: overflow,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color ?? AppColors.white,
          fontFamily: fontFamily,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}
