import 'package:fire_todo/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:fire_todo/features/category/presentation/screens/category_screen.dart';
import 'package:fire_todo/features/graph/presentation/screens/graph_screen.dart';
import 'package:fire_todo/features/home/presentation/screens/home_screen.dart';
import 'package:fire_todo/features/main/presentation/screens/main_scaffold_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  late Future<String?> _userNameFuture;
  int? _preSelectedCategoryId;

  @override
  void initState() {
    super.initState();
    _userNameFuture = _loadUserName();
  }

  Future<String?> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  // HomeScreendan selected category ID'ni olish uchun callback
  void _onCategoryChanged(int? categoryId) {
    setState(() {
      _preSelectedCategoryId = categoryId;
    });
    print('MainScreen: Category changed to $categoryId');
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _userNameFuture,
      builder: (context, snapshot) {
        final userName = snapshot.data ?? 'User';

        return MainScaffoldWrapper(
          selectedIndex: selectedIndex,
          onTabChanged: (newIndex) => selectedIndex.value = newIndex,
          preSelectedCategoryId: _preSelectedCategoryId,
          body: ValueListenableBuilder<int>(
            valueListenable: selectedIndex,
            builder: (context, index, _) => IndexedStack(
              index: index,
              children: [
                HomeScreen(
                  name: userName,
                  onSelectedCategoryChanged: _onCategoryChanged,
                ),
                const CalendarScreen(),
                const CategoryScreen(),
                const GraphScreen(),
              ],
            ),
          ),
        );
      },
    );
  }
}
