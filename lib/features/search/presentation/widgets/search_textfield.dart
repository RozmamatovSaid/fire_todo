import 'package:fire_todo/core/router/router_paths.dart';
import 'package:fire_todo/features/main/index.dart';
import 'package:fire_todo/features/search/presentation/widgets/clickable_search_field.dart';
import 'package:flutter/material.dart';

class SearchTextfield extends StatelessWidget {
  final VoidCallback? onTap;

  const SearchTextfield({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return ClickableSearchTextField(onTap: onTap!);
    }

    return ClickableSearchTextField(
      onTap: () {
        context.push(RouterPaths.searchScreen);
      },
    );
  }
}
