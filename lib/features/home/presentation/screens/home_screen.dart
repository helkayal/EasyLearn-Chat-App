import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../chat/presenration/views/chats_tab_view.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/views/profile_tab_view.dart';
import '../../../settings/presenration/view/settings_tab_view.dart';
import '../cubit/navigation_cubit.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: Scaffold(
        body: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) {
            return IndexedStack(
              index: state,
              children: [ChatsTabView(), ProfileTabView(), SettingsTabView()],
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavBar(),
      ),
    );
  }
}
