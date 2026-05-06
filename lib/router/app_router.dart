import 'package:flutter/material.dart';
import 'package:smart_task/router/app_transitions.dart';
import '../screens/splash.dart';
import '../screens/login.dart';
import '../screens/signin.dart';
import '../screens/eula.dart';
import '../screens/onboarding.dart';
import '../screens/home.dart';
import '../screens/label.dart';


class AppRouter {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signin = '/signin';
  static const String eula = '/eula';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String label = '/label';

  static const String defaultRoute = '/';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case splash: 
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signin:
        return AppTransitions.slideUp(const SigninScreen());

      case eula:
        final args = settings.arguments as EulaContent;
        return AppTransitions.slideUp(EulaScreen(data: args));

      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case home: 
      return MaterialPageRoute(builder: (_) => const HomeScreen());

      case label:
        return MaterialPageRoute(builder: (_) => const LabelScreen());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
  
}