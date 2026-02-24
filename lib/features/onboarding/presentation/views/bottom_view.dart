// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../auth/presentation/screens/login_screen.dart';
// import '../../model/onboarding_model.dart';
// import '../cubit/onboarding_cubit.dart';
// import '../cubit/onboarding_state.dart';
// import '../widgets/action_button.dart';
// import '../widgets/page_indicator.dart';

// class BottomView extends StatelessWidget {
//   const BottomView({super.key, required PageController pageController})
//     : _pageController = pageController;

//   final PageController _pageController;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<OnboardingCubit, OnboardingState>(
//       builder: (context, state) {
//         // State checks based on your onboarding_state.dart
//         bool isFirst = state.currentIndex == 0;
//         bool isLast = state.currentIndex == onboardingPages.length - 1;

//         return Padding(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             children: [
//               PageIndicator(
//                 currentIndex: state.currentIndex,
//                 itemCount: onboardingPages.length,
//               ),
//               const SizedBox(height: 40),
//               Row(
//                 children: [
//                   // Previous Button
//                   Expanded(
//                     child: ActionButton(
//                       label: "Previous",
//                       // Purple when active, grey when disabled
//                       backgroundColor: isFirst
//                           ? Colors.grey[300]!
//                           : const Color(0xFF7B2CBF),
//                       textColor: isFirst ? Colors.grey[600]! : Colors.white,
//                       onPressed: isFirst
//                           ? () {} // Nulling this out would be better if ActionButton supported it
//                           : () {
//                               _pageController.previousPage(
//                                 duration: const Duration(milliseconds: 300),
//                                 curve: Curves.easeOut,
//                               );
//                             },
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ActionButton(
//                       label: isLast ? "Get Started" : "Next",
//                       backgroundColor: const Color(0xFF7B2CBF),
//                       textColor: Colors.white,
//                       onPressed: () {
//                         if (isLast) {
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const LoginScreen(),
//                             ),
//                             (route) => false,
//                           );
//                         } else {
//                           _pageController.nextPage(
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.easeIn,
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart'; //
import '../../../auth/presentation/screens/login_screen.dart';
import '../../model/onboarding_model.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/action_button.dart';
import '../widgets/page_indicator.dart';

class BottomView extends StatelessWidget {
  const BottomView({super.key, required PageController pageController})
    : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        bool isFirst = state.currentIndex == 0;
        bool isLast = state.currentIndex == onboardingPages.length - 1;

        return Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              PageIndicator(
                currentIndex: state.currentIndex,
                itemCount: onboardingPages.length,
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      label: "Previous",
                      // Use semantic colors from AppColors
                      backgroundColor: isFirst
                          ? AppColors.disabledButton
                          : theme.primaryColor,
                      textColor: isFirst
                          ? AppColors.disabledText
                          : AppColors.white,
                      onPressed: isFirst
                          ? () {}
                          : () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ActionButton(
                      label: isLast ? "Get Started" : "Next",
                      backgroundColor: theme.primaryColor, //
                      textColor: AppColors.white, //
                      onPressed: () {
                        if (isLast) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
