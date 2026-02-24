// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../auth/presentation/screens/login_screen.dart';
// import '../../model/onboarding_model.dart';
// import '../cubit/onboarding_cubit.dart';
// import 'bottom_view.dart';

// class OnboardingView extends StatefulWidget {
//   const OnboardingView({super.key});

//   @override
//   State<OnboardingView> createState() => _OnboardingViewState();
// }

// class _OnboardingViewState extends State<OnboardingView> {
//   final PageController _pageController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<OnboardingCubit>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.topRight,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const LoginScreen(),
//                     ),
//                     (route) => false,
//                   );
//                 }, // Navigate to Auth
//                 child: const Text("Skip", style: TextStyle(color: Colors.grey)),
//               ),
//             ),
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: onboardingPages.length,
//                 onPageChanged: cubit.updatePage,
//                 itemBuilder: (context, index) {
//                   final data = onboardingPages[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(data.image, height: 250),
//                         const SizedBox(height: 40),
//                         Text(
//                           data.title,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           data.description,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             BottomView(pageController: _pageController),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/screens/login_screen.dart';
import '../../model/onboarding_model.dart';
import '../cubit/onboarding_cubit.dart';
import 'bottom_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final theme = Theme.of(context); // Access the centralized theme

    return Scaffold(
      // Background color is handled by scaffoldBackgroundColor in AppTheme
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button Section
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                // Uses the textButtonTheme defined in AppTheme
                child: const Text("Skip"),
              ),
            ),

            // Onboarding Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,
                onPageChanged: cubit.updatePage,
                itemBuilder: (context, index) {
                  final data = onboardingPages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(data.image, height: 250),
                        const SizedBox(height: 40),
                        Text(
                          data.title,
                          // Uses displayMedium from your TextTheme
                          style: theme.textTheme.displayMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data.description,
                          textAlign: TextAlign.center,
                          // Uses bodyMedium from your TextTheme
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Section (Dots and Buttons)
            BottomView(pageController: _pageController),
          ],
        ),
      ),
    );
  }
}
