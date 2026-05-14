import 'package:flutter/material.dart';

class AppTransitions {
  static Route slideUp(Widget page) {
    return _createRoute(page, const Offset(0, 1));
  }

  static Route slideDown(Widget page) {
    return _createRoute(page, const Offset(0, -1));
  }

  static Route slideLeft(Widget page) {
    return _createRoute(page, const Offset(1, 0));
  }

  static Route slideRight(Widget page) {
    return _createRoute(page, const Offset(-1, 0));
  }

  static Route _createRoute(Widget page, Offset beginOffset) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(curve),
          child: child,
        );
      },
    );
  }
}
