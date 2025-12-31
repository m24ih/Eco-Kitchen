import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Durum (State) Sınıfı: Verileri tutar
class OnboardingState {
  final DateTime? birthDate;
  final int? height;
  final int? weight;
  final double? activityLevel;
  final String? goal;

  OnboardingState({
    this.birthDate,
    this.height,
    this.weight,
    this.activityLevel,
    this.goal,
  });

  // Veriyi güncellemek için kopya oluşturma metodu
  OnboardingState copyWith({
    DateTime? birthDate,
    int? height,
    int? weight,
    double? activityLevel,
    String? goal,
  }) {
    return OnboardingState(
      birthDate: birthDate ?? this.birthDate,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
    );
  }
}

// 2. Yönetici (Notifier): Veriyi değiştirme yetkisi olan sınıf
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState());

  void setBirthDate(DateTime date) => state = state.copyWith(birthDate: date);
  void setHeight(int height) => state = state.copyWith(height: height);
  void setWeight(int weight) => state = state.copyWith(weight: weight);
  void setActivityLevel(double level) => state = state.copyWith(activityLevel: level);
  void setGoal(String goal) => state = state.copyWith(goal: goal);
}

// 3. Provider: Uygulamanın erişim noktası
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});
