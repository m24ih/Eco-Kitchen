import "package:flutter/material.dart";

import "../backend/onboarding_store.dart";
import "../backend/token_store.dart";
import "../screens/home.dart";
import "../screens/onboarding1.dart";
import "../screens/sign_in.dart";

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<_AuthState> _loadState() async {
    final onboardingStore = OnboardingStore();
    final tokenStore = TokenStore();
    final hasSeenOnboarding = await onboardingStore.hasSeenOnboarding();
    final token = await tokenStore.getToken();
    return _AuthState(
      hasSeenOnboarding: hasSeenOnboarding,
      token: token,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AuthState>(
      future: _loadState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final state = snapshot.data;
        if (state == null || !state.hasSeenOnboarding) {
          return OnboardingScreen();
        }
        final token = state.token;
        if (token == null || token.isEmpty) {
          return SignInScreen();
        }
        return HomeScreen();
      },
    );
  }
}

class _AuthState {
  final bool hasSeenOnboarding;
  final String? token;

  const _AuthState({
    required this.hasSeenOnboarding,
    required this.token,
  });
}
