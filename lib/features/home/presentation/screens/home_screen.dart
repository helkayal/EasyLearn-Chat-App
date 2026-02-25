import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../chat/presenration/views/chats_tab_view.dart';
import '../cubit/navigation_cubit.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: Scaffold(
        body: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) {
            return IndexedStack(
              index: state,
              children: const [
                ChatsTabView(),
                Center(child: Text("Profile Screen")),
                Center(child: Text("Settings Screen")),
              ],
            );
          },
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}
