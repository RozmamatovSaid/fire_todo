import 'package:fire_todo/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:fire_todo/features/category/presentation/screens/category_screen.dart';
import 'package:fire_todo/features/graph/presentation/screens/graph_screen.dart';
import 'package:fire_todo/features/home/presentation/screens/home_screen.dart';
import 'package:fire_todo/features/main/presentation/screens/main_scaffold_wrapper.dart';
import 'package:fire_todo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:fire_todo/features/settings/presentation/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  int? _preSelectedCategoryId;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    // SettingsCubit allaqachon global init() ni chaqirgan, shu holat'dan o'qiymiz
    _userName = context.read<SettingsCubit>().state.username;
  }

  // HomeScreendan selected category ID'ni olish uchun callback
  void _onCategoryChanged(int? categoryId) {
    setState(() {
      _preSelectedCategoryId = categoryId;
    });
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      // faqat username o'zgarganda react qiladi, isLoading'dan emas
      listenWhen: (previous, current) => previous.username != current.username,
      listener: (context, state) {
        setState(() {
          _userName = state.username;
        });
      },
      child: MainScaffoldWrapper(
        selectedIndex: selectedIndex,
        onTabChanged: (newIndex) => selectedIndex.value = newIndex,
        preSelectedCategoryId: _preSelectedCategoryId,
        body: ValueListenableBuilder<int>(
          valueListenable: selectedIndex,
          builder: (context, index, _) => IndexedStack(
            index: index,
            children: [
              HomeScreen(
                name: _userName.isEmpty ? 'User' : _userName,
                onSelectedCategoryChanged: _onCategoryChanged,
              ),
              const CalendarScreen(),
              const CategoryScreen(),
              const GraphScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
