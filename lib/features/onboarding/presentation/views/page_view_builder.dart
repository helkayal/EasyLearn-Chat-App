import 'package:flutter/material.dart';

import '../../model/onboarding_model.dart';
import '../cubit/onboarding_cubit.dart';

class PageViewBuilder extends StatelessWidget {
  const PageViewBuilder({
    super.key,
    required PageController pageController,
    required this.cubit,
    required this.theme,
  }) : _pageController = pageController;

  final PageController _pageController;
  final OnboardingCubit cubit;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
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
              Text(data.title, style: theme.textTheme.displayMedium),
              const SizedBox(height: 16),
              Text(
                data.description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
