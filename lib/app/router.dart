import 'package:flutter/material.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/confirm_account_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/profile_setup_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/sign_in_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/sign_up_page.dart';
import 'package:letaskono_flutter/features/auth/presentation/pages/splash_page.dart';
import 'package:letaskono_flutter/features/home/presentation/pages/home_page.dart';
import 'package:letaskono_flutter/features/home/presentation/pages/detail_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/confirm':
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (context) => ConfirmCodePage(
            email: args['email'] ?? '',
            password: args['password'] ?? '',
          ),
        );
      case '/profileSetup':
        return MaterialPageRoute(builder: (_) => const ProfileSetupPage());
      case '/signin':
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/detail':
        final int? userId = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => DetailPage(userId: userId),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }
}
