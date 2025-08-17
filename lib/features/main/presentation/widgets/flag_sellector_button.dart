// import 'package:fire_todo/core/constants/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:fire_todo/core/constants/app_assets.dart';
// import 'package:fire_todo/shared/widgets/global_image.dart';

// class FlagSelectorButton extends StatefulWidget {
//   const FlagSelectorButton({super.key});

//   @override
//   State<FlagSelectorButton> createState() => _FlagSelectorButtonState();
// }

// class _FlagSelectorButtonState extends State<FlagSelectorButton> {
//   final List<String> flags = [
//     AppAssets.flagYellow,
//     AppAssets.flagOrange,
//     AppAssets.flagGreen,
//     AppAssets.flagRed,
//   ];

//   int currentIndex = 0;

//   void _nextFlag() {
//     setState(() {
//       currentIndex = (currentIndex + 1) % flags.length;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _nextFlag,
//       child: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: AppColors.darkGrey,
//           shape: BoxShape.circle,
//         ),
//         alignment: Alignment.center,
//         child: GlobalImage(flags[currentIndex], width: 24, height: 24),
//       ),
//     );
//   }
// }
