import 'package:flutter/foundation.dart';
import 'package:food_app/models/onboarding_model.dart';
import 'package:food_app/repositories/onboarding_repo.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final OnboardingRepository _onboardingRepository = OnboardingRepository();
  bool isLoading = false;
  List<OnboardingModel>? onboardingList;

  Future<void> fetchOnboardingData() async {
    isLoading = true;
    update();
    try {
      final response = await _onboardingRepository.fetchOnboardingData();
      if (response['status'] == 'success') {
        final data = response['data'] as List<dynamic>;


        onboardingList = data.map((item) => OnboardingModel.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load onboarding data');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isLoading = false;
      update();
    }
  }
}
