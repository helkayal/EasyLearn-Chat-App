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
    title: "Find Your Circle",
    description:
        "Discover friends and communities that share your interests. Search by name or interest to start building your network.",
    image: "assets/images/onboarding1.png",
  ),
  OnboardingModel(
    title: "Express Yourself",
    description:
        "Connect through rich messaging. Use emojis and reactions to bring your conversations to life.",
    image: "assets/images/onboarding2.png",
  ),
  OnboardingModel(
    title: "Face-to-Face Anytime",
    description:
        "High-quality video and voice calls that make you feel like you're in the same room, no matter the distance.",
    image: "assets/images/onboarding3.png",
  ),
  OnboardingModel(
    title: "Share the Moment",
    description:
        "Easily send photos, videos, and files. Keep your friends updated on your daily adventures with one tap.",
    image: "assets/images/onboarding4.png",
  ),
];
