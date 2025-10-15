class OnboardingModel {
  final String heading;
  final String subHeading;
  final String image;

  OnboardingModel({
    required this.heading,
    required this.subHeading,
    required this.image,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      heading: json['heading'] ?? '',
      subHeading: json['sub_heading'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
