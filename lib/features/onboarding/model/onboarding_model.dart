import '../../../../generated/locale_keys.g.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });
}

List<OnboardingModel> onboardingPages = [
  OnboardingModel(
    title: LocaleKeys.onboarding_find_your_circle,
    description: LocaleKeys.onboarding_find_your_circle_desc,
    image: "assets/images/onboarding1.png",
  ),
  OnboardingModel(
    title: LocaleKeys.onboarding_express_yourself,
    description: LocaleKeys.onboarding_express_yourself_desc,
    image: "assets/images/onboarding2.png",
  ),
  OnboardingModel(
    title: LocaleKeys.onboarding_face_to_face,
    description: LocaleKeys.onboarding_face_to_face_desc,
    image: "assets/images/onboarding3.png",
  ),
  OnboardingModel(
    title: LocaleKeys.onboarding_share_the_moment,
    description: LocaleKeys.onboarding_share_the_moment_desc,
    image: "assets/images/onboarding4.png",
  ),
];
