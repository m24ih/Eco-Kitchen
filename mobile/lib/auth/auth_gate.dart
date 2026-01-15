import "package:flutter/material.dart";

import "../backend/token_store.dart";
import "../screens/home.dart";
import "../screens/onboarding1.dart";

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> _loadToken() async {
    final tokenStore = TokenStore();
    final token = await tokenStore.getToken();
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _loadToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final token = snapshot.data;
        if (token == null || token.isEmpty) {
          return OnboardingScreen();
        }
        return HomeScreen();
      },
    );
  }
}
